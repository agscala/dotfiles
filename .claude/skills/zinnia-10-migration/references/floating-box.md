# Migrate LegacyFloatingBox → Popover

Migrates `LegacyFloatingBox` (a viewport-aware positioned box with outside-click handling) to the `Popover` component in `@zapier/design-system` v10. The new `Popover` is built on React Aria and provides a proper dialog-based popover with accessibility features.

---

## Step 1: Find all LegacyFloatingBox usages

```sh
rg "LegacyFloatingBox" -t ts -g '!node_modules' -l
```

Work through each file one at a time.

## Step 2: Understand the structural change

**Legacy pattern** — positioned box with manual state:

```tsx
import { LegacyFloatingBox } from "@zapier/design-system";

const [isOpen, setIsOpen] = useState(false);

<div style={{ position: "relative" }}>
  <button onClick={() => setIsOpen(!isOpen)}>Toggle</button>
  {isOpen && (
    <LegacyFloatingBox
      align="left"
      position="south"
      onClickOutside={() => setIsOpen(false)}
    >
      <div>Popover content</div>
    </LegacyFloatingBox>
  )}
</div>;
```

**New pattern** — React Aria dialog popover with `DialogTrigger`:

```tsx
import { Popover } from "@zapier/design-system";
import { DialogTrigger } from "react-aria-components";
import { Button } from "@zapier/design-system";

<DialogTrigger>
  <Button>Toggle</Button>
  <Popover title="Options">
    <div>Popover content</div>
  </Popover>
</DialogTrigger>;
```

Or controlled:

```tsx
import { Popover } from "@zapier/design-system";
import { DialogTrigger } from "react-aria-components";
import { Button } from "@zapier/design-system";

const [isOpen, setIsOpen] = useState(false);

<DialogTrigger isOpen={isOpen} onOpenChange={setIsOpen}>
  <Button>Toggle</Button>
  <Popover title="Options">
    <div>Popover content</div>
  </Popover>
</DialogTrigger>;
```

Key differences:

- `Popover` must be used inside a `DialogTrigger` (from `react-aria-components`)
- The trigger is a sibling of `Popover` inside `DialogTrigger` (not a separate button)
- Positioning is automatic (React Aria handles placement and flipping)
- `onClickOutside` → built-in (Popover closes on outside interaction by default)
- `color` prop controls light/dark theme instead of `hasWhiteBackground`

## Step 3: Prop mapping

| LegacyFloatingBox prop                     | Popover prop / approach | Notes                                                            |
| ------------------------------------------ | ----------------------- | ---------------------------------------------------------------- |
| `align` (`'left' \| 'right' \| 'stretch'`) | `placement`             | See placement mapping below                                      |
| `position` (`'north' \| 'south'`)          | `placement`             | See placement mapping below                                      |
| `onClickOutside`                           | —                       | Built-in. Override with `shouldCloseOnInteractOutside` if needed |
| `hasWhiteBackground`                       | `color="light"`         | `color` defaults to `"dark"`; use `"light"` for white background |
| `maxWidth` / `minWidth`                    | `style` or `className`  | Apply width via CSS on the Popover                               |
| `borderRadius`                             | —                       | Handled by design tokens automatically                           |
| `borderColor`                              | —                       | Handled by design tokens automatically                           |
| `intersectHeight`                          | —                       | React Aria handles viewport-aware positioning                    |
| `children`                                 | `children`              | Preserved                                                        |

### Placement mapping

Combine the legacy `align` and `position` to determine `placement`:

| `position`          | `align`            | `placement`                                                |
| ------------------- | ------------------ | ---------------------------------------------------------- |
| `"south"` (default) | `"left"` (default) | `"bottom start"` (or `"bottom"`)                           |
| `"south"`           | `"right"`          | `"bottom end"`                                             |
| `"north"`           | `"left"`           | `"top start"` (or `"top"`)                                 |
| `"north"`           | `"right"`          | `"top end"`                                                |
| —                   | `"stretch"`        | Use `"bottom"` with CSS `width: 100%` on trigger container |

The full set of `placement` values supported:
`"bottom"`, `"bottom left"`, `"bottom right"`, `"bottom start"`, `"bottom end"`,
`"top"`, `"top left"`, `"top right"`, `"top start"`, `"top end"`,
`"left"`, `"left top"`, `"left bottom"`, `"right"`, `"right top"`, `"right bottom"`.

## Step 4: Basic migration

### Uncontrolled (recommended for simple cases)

```tsx
// Before
const [isOpen, setIsOpen] = useState(false);

<div style={{ position: "relative" }}>
  <Button onClick={() => setIsOpen(!isOpen)}>Options</Button>
  {isOpen && (
    <LegacyFloatingBox align="left" onClickOutside={() => setIsOpen(false)}>
      <p>Content here</p>
    </LegacyFloatingBox>
  )}
</div>;

// After (uncontrolled — DialogTrigger manages state)
import { DialogTrigger } from "react-aria-components";

<DialogTrigger>
  <Button>Options</Button>
  <Popover color="light" title="Options">
    <p>Content here</p>
  </Popover>
</DialogTrigger>;
```

