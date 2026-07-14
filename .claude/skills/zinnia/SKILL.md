---
name: zinnia
description: Use when writing, editing, or reviewing React/TSX code in any Zapier project. Teaches correct Zinnia design system usage — component selection, design tokens, styling conventions, accessibility, and composition patterns.
status: recommended
---

# Develop with Zinnia

You are building UI in a Zapier project that uses the Zinnia design system. This skill teaches you how to discover and use Zinnia components, tokens, and conventions correctly. Follow it whenever you are writing, editing, or reviewing React/TSX code.

## Before You Start: Tool Checks

### Zinnia MCP

Check if zinnia-mcp tools are available by calling `list_components`. If they respond, use them as your primary reference for component APIs, tokens, and search throughout this skill.

If zinnia-mcp is not available, fall back to the conventions encoded in this skill and note in your output: "Zinnia MCP was not available — component and token references could not be validated. Install the Zinnia plugin for full validation."

### ZDev Docs

Check if `zdev docs search` is available by running a test query. If available, use it to look up Zinnia documentation for deeper guidance on patterns, conventions, and usage. ZDev docs are the canonical reference for _how_ and _why_ to apply design system patterns.

If ZDev is not available, rely on the conventions in this skill and MCP tool output. Note: "ZDev docs were not available — install ZDev CLI for access to full Zinnia documentation."

**Query crafting:** ZDev searches all Zapier docs, not just Zinnia. Always prefix queries with "zinnia" or "design system" to avoid unrelated results. Domain-specific terms like "react aria" or "storybook stories" work without a prefix. Generic terms like "migration" or "data attributes" need the prefix — use "zinnia migration" or "data-custom-component attribute".

## Component Selection Protocol

### Component Priority Ladder

When building any UI element, follow this priority order. Never skip to a lower tier without confirming the higher tiers don't apply:

1. **Use Zinnia components** — Check `@zapier/design-system` and `@zapier/design-system-beta` via `list_components` and `search`. Use existing components as-is or compose from Zinnia primitives (Button, Text, Input, etc.). This is the correct choice the vast majority of the time.
2. **Build custom with React Aria hooks** — If no Zinnia component exists for the interaction pattern, use React Aria hooks (`useButton`, `useComboBox`, `useMenu`, etc.) for accessibility and behavior, styled with Zinnia design tokens. Only use React Aria hooks — never its styled or primitive UI components.
3. **Build custom with Zinnia design tokens** — If React Aria doesn't cover the pattern, build from scratch using `var(--zds-*)` tokens for all colors, spacing, and typography. Mark with `data-custom-component` attribute for tracking.

### Discovery Steps

When you need a UI element, follow this sequence:

1. **Catalog** — Call `list_components` to see all available components and their packages.
2. **Search by purpose** — Call `search` with the element's purpose ("status indicator", "page header", "data table"). This finds components by behavior, not just name.
3. **Read docs** — Call `get_component_docs` for each candidate. This returns the correct import package, all props with types, deprecation status, and the recommended replacement if deprecated.
4. **Read examples** — For complex components (DataTable, PageHeader, Select, Modal, Tabs), call `get_component_examples` to see real Storybook usage patterns.
5. **Check ZDev** — If unsure about usage patterns or conventions, run `zdev docs search "zinnia <component-name>"` or `zdev docs search "developing with zinnia"` for broader guidance.

### Companion Component Relationships

These components are designed to work together. When you use one, check whether its companions are needed:

- **DataTable** → StatusChip (for status columns), Paginator (for pagination), Checkbox (for row selection)
- **PageHeader** → Breadcrumbs, Button (primary action)
- **Card** → Surface container for grouped content. CardRootButton and CardRootLink for clickable cards -- check `get_component_docs("Card")` for disclosure indicator guidance.
- **FormField** → FormLabel + Input/Select/Textarea + FormHelperText
- **IconButton** → Requires `aria-label`; import icons from `@zapier/zinnia-icons`

StatusChip is the most commonly missed companion — use it for any status indicator (Active, Expired, Pending, Error) instead of custom styled badges.

### Design-Element-to-Component Mapping

When analyzing a design, map each visual element to a Zinnia component before writing code:

| Visual Pattern                    | Likely Component         | Verify With                         |
| --------------------------------- | ------------------------ | ----------------------------------- |
| Page title + description + action | PageHeader               | `get_component_docs("PageHeader")`  |
| Breadcrumb trail                  | Breadcrumbs              | `get_component_docs("Breadcrumbs")` |
| Colored status label              | StatusChip               | `search("status")`                  |
| Tabular data                      | DataTable                | `get_component_docs("DataTable")`   |
| Search field                      | SearchInput or TextField | `search("search input")`            |
| Dropdown selector                 | Select (beta)            | `search("select dropdown")`         |
| Toggle switch                     | Switch                   | `get_component_docs("Switch")`      |
| Modal / dialog                    | Modal                    | `get_component_docs("Modal")`       |
| Toast notification                | Toast                    | `search("toast notification")`      |
| Empty state illustration          | EmptyState               | `search("empty state")`             |
| Paragraph text / body copy        | Text                     | `get_component_docs("Text")`        |
| Section heading / page title      | Heading                  | `get_component_docs("Heading")`     |
| Label / caption / description     | Text (with variant)      | `get_component_docs("Text")`        |
| Clickable card with chevron       | CardRootButton/CardRootLink + Icon | `get_component_docs("Card")`  |

