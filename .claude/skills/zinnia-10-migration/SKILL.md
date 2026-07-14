---
name: zinnia-10-migration
description: Migrate a consumer codebase from Zinnia v9 to v10. Runs the v10 codemod, then assists with upgrading Legacy-renamed components to their promoted replacements. Use when someone asks to upgrade, migrate, or move to Zinnia / Design System 10, or mentions Legacy component upgrades.
allowed-tools:
  - Bash(pnpm add:*)
  - Bash(pnpm remove:*)
  - Bash(pnpm install:*)
  - Bash(pnpm why:*)
  - Bash(pnpm dlx @zapier/zinniacli:*)
  - Bash(pnpm format:*)
  - Bash(pnpm lint:*)
  - Bash(pnpm typecheck:*)
  - Bash(pnpm test:*)
  - Bash(pnpm build:*)
  - Bash(pnpm exec eslint:*)
  - Bash(pnpm info:*)
  - Bash(npm whoami:*)
  - Bash(rg:*)
  - Bash(ls:*)
  - Read
  - Grep
  - Glob
metadata:
  tags:
    - code-quality
    - workflow
status: recommended
---

# Zinnia v10 Migration

Assists developers migrating a consumer codebase from `@zapier/design-system` v9 to v10. This skill runs the automated codemod and then walks through each component that requires manual migration.

**Reference:** The full upgrade guide lives in:

- the design system repo at https://gitlab.com/zapier/design-systems/design-system/-/blob/main/apps/storybook/stories/upgrading-from-v9-to-v10.mdx
- https://zinnia-storybook.zapier.com/?path=/docs/upgrading-from-v9-to-v10--docs

---

## Step 1: Detect the consumer codebase and framework

Verify you are operating inside the consumer's repository (check the workspace root). Then auto-detect the project setup:

**1a. Detect the framework and router** — look at dependencies and imports:

```sh
# Check package.json for framework
rg '"next"|"react-router"|"@tanstack/react-router"' package.json
```

Then confirm the router type by checking imports:

- `next/navigation` (Next.js App Router)
- `next/router` (Next.js Pages Router)
- `react-router-dom` (React Router)
- `@tanstack/react-router` (TanStack Router)

```sh
rg "from ['\"]next/navigation['\"]" -t ts -g '!node_modules' -l | head -3
rg "from ['\"]next/router['\"]" -t ts -g '!node_modules' -l | head -3
rg "from ['\"]react-router-dom['\"]" -t ts -g '!node_modules' -l | head -3
```

Store the detected framework and router type for use in later steps (e.g. DesignSystemProvider setup, Link migration).

**1b. Detect the source folder** — check the project structure:

```sh
ls -d src/ app/ packages/ 2>/dev/null
```

For monorepos with `packages/` and `apps/`, the codemod should target `./packages` and `./apps`. For single-package repos, target `./src` or `./app`. If ambiguous, ask the user.

**1c. Confirm with the user:**

> **I detected the following setup:**
>
> - Framework: [detected] ([router type])
> - Source folder: [detected]
>
> Does this look right? Anything I should know before starting?

## Step 2: Verify npm authentication

The `@zapier/*` packages are private scoped packages on the npm registry. The user must be authenticated to install them.

```sh
npm whoami
```

If this returns an error or "not logged in", ask the user to run `npm login` in their terminal (requires interactive browser auth — you cannot do this for them). Do not proceed until authentication is confirmed.

## Step 3: Install the new package versions

Scan the consumer's `package.json` files (root and all sub-packages for monorepos) to see which `@zapier` design system packages are currently used:

```sh
rg '"@zapier/design-system"|"@zapier/design-system-beta"|"@zapier/universal-layout"|"@zapier/design-tokens"|"@zapier/zinnia-icons"|"@zapier/design-system-context"' packages/*/package.json package.json
```

Install or update **only the packages that are already used** in the consumer:

