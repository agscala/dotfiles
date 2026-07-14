# Migrate LegacyLink → Link

Migrates `LegacyLink` (renamed from the v9 `Link`) to the promoted `Link` component in `@zapier/design-system` v10. The new `Link` is built on React Aria and uses a different routing architecture and event system.

---

## Step 1: Ensure DesignSystemProvider is configured for routing

The new `Link` uses React Aria's `RouterProvider` for client-side navigation. `DesignSystemProvider` renders this automatically when you pass it a `navigate` prop. **This is a one-time setup at the app root.**

> **Important:** Do **not** remove the existing `LinkComponent` prop in this step. `LegacyLink` still relies on `LinkComponent` for client-side routing, so removing it now would break any `LegacyLink` instances that haven't been migrated yet. The `LinkComponent` prop is only removed in the final step of this reference, once zero `LegacyLink` usages remain.

Find the existing `DesignSystemProvider`:

```sh
rg "DesignSystemProvider" -t ts -g '!node_modules' -l
```

Read the file and check:
- If `navigate` prop is already present → skip this step
- If `LinkComponent` prop is present → keep it for now; it will be removed at the end of this reference after all `LegacyLink`s have been migrated

**Auto-detect the router** by looking at the project's imports and dependencies:

```sh
rg "from ['\"]next/navigation['\"]" -t ts -g '!node_modules' -l | head -3
rg "from ['\"]next/router['\"]" -t ts -g '!node_modules' -l | head -3
rg "from ['\"]react-router-dom['\"]" -t ts -g '!node_modules' -l | head -3
```

Apply the correct change based on what you find:

**Next.js App Router** (uses `next/navigation`):
- Import `useRouter` from `next/navigation`
- Pass `router.push` as the `navigate` prop
- **Keep** the `LinkComponent` prop for now

**Next.js Pages Router** (uses `next/router`):
- Import `useRouter` from `next/router`
- Pass `router.push` as the `navigate` prop
- **Keep** the `LinkComponent` prop for now

**React Router v6+** (uses `react-router-dom`):
- Import `useNavigate` from `react-router-dom`
- Pass `navigate` as the `navigate` prop
- **Keep** the `LinkComponent` prop for now

If the DesignSystemProvider file already imports a router hook (e.g. `useRouter` or `usePathname`), reuse it rather than adding a duplicate import. Keep any other existing props on `DesignSystemProvider`.

If running as part of the full `v10-migration` skill, this may already be done in Step 8 of the parent — check before repeating.

## Step 2: Find all LegacyLink usages

```sh
rg "LegacyLink" -t ts -g '!node_modules' -l
```

Work through each file one at a time.

## Step 3: Migrate each usage

For each `LegacyLink`, apply the following transformations:

### Import change

```tsx
// Before
import { LegacyLink } from '@zapier/design-system';

// After
import { Link } from '@zapier/design-system';
```

Also update any type imports:

```tsx
// Before
import type { LegacyLinkProps } from '@zapier/design-system';

// After
import type { LinkProps } from '@zapier/design-system';
```

### Prop mapping

| LegacyLink prop | Link prop | Notes |
|-----------------|-----------|-------|
| `href` | `href` | Preserved |
| `color` | `variant` | See variant mapping below |
| `weight` | — | Removed. Use CSS or `className` |
| `component` | — | Removed. Use `navigate` prop on `DesignSystemProvider` |
| `tabIndex` | — | Removed. Generally not needed; `href` makes it focusable |
| `title` | `aria-label` | Or use a `Tooltip` component |
| `onClick` | `onPress` | Event type changes from `MouseEvent` to `PressEvent` |
| `onMouseEnter` | `onHoverStart` | Event type changes to `HoverEvent` |
| `onMouseLeave` | `onHoverEnd` | Event type changes to `HoverEvent` |
| `onFocus` | `onFocus` | Preserved (uses `FocusEvent`) |
| `onBlur` | `onBlur` | Preserved (uses `FocusEvent`) |
| `target` | `target` | Preserved |
| `rel` | `rel` | Preserved |
| `className` | `className` | Preserved |
| `style` | `style` | Preserved |
| `aria-label` | `aria-label` | Preserved |
| `aria-current` | `aria-current` | Preserved |
| `children` | `children` | Preserved |

### Variant mapping (color → variant)

| LegacyLink `color` | Link `variant` |
|---------------------|----------------|
| `"primary"` | `"link"` (default, can omit) |
| `"dark"` | `"link"` |
| `"light"` | `"link"` with `inverted` prop |
| `"danger"` | `"danger"` |
| `"inherit"` | `"link"` with `className` for custom color |

If the `LegacyLink` had no `color` prop, the new `Link` can also omit `variant` (defaults to `"link"`).

### New props available