If no Zinnia component exists for an element, use a semantic HTML element styled with tokens.

## Typography: Text and Heading Are Required

Every piece of visible text in a Zinnia project must use the `Text` or `Heading` component. These are foundational components on par with Button and DataTable — not optional utilities.

- Use `Heading` for all headings (page titles, section titles, card titles). Set the semantic level via the `level` prop.
- Use `Text` for all body copy, labels, captions, descriptions, and helper text.
- Raw `<span>`, `<p>`, `<div>`, and `<h1>`–`<h6>` for visible text content is never acceptable. These elements bypass the design system's typography tokens and break visual consistency.

Verify both components via `get_component_docs("Text")` and `get_component_docs("Heading")` for available props and variants.

## Design Token Discipline

Tokens are the #1 scoring differentiator in design system compliance. Every color, spacing, border, shadow, radius, and typography value must come from a design token.

### Token Discovery

1. Call `list_tokens` to see available categories.
2. Call `get_token_docs` with category `"semantic"` first — semantic tokens adapt to themes and are always preferred.
3. Only use `get_token_docs` with category `"primitive"` when no semantic token fits.
4. For deeper guidance, run `zdev docs search "zinnia design tokens"`.

### Token Rules

1. **Verify first, then write.** Call `list_tokens` or `get_token_docs` for the relevant category BEFORE writing any `var(--zds-*)` value into code. Do not write a token and verify later — verify first, then write. If a token doesn't appear in MCP results, don't use it.
2. **Semantic first.** Use semantic tokens before primitive tokens. Semantic tokens carry meaning (background-weaker, text-default) and adapt to themes.
3. **Never invent tokens.** If no token exists for a value, hardcode it and flag it for the design systems team. Do not fabricate token names by combining valid prefixes with assumed suffixes.
4. **Respect usage constraints.** Some semantic tokens have restrictions (e.g., "Only used for disabled elements"). Check `get_token_docs` before applying.
5. **Treat custom properties as imports.** Validate `var(--zds-*)` the same way you'd validate a component import — wrong names fail silently.
6. **Token scales have gaps.** Not every plausible name exists. Never assume a token is valid because its naming pattern looks correct — spacing, typography, and other scales skip certain increments. The only way to know what exists is to call `list_tokens`.
7. **When uncertain, say so.** If MCP is unavailable or results are ambiguous, flag the token as unverified rather than assuming it's valid.
8. **Never invent components.** Do not recommend design system primitives (Box, Stack, Flex, Inline) without verifying them via `list_components`.
9. **Semantic names in component props.** When a component accepts a named color prop (e.g., StatusChip `color`, Text `color`), prefer semantic color names (`TextWeaker`, `TextDefault`) over primitive names (`GrayWarm7`, `Blue8`). Semantic names adapt to themes and are more maintainable. Check `get_component_docs` for the accepted values.

### Token Verification Workflow

Follow this workflow every time you need a design token:

1. Identify the design value you need (e.g., a specific spacing, color, or font style).
2. Call `list_tokens` with the relevant category to see all available tokens.
3. If no exact match exists, choose the closest valid token from the MCP results or flag the mismatch for design review.
4. Only after confirming the token exists in MCP output, write it into code.

## Styling Conventions

### CSS Modules

Zinnia projects use CSS Modules for component styling:

- File naming: `ComponentName.module.scss` or `ComponentName.module.css`
- Import the reset mixin: `@use '../style-mixins/reset'` (path varies by project)
- Use `.root` as the top-level class for reset application
- All values via `var(--zds-*)` tokens — zero hardcoded colors, spacing, or font values

### Selector Specificity

Use `:where()` when targeting `[data]` attributes to keep specificity low:

```scss
:where([data-status='active']) {
  color: var(--zds-text-success);
}
```

### Data Attributes

Add `data-custom-component="{repo-name}::{description}"` on non-DS custom components. This enables design system analytics and debugging. Example: `data-custom-component="account-management::apps-table-row"`.

For deeper guidance on data attributes, run `zdev docs search "data-custom-component attribute"`.

## Code Quality

### Import Hygiene

Consolidate all imports from the same package into a single import statement. Never split imports from the same source across multiple lines.

```tsx
// Correct
import { DataTable, PageHeader, StatusChip, Text } from '@zapier/design-system-beta';

// Incorrect -- split imports from the same package
import { DataTable } from '@zapier/design-system-beta';
import { PageHeader, StatusChip } from '@zapier/design-system-beta';
import { Text } from '@zapier/design-system-beta';
```