| Package                         | v10 version   | Notes                                                                                    |
| ------------------------------- | ------------- | ---------------------------------------------------------------------------------------- |
| `@zapier/design-system`         | `^10.0.0`     | **Required** — the core package                                                          |
| `@zapier/design-system-beta`    | **uninstall** | All beta exports have moved into `@zapier/design-system` in v10. Uninstall this package. |
| `@zapier/universal-layout`      | `^13.0.0`     | Only if already used                                                                     |
| `@zapier/design-tokens`         | `^2.7.0`      | Only if already used                                                                     |
| `@zapier/zinnia-icons`          | `^1.7.0`      | Only if already used                                                                     |
| `@zapier/design-system-context` | **uninstall** | Absorbed into `@zapier/design-system`                                                    |

```sh
pnpm add @zapier/design-system@^10.0.0
pnpm add @zapier/universal-layout@^13.0.0   # if used
pnpm add @zapier/design-tokens@^2.7.0       # if used
pnpm add @zapier/zinnia-icons@^1.7.0        # if used
pnpm remove @zapier/design-system-beta      # uninstall
pnpm remove @zapier/design-system-context   # uninstall, if present
```

For monorepos, update the version in all sub-packages that depend on these packages.

If the root `package.json` contains `pnpm.overrides` entries that pin any of these packages to a v9 version range, **do not modify them yourself**. Report the offending entries to the user and ask them to update or remove the override. See the note on `pnpm.overrides` in Step 3d for background on why the agent leaves overrides alone.

After updating versions, install dependencies to resolve the lockfile:

```sh
pnpm install
```

Verify the installed versions by reading the `version` field from each installed package's manifest. For every design system package the consumer actually depends on, Read the corresponding `node_modules/<package>/package.json` and report its `version`:

- `node_modules/@zapier/design-system/package.json`
- `node_modules/@zapier/design-tokens/package.json` (if used)
- `node_modules/@zapier/zinnia-icons/package.json` (if used)
- `node_modules/@zapier/universal-layout/package.json` (if used)

If a file is missing, the package isn't installed at the top level — that's expected when the consumer doesn't depend on it directly.

### Step 3b: Upgrade @zapier/identity peer dependency

If the consumer uses `@zapier/universal-layout`, it now requires `@zapier/identity@^6.0.0` as a peer dependency (upgraded from `^2.x` in v13). Check whether the consumer has it and whether it needs upgrading:

```sh
rg '"@zapier/identity"' package.json packages/*/package.json 2>/dev/null
```

If the installed version is below `^6.0.0`, upgrade it:

```sh
pnpm add @zapier/identity@^6.0.0
```

**Breaking change in `@zapier/identity` v6:** `CurrentAccountIdProvider` was renamed to `IdentityProvider`. Search for the old name and replace it:

```sh
rg "CurrentAccountIdProvider" -t ts -g '!node_modules' -l
```

For each file found, replace the import and all JSX usages:

```tsx
// Before
import { CurrentAccountIdProvider } from '@zapier/identity';
<CurrentAccountIdProvider>...</CurrentAccountIdProvider>;

// After
import { IdentityProvider } from '@zapier/identity';
<IdentityProvider>...</IdentityProvider>;
```

### Step 3c: Upgrade react-aria peer dependencies

`@zapier/design-system` v10 requires `react-aria@^3.47.0` and `react-aria-components@^1.16.0` (bumped from `^3.39.0` / `^1.8.0` in v9). `@zapier/universal-layout` v13 also requires `react-aria-components@^1.16.0`.

Check the consumer's current versions:

```sh
rg '"react-aria"|"react-aria-components"' package.json packages/*/package.json 2>/dev/null
```

If the installed versions are below the new minimums, upgrade them:

```sh
pnpm add react-aria@^3.47.0 react-aria-components@^1.16.0
```

For monorepos, update in every sub-package that lists these as dependencies. These should be direct dependencies in the consumer to ensure a single copy is resolved (multiple versions of react-aria at runtime cause subtle bugs with shared context).