### Controlled

```tsx
// Before
const [isOpen, setIsOpen] = useState(false);

<div style={{ position: "relative" }}>
  <Button onClick={() => setIsOpen(true)}>Open</Button>
  {isOpen && (
    <LegacyFloatingBox onClickOutside={() => setIsOpen(false)}>
      <div>
        <p>Content</p>
        <Button onClick={() => setIsOpen(false)}>Close</Button>
      </div>
    </LegacyFloatingBox>
  )}
</div>;

// After (controlled)
import { DialogTrigger } from "react-aria-components";

const [isOpen, setIsOpen] = useState(false);

<DialogTrigger isOpen={isOpen} onOpenChange={setIsOpen}>
  <Button>Open</Button>
  <Popover color="light" title="Options">
    <p>Content</p>
    <Button onPress={() => setIsOpen(false)}>Close</Button>
  </Popover>
</DialogTrigger>;
```

## Step 5: Handle onClickOutside customization

If `onClickOutside` had custom logic (not just closing):

```tsx
// Before
<LegacyFloatingBox
  onClickOutside={(event) => {
    if (hasUnsavedChanges) {
      showConfirmation();
    } else {
      setIsOpen(false);
    }
  }}
>
  ...
</LegacyFloatingBox>

// After — use shouldCloseOnInteractOutside
<Popover
  shouldCloseOnInteractOutside={(element) => {
    if (hasUnsavedChanges) {
      showConfirmation();
      return false;
    }
    return true;
  }}
>
  ...
</Popover>
```

## Step 6: Handle hasWhiteBackground

```tsx
// Before
<LegacyFloatingBox hasWhiteBackground>
  <div>Light content</div>
</LegacyFloatingBox>

// After
<Popover color="light">
  <div>Light content</div>
</Popover>
```

The default `color` for `Popover` is `"dark"`. If `LegacyFloatingBox` had `hasWhiteBackground={true}` (or was rendering on a light background), use `color="light"`.

## Step 7: Handle width constraints

```tsx
// Before
<LegacyFloatingBox maxWidth="400px" minWidth="200px">
  ...
</LegacyFloatingBox>

// After
<Popover style={{ maxWidth: '400px', minWidth: '200px' }}>
  ...
</Popover>
```

## Step 8: Handle title and close button

`Popover` has a built-in `title` prop and close button:

```tsx
<Popover title="Settings" color="light">
  <p>Popover content</p>
</Popover>
```

To hide the close button:

```tsx
<Popover title="Settings" isCloseHidden>
  ...
</Popover>
```

## Step 9: Handle edge cases

### FloatingBox used without a trigger

If `LegacyFloatingBox` was positioned absolutely without a clear trigger element, the migration is more complex. Ask the user:

> **This LegacyFloatingBox doesn't have an obvious trigger element.** The new `Popover` requires a `DialogTrigger` wrapper with a trigger element.
>
> Options:
>
> 1. Identify the actual trigger and wrap both in `DialogTrigger`
> 2. Use a controlled `DialogTrigger` where something else manages `isOpen`
> 3. Keep as `LegacyFloatingBox` for now
>
> How is this popover triggered?

### FloatingBox used for menus

If `LegacyFloatingBox` contained `LegacyMenu`, migrate both together — use `BetaMenuTrigger` from `@zapier/design-system` instead, which combines the trigger, popover, and menu:

```tsx
// Before
<div style={{ position: 'relative' }}>
  <IconButton onClick={() => setOpen(true)} ... />
  {open && (
    <LegacyFloatingBox onClickOutside={() => setOpen(false)}>
      <LegacyMenu aria-label="Actions">
        <LegacyMenuItem onClick={handleEdit}>Edit</LegacyMenuItem>
      </LegacyMenu>
    </LegacyFloatingBox>
  )}
</div>

// After — use MenuTrigger which combines trigger + popover + menu
import {
  BetaMenuTriggerRoot,
  BetaMenuTriggerPopover,
  BetaMenuTriggerList,
  BetaMenuTriggerItem,
  IconButton,
} from '@zapier/design-system';


<BetaMenuTriggerRoot>
  <IconButton aria-label="Actions" name="moreHorizontal" variant="ghost" />
  <BetaMenuTriggerPopover>
    <BetaMenuTriggerList onAction={(key) => { if (key === 'edit') handleEdit(); }}>
      <BetaMenuTriggerItem id="edit">Edit</BetaMenuTriggerItem>
    </BetaMenuTriggerList>
  </BetaMenuTriggerPopover>
</BetaMenuTriggerRoot>
```

## Step 10: Verify

After migrating each file:

1. Run the type checker
2. Test that clicking the trigger opens the popover
3. Test that clicking outside closes the popover
4. Test keyboard: Escape should close the popover
5. Verify focus management: focus moves into the popover on open and returns to trigger on close
6. Check placement — the popover should appear in the correct position relative to the trigger