### CSS Class Verification

After writing CSS Modules, verify every class defined in the `.module.scss` file is actually referenced in the corresponding JSX. Remove any unused classes before considering the component complete.

## Package Correctness

Zinnia components live in three packages:

| Package                      | Contents                                   |
| ---------------------------- | ------------------------------------------ |
| `@zapier/design-system`      | Stable components — production-ready       |
| `@zapier/design-system-beta` | Beta components — breaking changes allowed |
| `@zapier/zinnia-icons`       | Icon library                               |

Always verify the correct package using `get_component_docs`. The returned `package` field is authoritative. Do not guess — components occasionally move between stable and beta.

When recommending a component from a different package than what's currently installed, note the dependency change.

## Deprecation Awareness

When `get_component_docs` indicates a component is deprecated:

1. **Use the replacement**, not the deprecated component.
2. **Never fix props on a deprecated component** — flag the deprecation itself. If the component is being replaced, individual prop fixes are wasted effort.
3. **Don't apply new-system conventions to deprecated-system components.** Legacy components follow legacy patterns.

Common replacements:

| Deprecated                | Replacement            |
| ------------------------- | ---------------------- |
| Icon (from design-system) | `@zapier/zinnia-icons` |
| Dropdown                  | Select (beta)          |
| Checkbox                  | Checkbox (beta)        |
| Radio                     | RadioGroup (beta)      |
| Tooltip                   | Tooltip (beta)         |
| ButtonNav                 | FilterChipList (beta)  |

Always verify these with `get_component_docs` — the replacement may have changed.

## React Aria Conventions

Zinnia components built on React Aria use its prop conventions:

- `isDisabled` not `disabled`
- `isRequired` not `required`
- `isReadOnly` not `readOnly`
- `onPress` not `onClick` (for DS button-like components)
- `onSelectionChange` not `onChange` (for selection components)

When using DS components, always check the prop names from `get_component_docs`. Using HTML-native prop names on React Aria components will silently fail.

## Accessibility Baseline

Every implementation must meet these minimums:

- **Labels on interactive elements**: Every input, select, textarea, icon-only button must have a visible label (FormLabel) or `aria-label`/`aria-labelledby`.
- **Heading hierarchy**: h1 → h2 → h3 in logical order, no skipped levels. Use the Heading component's `level` prop.
- **Keyboard interaction**: All interactive elements must be keyboard-accessible. Never put `onClick`/`onPress` on a `<div>` or `<span>` without `role`, `tabIndex`, and keyboard event handlers. Use a `<button>` or DS component instead.
- **Touch targets**: Minimum 24x24px for all interactive elements. Don't override DS component sizing below this threshold.
- **Color contrast**: Don't rely on color alone to convey information. Status indicators need both a color and a text label.

## Icon Usage

- Import icons from `@zapier/zinnia-icons` — never use raw SVGs or `<img>` tags for icons.
- Use the `Icon` component for decorative/informational icons.
- Use `IconButton` for interactive icons — it requires an `aria-label`.
- Decorative icons should have `aria-hidden="true"`.

## Internationalization

If the project uses `next-intl` or another i18n system:

- All user-facing strings go through the translation system — no hardcoded string literals in JSX.
- Follow the project's existing namespace and key conventions (discover by reading existing translation files).
- Add translation entries for any new strings you introduce.

## Composition Patterns

When building pages, follow these structural patterns:

- **Page structure**: PageHeader at the top, content sections below, consistent spacing between sections using tokens.
- **Data display**: DataTable for tabular data, Card for grouped non-tabular content, EmptyState when no data exists.
- **Forms**: FormField wrapping each input with FormLabel and FormHelperText. Group related fields visually.
- **Navigation**: Breadcrumbs for hierarchical navigation, Tabs for same-page section switching.
- **Typography**: Heading for all headings (`<h1>`–`<h6>` must be replaced), Text for all body copy, labels, and descriptions (`<span>`, `<p>` must be replaced).

### Secondary UI Verification Pass

After building the main page layout, do a second pass comparing your implementation against the design for small, easily-missed elements:

- **Icons near text**: info icons (i), help icons, external link indicators
- **Disclosure indicators**: chevrons on clickable cards, expand/collapse arrows
- **Action icons**: filter icons on buttons, sort indicators on table headers
- **Decorative elements**: status dots, dividers, badges, avatars

For each element found in the design, verify it exists in your implementation. Use `search` or `get_component_docs` to find the correct Zinnia component for each (typically `Icon` from `@zapier/zinnia-icons` or `IconButton` for interactive icons).

## When You're Unsure

If you encounter an unfamiliar pattern or aren't sure which component to use:

1. `search` with a description of what you need.
2. `get_component_docs` on the closest match.
3. `zdev docs search "zinnia <topic>"` for conventions and guidance.
4. If none of these resolve it, use semantic HTML styled with tokens and note the uncertainty.
