---
name: zinnia-contribute
description: Use when working inside the design-system repository to create or modify components in design-system-beta (or design-system). Covers file structure, SCSS conventions, React Aria integration, testing, and Storybook patterns.
status: recommended
---

# Contribute to Zinnia

You are creating or modifying a component in the Zapier design-system monorepo. This skill teaches the conventions for building components that meet the team's quality bar — covering file structure, styling, APIs, testing, and Storybook documentation.

## Before You Start

### Zinnia Docs (ZDev)

Before creating any new component, query ZDev for the latest conventions:

- `zdev docs search "design system component conventions"`
- `zdev docs search "zinnia scss"`
- `zdev docs search "react aria"`
- `zdev docs search "storybook stories"`

ZDev docs are the canonical reference. If ZDev is unavailable, follow the conventions in this skill and in sibling components.

### Zinnia MCP

Call `list_components` to verify MCP is available. Use it to:

- Confirm the component doesn't already exist under another name
- Study neighbor component APIs for consistency
- Discover tokens for styling
- Verify all `var(--zds-*)` references after implementation

### Verify: New vs Extend vs Compose

Before building anything new:

1. `list_components` — does this component already exist?
2. `search` — query by behavior ("file upload", "split button", "status banner") to find close matches.
3. `get_component_docs` — for 3–5 neighbor components. Study their props, events, and package.
4. `get_component_examples` — see usage patterns for neighbors.

If an existing component can be extended or composed to meet the need, prefer that over creating something new.

## React Aria: Mandatory for Interactive Components

All new interactive Zinnia components MUST wrap React Aria primitives. Do not implement custom interaction behavior (keyboard handling, focus management, ARIA attributes) from scratch.

**Zinnia's architecture pattern:** React Aria Component (RAC) primitive provides behavior and accessibility, then the Zinnia wrapper adds styling with tokens, `data-zds` attributes, and a Zinnia-specific API surface.

**Pre-implementation check:** Before writing any custom interaction logic, search React Aria documentation for an applicable hook or component. If a RAC primitive exists for the interaction pattern you need, wrap it.

**What "wrapping" means:**

- Import the RAC hook (e.g., `useButton`, `useCheckbox`, `useComboBox`, `useSelect`, `useMenu`), use it for behavior and accessibility, and apply Zinnia styling on top.
- Never import RAC's styled or primitive UI components — only hooks. For Zinnia's own primitives (Button, Text, Input), always use the Zinnia versions.
- Query `zdev docs search "react aria"` for Zinnia-specific wrapping conventions and examples.

## File Structure

Every component follows this structure within the package directory:

```
ComponentName/
├── ComponentName.tsx           # Component implementation
├── ComponentName.module.scss   # Styles (CSS Modules + tokens)
├── ComponentName.test.tsx      # Unit tests
├── ComponentName.stories.tsx   # Storybook stories
└── index.ts                    # Public exports
```

Match the exact naming and colocation patterns of sibling components in the same package. Read 2–3 existing components to confirm the patterns before creating files.

## Component Implementation

### TypeScript

- All components must be fully typed — no `any`.
- Export a props interface: `export interface ComponentNameProps { ... }`.
- Use `forwardRef` if the component wraps a DOM element that consumers may need to ref.
- Follow the naming conventions of neighbor components for prop names.

### React Aria

For interactive components, wrapping React Aria hooks is mandatory (see "React Aria: Mandatory for Interactive Components" above). Use the appropriate hook:

- `useButton`, `useTextField`, `useSelect`, `useCheckbox`, etc.
- Prop conventions: `isDisabled`, `isRequired`, `isReadOnly`, `onPress`, `onSelectionChange`.
- Focus management and keyboard interaction come from the hook — don't reimplement.

Query `zdev docs search "react aria"` for Zinnia-specific React Aria conventions.

### Props API Design

Before implementing, sketch the public API:

| Concern                    | Decision                                                                      |
| -------------------------- | ----------------------------------------------------------------------------- |
| Required vs optional props | Which props must the consumer provide?                                        |
| Variant / size enums       | What variants exist? Match naming with neighbors.                             |
| `isDisabled` / `isPending` | Boolean state props following React Aria conventions.                         |
| Children / slots           | Composition model — does it accept children, render props, or named slots?    |
| `className` passthrough    | Only if sibling components support it.                                        |
| Event handlers             | `onPress`, `onChange`, `onSelectionChange` — match the React Aria convention. |

## SCSS Conventions

### File Setup

```scss
@use '../style-mixins/reset';

.root {
  @include reset.root;
  // component styles using tokens
}
```

The exact `@use` path depends on the package structure — check sibling components for the correct relative path.

### Token-Only Values

All visual values must come from design tokens:

```scss
.root {
  padding: var(--zds-space-8) var(--zds-space-16);
  color: var(--zds-text-default);
  background: var(--zds-background-default);
  border: 1px solid var(--zds-stroke-default);
  border-radius: var(--zds-radius-4);
  font: var(--zds-typography-body);
}
```

Zero hardcoded hex colors, pixel spacing, or font families. After writing styles, validate every `var(--zds-*)` with `get_token_docs` to confirm the token exists.

### Low Specificity

Use `:where()` when targeting `[data]` attributes:

```scss
:where([data-variant='primary']) {
  background: var(--zds-background-selected);
}
```

### Semantic Over Primitive

Prefer semantic tokens (`--zds-background-weaker`, `--zds-text-default`) over primitive tokens (`--zds-color-gray-warm-5`). Semantic tokens adapt to themes; primitives don't.

## Testing

### Framework: Vitest + React Testing Library

- Use Vitest APIs (`describe`, `it`, `expect`, `vi`). Do not import from Jest.
- Import `screen` from `@testing-library/react` for all queries — do not destructure from `render()`.

```tsx
// Correct
render(<MyComponent />);
expect(screen.getByRole('button')).toBeInTheDocument();

// Incorrect — don't destructure from render
const { getByRole } = render(<MyComponent />);
```

### Test Structure

Follow Arrange-Act-Assert:

```tsx
it('calls onPress when clicked', async () => {
  // Arrange
  const onPress = vi.fn();
  render(<MyComponent onPress={onPress} />);

  // Act
  await userEvent.click(screen.getByRole('button'));

  // Assert
  expect(onPress).toHaveBeenCalledOnce();
});
```

### What to Test

- **Rendering**: Component renders without errors in default and variant states.
- **Props**: Each prop produces the expected output.
- **Interaction**: Click, keyboard, focus, and hover behaviors.
- **Accessibility**: Correct roles, labels, and ARIA attributes.
- **Edge cases**: Empty content, disabled state, loading state.

Test behavior, not implementation details. Don't test internal state or class names.

## Storybook

### File Format

Use CSF3 (Component Story Format 3) with `Meta` and `StoryObj`:

```tsx
import type { Meta, StoryObj } from '@storybook/react';
import { ComponentName } from './ComponentName';

const meta: Meta<typeof ComponentName> = {
  title: 'Category/ComponentName',
  component: ComponentName,
};

export default meta;
type Story = StoryObj<typeof ComponentName>;

/** Default state of the component. */
export const Default: Story = {
  args: {
    // default props
  },
};
```

### Story Coverage

Include stories for:

- **Default** — component with minimal required props.
- **Variants** — each visual variant (primary, secondary, danger, etc.).
- **States** — disabled, loading, error, empty.
- **Sizes** — if the component has size variants.
- **Interactive** — wire the primary handler so the story is functional. A DropZone story without `onDrop` or a Button story without `onPress` looks broken in Storybook.

### JSDoc Comments

Add JSDoc comments above each story export explaining what it demonstrates. These appear in Storybook's docs panel.

## Package Exports

Wire the new component into the package's public entry points exactly as sibling components do. Typically this means:

1. `export { ComponentName } from './ComponentName';` in the component's `index.ts`
2. Re-export from the package's main `index.ts` barrel file

Read sibling components to confirm the exact export pattern.

## Validation Checklist

Before considering the component complete:

1. **Lint**: `pnpm run lint` in the package directory — zero errors.
2. **Typecheck**: `pnpm run typecheck` — zero errors.
3. **Format**: `pnpm run format` — code matches the project formatter.
4. **Build**: `pnpm run build` (or `rush build` from root) — package builds cleanly.
5. **Tests**: `pnpm run test` — all tests pass.
6. **Token audit**: Use `get_token_docs` to verify every `var(--zds-*)` in the SCSS file exists.
7. **No hallucinated components**: Every DS component used in tests or stories exists in `list_components`.
8. **Storybook**: Stories render and interactive handlers work.

## Quality Bar

These are non-negotiable for any new Zinnia component:

- **No duplicate primitives** — if an existing component can compose to solve the need, prefer composition.
- **Tokens, not literals** — all colors, spacing, radius, typography, and motion use `var(--zds-*)`.
- **Accessibility by construction** — labels, roles, keyboard navigation, focus order.
- **Intentional APIs** — props typed and named consistently with MCP-documented neighbors.
- **Low-specificity styling** — CSS patterns match sibling components.
- **Monorepo hygiene** — package boundaries, exports, stories, and tests match sibling patterns.
- **Zero hallucination** — every token, component, and prop reference verified against MCP or sibling code.

## String Safety

All string literals in `.tsx` and `.stories.tsx` files must use ASCII-safe characters only. Never emit Unicode curly quotes (`"` `"` `'` `'`) — use straight quotes.