| Prop | Type | Description |
|------|------|-------------|
| `variant` | `'brand' \| 'danger' \| 'primary' \| 'secondary' \| 'tertiary' \| 'ghost' \| 'link'` | Visual style (default: `'link'`) |
| `size` | `'compact' \| 'small' \| 'medium' \| 'large'` | Size (default: `'medium'`) |
| `iconPosition` | `'start' \| 'end'` | **Required** when using Icon children |
| `inverted` | `boolean` | For dark backgrounds (only `'link'` variant) |
| `noReferrer` | `boolean` | Controls noreferrer (default: `true`) |
| `role` | `string` | ARIA role (e.g. `'menuitem'`) |

## Step 4: Handle event handler migration

### onClick → onPress

`PressEvent` does **not** have a `preventDefault()` method. React Aria's `Link` handles navigation automatically after `onPress` completes.

**Simple click tracking:**

```tsx
// Before
<LegacyLink href="/path" onClick={() => trackClick()}>
  Click me
</LegacyLink>

// After
<Link href="/path" onPress={() => trackClick()}>
  Click me
</Link>
```

**Analytics with preventDefault (fire-and-forget pattern):**

```tsx
// Before
<LegacyLink
  href="/destination"
  onClick={(event) => {
    event.preventDefault();
    trackAnalytics().finally(() => {
      window.location.href = '/destination';
    });
  }}
>
  Click me
</LegacyLink>

// After — fire-and-forget, Link navigates via href automatically
<Link
  href="/destination"
  onPress={() => {
    // Ensure keepalive: true in any fetch calls so the request
    // survives page navigation
    trackAnalytics();
  }}
>
  Click me
</Link>
```

> **Important:** If analytics uses `fetch()`, the consumer must include `keepalive: true` in fetch options. Otherwise the browser may cancel the request during navigation.

**Conditional navigation (preventDefault to stop navigation):**

If the old code used `preventDefault()` to conditionally prevent navigation, this pattern needs rethinking. Ask the user:

> **This LegacyLink uses `preventDefault()` to conditionally prevent navigation.** The new `Link` does not support `preventDefault()` on `PressEvent`. Options:
>
> 1. Use a `Button` instead (if this is really an action, not navigation)
> 2. Use `window.location.href` in `onPress` for conditional navigation
> 3. Keep as `LegacyLink` for now and revisit later
>
> Which approach do you prefer?

### onMouseEnter/onMouseLeave → onHoverStart/onHoverEnd

```tsx
// Before
<LegacyLink
  href="/path"
  onMouseEnter={() => prefetch()}
  onMouseLeave={() => cancelPrefetch()}
>
  Click me
</LegacyLink>

// After
<Link
  href="/path"
  onHoverStart={() => prefetch()}
  onHoverEnd={() => cancelPrefetch()}
>
  Click me
</Link>
```

## Step 5: Handle Icon children

If a `Link` contains an `Icon` child, `iconPosition` is **required**:

```tsx
// Before
<LegacyLink href="/path">
  <Icon name="arrowRight" /> Continue
</LegacyLink>

// After
<Link href="/path" iconPosition="start">
  <Icon name="arrowRight" /> Continue
</Link>
```

A dev warning will appear if `iconPosition` is missing when an Icon is detected.

## Step 6: Handle button-styled links

If a `LegacyLink` was styled to look like a button (common with `color="primary"` and custom CSS), use one of the button-like variants:

```tsx
// Link that looks like a primary button
<Link href="/path" variant="primary" size="medium">
  Go to dashboard
</Link>

// Link that looks like a secondary button
<Link href="/path" variant="secondary">
  Learn more
</Link>
```

## Step 7: Handle the `component` prop

If `LegacyLink` used a `component` prop (e.g. `component={RouterLink}` for React Router), remove it. The new `Link` uses `DesignSystemProvider`'s `navigate` prop for client-side routing instead:

```tsx
// Before
<LegacyLink href="/path" component={RouterLink}>
  Click me
</LegacyLink>

// After — no component prop needed, DesignSystemProvider handles routing
<Link href="/path">
  Click me
</Link>
```

## Step 8: Verify

After migrating each file:

1. Run the type checker to catch any prop type mismatches
2. Visually verify the links render correctly (especially styled variants)
3. Test that client-side navigation works (requires `navigate` on `DesignSystemProvider`)
4. Test any analytics/tracking still fires correctly

## Step 9: Remove the `LinkComponent` prop from `DesignSystemProvider`

**Only do this after all `LegacyLink` usages have been migrated.** Removing `LinkComponent` while any `LegacyLink` still exists will break client-side routing for those links.

Confirm zero `LegacyLink` usages remain:

```sh
rg "LegacyLink" -t ts -g '!node_modules'
```

If the command returns any results, do **not** proceed — finish migrating (or intentionally keeping) those usages first. If any `LegacyLink`s are being deliberately kept (e.g. a `preventDefault` case from Step 4 that the user chose to defer), leave `LinkComponent` in place and skip this step.

Once the search is clean, open the `DesignSystemProvider` file and:

1. Remove the `LinkComponent` prop from `<DesignSystemProvider>`
2. Remove any imports that were only used by `LinkComponent` (e.g. the legacy router `Link` import)
3. Re-run `pnpm typecheck` and `pnpm lint` to confirm nothing else referenced the removed import