If the root `package.json` contains `pnpm.overrides` or `pnpm.peerDependencyRules` entries that pin `react-aria` or `react-aria-components` to older versions, **do not modify them yourself**. Surface the offending entries to the user so they can update or remove them.

After installing, verify that only **one version** of `@zapier/design-system` is resolved:

```sh
pnpm why @zapier/design-system --recursive
```

Count the distinct version lines in the output (lines matching `@zapier/design-system@X.Y.Z`). If only the v10 version appears, continue to Step 4.

If more than one version exists, proceed to Step 3d.

### Step 3d: Diagnose multiple versions of `@zapier/design-system`

**You (the agent) must not add, modify, or remove any `pnpm.overrides` entries as part of this migration.** Your job here is to diagnose _why_ extra copies exist and report that back to the user. The user can decide whether to pursue overrides themselves — see the note at the end of this step.

For each non-v10 version in the `pnpm why` output, trace the dependency chain back to identify which package pulls it in. Classify each into one of two categories:

**Design system packages** (`@zapier/design-system`, `@zapier/design-tokens`, `@zapier/zinnia-icons`, `@zapier/universal-layout`, `@zapier/zinniacli`) are published by the design system team. If one of these RC packages has a stale `^9.x` dependency on design-system, the consumer cannot fix this in their own `package.json` — the RC needs to be re-published by **#team-design-system**.

**All other `@zapier/*` packages** (e.g. `@zapier/templates`, `@zapier/upsells`, `@zapier/ai-toolkit`, `@zapier/copilot-ui`) are owned by other teams. The consumer can request an updated version from the owning team.

Present the results to the user as a table showing _why_ each extra version is installed:

> **Multiple versions of `@zapier/design-system` detected**
>
> | Extra version | Pulled in by                                            | Why it's here                                                                                                                                                                    |
> | ------------- | ------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
> | 9.34.1        | `@zapier/templates@4.x` via `design-system-beta@2.22.3` | `@zapier/templates` has not yet published a version that depends on design-system v10. Request an updated version from the owning team, or keep v9 in place until they catch up. |
>
> Extra copies add bundle weight and can cause runtime bugs (duplicate React contexts, mismatched component registries), so plan to resolve them before shipping to production.

Populate the table dynamically from the `pnpm why` output. The "Why it's here" column should explain the dependency chain in plain language so the user understands the root cause.

