---
name: auth-subpath
description: Implement authentication for a Zapier frontend app deployed on a subpath (e.g., zapier.com/your-app). Uses JWT cookie refresh via @zapier/identity SessionProvider. Use when the user says "add auth", "setup authentication", "subpath auth", or asks to implement login for a subpath-deployed service.
user-invocable: true
argument-hint: <service-repo-path>
metadata:
  type: recipe
  tags:
    - security
    - infrastructure

allowed-tools: Read, Write, Edit, Glob, Grep, AskUserQuestion, Bash(pnpm add:*), Bash(npm install:*), Bash(ls:*), Bash(cat package.json:*)
---

# Subpath App Authentication

You are implementing authentication for a Zapier frontend app on a **subpath** (e.g. `zapier.com/your-app`) using JWT cookie refresh via `@zapier/identity` SessionProvider.

Services using this pattern today: Chatbots.

No OAuth flow is needed. The app shares cookies with zapier.com since it's on the same domain. The `SessionProvider` component refreshes a JWT cookie automatically.

## Phase 1: Discovery

1. Read the target service's repo structure. Look for:
   - `package.json` — check for existing `@zapier/identity` dependency (must be >= 5.0.0)
   - `next.config.js` or `next.config.ts` — check for existing rewrites/proxy config
   - `src/pages/api/proxy/` — check if a proxy route exists
   - `src/app/api/bridge/` — check if bridge routes exist
   - `.env.example` or `.env.local` — check for existing auth env vars
   - Root layout or `_app.tsx` — check for existing providers

2. STOP. Use AskUserQuestion to present your findings and confirm:
   - "What is the subpath for this app?" (e.g. `/app/chatbots`)
   - Whether any of the implementation steps have already been completed
   - Which backend services the app needs to call through the bridge

## Phase 2: Install Dependencies

Install if not already present:

```
pnpm add @zapier/identity@^5.0.0
```

## Phase 3: Create Local Proxy

The local environment needs auth cookies (`ssohint`, `zapsession`, `__Host-session.jwt`, `currentAccountId`, `csrftoken`). These are set on zapier.com, so a proxy is needed to relay them to localhost.

CRITICAL: This step has three parts. Refer to the Chatbots examples linked below for each.

### 3a. Create proxy API route

Create `src/pages/api/proxy/[[...path]].ts` (Pages router) that proxies requests to zapier-staging.com.

Reference: [Chatbots proxy route](https://gitlab.com/zapier/team-fpv/chatbots/-/blob/6fa3c50d84ff0499c20161db02e38829379258cc/packages/service/src/pages/api/proxy/%5B%5B...path%5D%5D.ts)

### 3b. Add rewrite fallback

In `next.config.js`, add a rewrite rule that forwards unmatched requests to the proxy route in non-production environments.

Reference: [Chatbots next.config.js](https://gitlab.com/zapier/team-fpv/chatbots/-/blob/6fa3c50d84ff0499c20161db02e38829379258cc/packages/service/next.config.js#L217)

### 3c. Cookie name rewriting for localhost

The `__Host-` cookie prefix requires HTTPS + same-origin, which localhost doesn't have. The proxy MUST strip this prefix on localhost only (keep it for reviewlabs).

Reference: [Chatbots cookie rewrite](https://gitlab.com/zapier/team-fpv/chatbots/-/blob/6fa3c50d84ff0499c20161db02e38829379258cc/packages/service/src/pages/api/proxy/%5B%5B...path%5D%5D.ts#L65)

STOP. Present the proxy setup and use AskUserQuestion to confirm before continuing.

## Phase 4: Create Bridge API Route

Create `src/app/api/bridge/[...path]/route.tsx`:

```typescript
import { NextRequest } from "next/server";
import { handleBridgeRequest } from "@zapier/identity/server";

async function handler(req: NextRequest) {
  return handleBridgeRequest(req);
}

export { handler as GET, handler as POST, handler as PUT, handler as PATCH, handler as DELETE };
```

If the app needs to point the bridge at a local backend during development, add a `serviceMap`:

```typescript
const bridgeOptions = {
  serviceMap: { myservice: `${process.env.MY_SERVICE_API_BASE_URL}` },
};

async function handler(req: NextRequest) {
  return handleBridgeRequest(req, bridgeOptions);
}
```

In staging/production, ATC Lambda@Edge handles bridge routing instead of this route.

## Phase 5: Add SessionProvider and IdentityProvider

Add to the app's root layout (App Router) or `_app.tsx` (Pages Router):

```typescript
import { SessionProvider, IdentityProvider } from "@zapier/identity";

// In root layout or _app.tsx:
<IdentityProvider>
  <SessionProvider>
    {children}
  </SessionProvider>
</IdentityProvider>
```

The `SessionProvider`:
- Calls `/api/v4/jwt/refresh` to set the `__Host-session.jwt` cookie
- Refreshes every 10 minutes
- Syncs across tabs (only one request fires even with multiple tabs)
- Backend rate-limits to 1 refresh per 5 minutes per session+account

## Phase 6: Add Login Check

Add a login check to determine if the user is authenticated:

**Frontend:**
```typescript
const response = await fetch("/api/bridge/identity/v4/whoami/");
const data = await response.json();
if (!data.is_logged_in) {
  window.location.href = `https://zapier.com/login?next=https://zapier.com/YOUR_SUBPATH`;
}
```

**Backend (server-side):**
Pass the `__Host-session.jwt` cookie in a `Cookie` header to the same endpoint.

## Phase 7: Add Bridge Client Usage

The bridge client handles CSRF headers and automatic JWT refresh on 401 responses.

**Fetch client:**
```typescript
import { getSubpathBridgeClientFetch } from "@zapier/identity/client/fetch";

const apiClient = getSubpathBridgeClientFetch("SERVICE_NAME");
```

**openapi-fetch client:**
```typescript
import { createSubpathBridgeClient } from "@zapier/identity/client/openapi-fetch";

const apiClient = createSubpathBridgeClient("SERVICE_NAME", createServiceFetchClient);
```

Use AskUserQuestion to ask which client approach the user prefers.

## Phase 8: Inform User About Bridge Coverage

Tell the user:

> **Verify your bridge services are configured:**
>
> Check the [global bridge config](https://gitlab.com/zapier/team-sre/cloud-team/atc-rules/-/blob/main/rules/global/bridge-prod.yaml) for staging/production. Currently supported: functions, tables, edge, identity, billing.
>
> For additional services, submit an MR to atc-rules or ask in **#wg-atc**.

## Subpath vs Subdomain

If you determine the app is on a **subdomain** (e.g. `your-app.zapier.com`) rather than a subpath, STOP and tell the user to use the `auth-subdomain` skill instead.

## Common Mistakes

- NEVER set `dev_mode: true` in production.
- The JWT cookie is `__Host-session.jwt` in production but needs `__Host-` prefix stripped on localhost.
- The `SessionProvider` MUST be wrapped in `IdentityProvider`, not the other way around.
- Do NOT create a NextAuth/OAuth config for subpath apps — that is the subdomain pattern.