If the user decides to proceed despite extra copies (e.g. the v9 copies are isolated in packages the app doesn't actively render), that is acceptable — the migration can continue. Flag it so they revisit before shipping.

#### A note on `pnpm.overrides`

You may be tempted to ask the agent to add a `pnpm.overrides` entry (global or scoped) to force a specific version. **The agent will not do this, and we generally advise against it:**

- **Global overrides** (e.g. `"@zapier/design-system": "10.0.0-rc.X"`) force v10 onto transitive deps that were compiled against v9, which causes "export not found" errors at runtime.
- **Scoped overrides** (e.g. `"@zapier/templates>@zapier/design-system": "^9.0.0"`) avoid the runtime error but lock in the duplicate-copy problem, masking the real issue (a downstream package that needs updating) and leaving extra bundle weight in production.

Overrides are a temporary escape hatch, not a migration strategy. If you decide to add one yourself, do it deliberately, document why, and track the upstream fix so the override can be removed. The agent will not add, modify, or remove overrides on your behalf.

## Step 4: Run the v10 codemod

Run the codemod against the consumer's source folder:

```sh
pnpm dlx @zapier/zinniacli@latest transform v10 ./path/to/src
```

Replace `./path/to/src` with the source folder the user provided in Step 1.

The codemod handles most breaking changes automatically:

- Renames legacy components to `Legacy*` prefixed versions (e.g. `Link` → `LegacyLink`, `Modal` → `LegacyModal`, `Tooltip` → `LegacyTooltip`, `Dropdown` → `LegacyDropdown`, `Menu` → `LegacyMenu`, `Typeahead` → `LegacyTypeahead`, `FloatingBox` → `LegacyFloatingBox`)
- Removes `LegacyButton` / `LegacyIconButton` (replaces with `Button` / `IconButton`)
- Moves beta imports from `@zapier/design-system-beta` to `@zapier/design-system`, renaming unpromoted components with a `Beta` prefix (e.g. `DataTable` → `BetaDataTable`, `MenuTrigger` → `BetaMenuTriggerRoot`, `PageHeader` → `BetaPageHeader`, `SecondaryNav` → `BetaSecondaryNav`, `Shortcut` → `BetaShortcut`, `Card*` → `BetaCard*`, etc.)
- Flattens dot-notation APIs (e.g. `MenuTrigger.Item` → `BetaMenuTriggerItem`, `SecondaryNav.Title` → `BetaSecondaryNavTitle`)
- Moves `Icon`, `IconName`, `iconNames`, `isIconName` from `@zapier/design-system` to `@zapier/zinnia-icons`
- Renames `onSelectionChange` to `onChange` on Select
- Updates `Accordion` `onToggle` callback signature from `(state: { isOpen: boolean }) => void` to `(isOpen: boolean) => void`
- Removes `ZinniaProvider` wrapper
- Removes deprecated marketing components (`BackButton`, `DarkBackground*`)
- Removes `requiredText` prop
- Converts `Alert` `variant="alert"` to `variant="default"`

Review the codemod output for any warnings or errors. If the codemod reports issues, address them before proceeding.

## Step 5: Fix codemod import gaps

The codemod promotes components like `Select`, `SelectItem`, `Typeahead`, `TypeaheadItem`, `Checkbox`, `ModalDialog`, `Tooltip`, `Popover` from beta to the main `@zapier/design-system` package. It rewrites JSX to use these names but sometimes **fails to add the import**. Scan for this:

```sh
# Find files that use promoted components in JSX but don't import them
for comp in SelectItem TypeaheadItem; do
  rg "<$comp" -t ts -g '!node_modules' -l | while read f; do
    rg "import.*$comp.*from.*@zapier/design-system" "$f" > /dev/null 2>&1 || echo "MISSING $comp: $f"
  done
done
```

For each file reported, add the missing component to the existing `@zapier/design-system` import statement.

**Check for `Icon` imports that should have moved to `@zapier/zinnia-icons`:**

```sh
rg "import.*\bIcon\b.*from.*['\"]@zapier/design-system['\"]" -t ts -g '!node_modules' -l
```

Any remaining `Icon` imports from `@zapier/design-system` should be moved to `@zapier/zinnia-icons`. Note: `IconButton` stays in `@zapier/design-system` — only `Icon`, `IconName`, `iconNames`, and `isIconName` moved.

**Watch for naming conflicts:** If the project has a local interface or type with the same name as a promoted component (e.g. a local `interface TypeaheadItem`), rename the local type (e.g. to `FilterTypeaheadOption`) and update all references to it.

## Step 6: Run the project's checks and formatter

Detect how to run checks by inspecting `package.json` scripts. Read `package.json` and look at the `scripts` object for these common entries: `format`, `lint`, `typecheck`, `test`, `validate`. Use whichever ones the consumer actually defines.

Run format first:

```sh
pnpm format
```

Then run lint and fix any issues:

```sh
pnpm lint
```

Common lint issues after codemod:

- **Unused imports** — the codemod may leave behind type imports that were only used as generic parameters (e.g. `SnippetType` from `LegacyDropdown<SnippetType>`)
- **Unused variables** — variables like `pageById` that were only needed for the old data-driven API
- **Prettier formatting** — long import lines that need to be broken up
- **`unicorn/no-negated-condition`** — if you used `!==` in ternaries, flip to `===`

Fix all lint errors before proceeding. If the linter reports stale suppressions, prune them:

```sh
# For eslint flat config with suppressions
pnpm exec eslint --prune-suppressions 'src/**/*.{ts,tsx}'
```

## Step 7: Scan for Legacy components

Search the codebase for remaining `Legacy*` imports from `@zapier/design-system`:

```sh
rg "import.*Legacy(Link|Modal|Typeahead|Tooltip|TooltipWrapper|Dropdown|Menu|MenuItem|FloatingBox)" -t ts -g '!node_modules' -l
```

Also check for Divider usage that may need spacing adjustments:

```sh
rg "import.*Divider.*from ['\"]@zapier/design-system['\"]" -t ts -g '!node_modules' -l
```

Report what was found:

> **Post-codemod scan results:**
>
> | Component               | Files found |
> | ----------------------- | ----------- |
> | LegacyLink              | X files     |
> | LegacyModal             | X files     |
> | LegacyTypeahead         | X files     |
> | LegacyTooltip           | X files     |
> | LegacyDropdown          | X files     |
> | LegacyMenu              | X files     |
> | LegacyFloatingBox       | X files     |
> | Divider (spacing check) | X files     |
>
> I'll walk through each component that needs migration. Components with 0 files can be skipped.

## Step 8: Set up DesignSystemProvider for client-side routing

**This is required before migrating LegacyLink → Link.** The new `Link` uses React Aria's `RouterProvider`, which `DesignSystemProvider` renders when you pass it a `navigate` prop.

> **Important:** Do **not** remove the existing `LinkComponent` prop in this step. `LegacyLink` still relies on `LinkComponent` for client-side routing, so removing it now would break any `LegacyLink` instances that haven't been migrated yet. The `LinkComponent` prop is only removed at the end of the legacy Link migration in Step 9, once zero `LegacyLink` usages remain.

Find the existing `DesignSystemProvider`:

```sh
rg "DesignSystemProvider" -t ts -g '!node_modules' -l
```

Read the file to understand the current setup. Look for:

- `LinkComponent` prop (legacy pattern — keep it for now; the legacy Link migration in Step 9 removes it after all `LegacyLink`s are migrated)
- Whether `navigate` is already configured (if so, skip this step)
- What router imports are already present in the file

Use the framework/router detected in Step 1 to apply the correct change:

**Next.js App Router** — look for `next/navigation` imports in the file or nearby:

```tsx
import { useRouter } from 'next/navigation';

// Add navigate prop alongside the existing LinkComponent prop
<DesignSystemProvider navigate={useRouter().push} LinkComponent={...}>
```

If `useRouter` is already imported for other reasons, reuse it. If the component isn't a client component yet, add `'use client'` directive.

**Next.js Pages Router** — look for `next/router` imports:

```tsx
import { useRouter } from 'next/router';

const router = useRouter();
<DesignSystemProvider navigate={router.push} LinkComponent={...}>
```

**React Router v6+** — look for `react-router-dom` imports:

```tsx
import { useNavigate } from 'react-router-dom';

const navigate = useNavigate();
<DesignSystemProvider navigate={navigate} LinkComponent={...}>
```

In all cases:

1. Add the `navigate` prop
2. **Keep** the `LinkComponent` prop if present — it's still needed by any remaining `LegacyLink` components. It will be removed later (in the legacy migration Step 9) once no `LegacyLink`s remain.
3. Keep any other existing props on `DesignSystemProvider`

## Step 9: Migrate each Legacy component using the references

For each component that was found in Step 7, read and follow the corresponding reference. Work through them in this recommended order (dependencies first):

1. **Link** — Read and follow [the Link reference](references/link.md)
2. **Modal** — Read and follow [the Modal reference](references/modal.md)
3. **Tooltip** — Read and follow [the Tooltip reference](references/tooltip.md)
4. **Dropdown** — Read and follow [the Dropdown reference](references/dropdown.md)
5. **Typeahead** — Read and follow [the Typeahead reference](references/typeahead.md)
6. **FloatingBox** — Read and follow [the FloatingBox reference](references/floating-box.md)
7. **Menu** — Read and follow [the Menu reference](references/menu.md)
8. **Divider** — Read and follow [the Divider reference](references/divider.md)

Skip migrating any legacy component where no instances were found in Step 7.

For each legacy component, work through the files one at a time.

**After completing each component reference's steps** (not after each individual file), run the project's checks to catch issues early:

```sh
pnpm format
pnpm lint
pnpm typecheck
```

Common issues to watch for during migration:

- **Test mocks** — Tests that mock `@zapier/design-system` may not include newly promoted components (`ModalDialog`, `Select`, `SelectItem`, `Tooltip`, `Typeahead`, `TypeaheadItem`, `Checkbox`). Update mocks to use `importOriginal` pattern to spread all real exports and only override what's needed.
- **Event handler changes** — `onClick` → `onPress` for React Aria components; `PressEvent` does not support `preventDefault()`
- **Collection-based APIs** — `Typeahead`, `Select` now use children (`TypeaheadItem`, `SelectItem`) instead of `items` array prop

## Step 10: Update test mocks

Search for test files that mock `@zapier/design-system`:

```sh
rg "vi\.mock.*@zapier/design-system" -t ts -g "*.test.*" -g '!node_modules' -l
```

Update each mock to use the `importOriginal` pattern so new exports are automatically included:

```typescript
vi.mock('@zapier/design-system', async (importOriginal) => {
  const actual = await importOriginal<typeof import('@zapier/design-system')>();
  return {
    ...actual,
    // only override specific components that need mock behavior
  };
});
```

Also check for mocks of `@zapier/design-system-beta` that reference promoted components — those mocks should now target `@zapier/design-system`.

Run the full test suite and fix any failures:

```sh
pnpm test
```

## Step 11: Move remaining beta imports to main

`@zapier/design-system-beta` was uninstalled in Step 3. All its exports now live in `@zapier/design-system`. Search for any remaining beta imports:

```sh
rg "from ['\"]@zapier/design-system-beta['\"]" -t ts -g '!node_modules' -l
```

For each file, move the import to `@zapier/design-system`. The codemod should have handled most of these, but some may remain — especially in test files or files the codemod didn't reach.

When moving imports, note that beta components fall into two categories:

**Fully promoted (same name, just change the import source):**

- `Link`, `LinkProps`
- `Checkbox`, `CheckboxGroup` and props
- `Popover` and props
- `Radio`, `RadioGroup` and props
- `Tooltip`, `TooltipProps`, `TOOLTIP_PLACEMENTS`
- `Typeahead`, `TypeaheadItem`, `TypeaheadSection` and props
- `Select`, `SelectItem`, `SelectGroup` and props
- `ModalDialog` and related exports
- `ActionChip`, `ActionChipIcon` and props

**Beta-prefixed (must be renamed when moving to main):**

- `DataTable*` → `BetaDataTable*`, `useDataTableContext` → `useBetaDataTableContext`
- `MenuTrigger` → `BetaMenuTriggerRoot`, dot-notation flattened (e.g. `MenuTrigger.Item` → `BetaMenuTriggerItem`)
- `PageHeader` → `BetaPageHeader`, `PageHeaderBase` → `BetaPageHeaderBase`
- `SecondaryNav*` → `BetaSecondaryNav*`
- `Shortcut` → `BetaShortcut`
- `Card*` → `BetaCard*`
- `MultiTypeahead` → `BetaMultiTypeahead`
- `SegmentedControl*` → `BetaSegmentedControl*`
- `PageLayout` → `BetaPageLayout`
- `TextField` → `BetaTextField`
- `Carousel` → `BetaCarousel`

The codemod handles all of these renames automatically. If any are missed, refer to the `RENAME_MAP` in the codemod source (`apps/zinniacli/transforms/v10/moveBetaImports.ts`).

## Step 12: Clean up old packages

Verify that no imports remain for removed packages:

```sh
rg "@zapier/design-system-context" -t ts -g '!node_modules' -l
rg "@zapier/design-system-beta" -t ts -g '!node_modules' -l
```

If any remain, update them. Then confirm the packages are not in any `package.json`:

```sh
rg "design-system-beta|design-system-context" packages/*/package.json package.json
```

## Step 13: Audit transitive design system dependencies

Run the following to find all versions of `@zapier/design-system` in the resolved dependency tree:

```sh
pnpm why @zapier/design-system
```

If only the v10 version appears, proceed to Step 14.

If **other versions appear**, they are being pulled in by transitive dependencies that were compiled against an older version of the design system. For each, trace the chain back to the root package — it will look like:

```
@zapier/design-system@9.x.x
└─┬ @zapier/some-package@1.2.3
  └── this-project (dependencies)
```

**Check whether a `resolutions` or `pnpm.overrides` entry was added during this migration** to force all packages to use v10. Read `package.json` and inspect the top-level `resolutions` field and the `pnpm.overrides` field. If neither is present, there's nothing to flag.

If a `"@zapier/design-system"` entry exists in either `resolutions` or `pnpm.overrides`, **flag it to the user**:

> **⚠️ Design system version override detected**
>
> A `resolutions` or `pnpm.overrides` entry is forcing `@zapier/design-system` to v10 for all packages in the dependency tree, including ones that were compiled against v9. This can cause runtime errors like `Export Icon doesn't exist in target module` or `Export LegacyButton doesn't exist in target module` in compiled third-party packages.
>
> The conflicting packages are:
>
> | Package   | Version   | Imports from design-system    |
> | --------- | --------- | ----------------------------- |
> | [package] | [version] | [e.g. `Icon`, `LegacyButton`] |
>
> **Option A — Remove the override** (recommended): Remove the `"@zapier/design-system"` entry from `resolutions`/`pnpm.overrides`. This lets pnpm install the version each package needs. Your own code stays on v10; the transitive packages get their compatible v9. Bundle weight increases slightly until upstream packages are updated.
>
> **Option B — Upgrade the dependency**: Check if a newer version of `@zapier/[package-name]` exists that supports design-system v10:
>
> ```sh
> pnpm info @zapier/[package-name] versions --json | tail -5
> ```
>
> If a v10-compatible version exists, upgrade to it and re-run `pnpm why @zapier/design-system` to verify the conflict is gone.
>
> Which would you like to do?

Wait for the user's choice before making any changes. If the user chooses Option A, remove only the `"@zapier/design-system"` key from `resolutions`/`pnpm.overrides` and run `pnpm install`. If they choose Option B, upgrade the named package and verify the conflict is resolved.

After resolving, confirm the dev server no longer shows `Export X doesn't exist in target module` errors for design-system exports.

## Step 14: Final verification

Run the project's full validation suite. Use the scripts detected in Step 6:

```sh
pnpm format
pnpm lint
pnpm typecheck
pnpm test
pnpm build  # if applicable
```

Fix any remaining issues. Ignore pre-existing failures (failures that also occur on the base branch).

Report the final status:

> **v10 Migration Complete**
>
> | Check                                    | Status          |
> | ---------------------------------------- | --------------- |
> | Codemod applied                          | ✅              |
> | DesignSystemProvider configured          | ✅ / ⏭️ skipped |
> | LegacyLink → Link                        | ✅ / ⏭️         |
> | LegacyModal → ModalDialog                | ✅ / ⏭️         |
> | LegacyTooltip → Tooltip                  | ✅ / ⏭️         |
> | LegacyDropdown → Select                  | ✅ / ⏭️         |
> | LegacyTypeahead → Typeahead              | ✅ / ⏭️         |
> | LegacyFloatingBox → Popover              | ✅ / ⏭️         |
> | LegacyMenu → BetaMenuTrigger             | ✅ / ⏭️         |
> | Divider spacing                          | ✅ / ⏭️         |
> | Beta imports cleaned up                  | ✅              |
> | Transitive dependency conflicts resolved | ✅ / ⚠️ pending |
> | Type check passes                        | ✅              |
> | Tests pass                               | ✅              |
