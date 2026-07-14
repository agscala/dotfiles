# Migrate LegacyTooltip / LegacyTooltipWrapper → Tooltip

Migrates `LegacyTooltip`, `LegacyTooltipWrapper` to the promoted `Tooltip` component in `@zapier/design-system` v10. The new `Tooltip` is built on React Aria and has a fundamentally different usage pattern — it combines the trigger and tooltip content into a single component.

---

## Step 1: Find all legacy tooltip usages

```sh
rg "LegacyTooltip" -t ts -g '!node_modules' -l
```

Work through each file one at a time.

## Step 2: Understand the structural change

**Legacy pattern** — separate tooltip + wrapper with render prop:

```tsx
import { LegacyTooltipWrapper } from '@zapier/design-system';

<LegacyTooltipWrapper
  content="Edit this item"
  position="north"
>
  {({ childProps }) => (
    <button {...childProps}>Edit</button>
  )}
</LegacyTooltipWrapper>
```

Or standalone `LegacyTooltip` positioned manually:

```tsx
import { LegacyTooltip } from '@zapier/design-system';

<div className="tooltip-container">
  <button aria-describedby="my-tooltip">Edit</button>
  <LegacyTooltip id="my-tooltip" position="north">
    Edit this item
  </LegacyTooltip>
</div>
```

**New pattern** — single `Tooltip` wrapping its trigger:

```tsx
import { Tooltip } from '@zapier/design-system';

<Tooltip content="Edit this item" placement="top">
  <IconButton aria-label="Edit" name="actionEdit" />
</Tooltip>
```

Key differences:
- `Tooltip` wraps its trigger child directly (no render prop needed)
- Tooltip text goes in the `content` prop (not children)
- `children` is the trigger element
- Placement uses React Aria values (`"top"`, `"bottom"`, etc.) instead of cardinal directions
- Trigger must be a focusable element (`Button`, `IconButton`, or `TooltipFocusableTrigger`)

## Step 3: Migrate LegacyTooltipWrapper

### Basic migration

```tsx
// Before
<LegacyTooltipWrapper content="Edit this item" position="north">
  {({ childProps }) => (
    <IconButton {...childProps} aria-label="Edit" icon="actionEdit" />
  )}
</LegacyTooltipWrapper>

// After
<Tooltip content="Edit this item" placement="top">
  <IconButton aria-label="Edit" name="actionEdit" />
</Tooltip>
```

### Placement mapping

| LegacyTooltipWrapper `position` | Tooltip `placement` |
|----------------------------------|---------------------|
| `"north"` | `"top"` |
| `"northeast"` | `"top right"` |
| `"northwest"` | `"top left"` |
| `"south"` (default) | `"bottom"` (default) |
| `"southeast"` | `"bottom right"` |
| `"southwest"` | `"bottom left"` |
| `"east"` | `"right"` |
| `"west"` | `"left"` |

### Prop mapping (LegacyTooltipWrapper → Tooltip)

| LegacyTooltipWrapper prop | Tooltip prop | Notes |
|---------------------------|-------------|-------|
| `content` | `content` | Same concept, now a direct prop (must be a `string`) |
| `position` | `placement` | See placement mapping above |
| `children` (render prop) | `children` (ReactNode) | No longer a render prop — just the trigger element |
| `shouldCorrectPosition` | — | Removed. React Aria handles flipping automatically |
| `isBlock` | — | Removed. Style the trigger directly |
| `showTooltipOnTouchDevices` | — | Removed. React Aria handles touch behavior |
| `tooltipAriaHidden` | — | Removed. React Aria manages aria attributes |
| `tooltipId` | `id` | For `aria-describedby` association |
| `allowMultilineTooltip` | `allowMultiline` | Preserved with slightly different name |
| `zIndex` | — | Removed. Use `className` or `style` if needed |

## Step 4: Migrate standalone LegacyTooltip

If `LegacyTooltip` was used standalone (not via `LegacyTooltipWrapper`), convert to the new `Tooltip` pattern:

```tsx
// Before
<div>
  <button aria-describedby="tip-1">Hover me</button>
  <LegacyTooltip id="tip-1" position="south">
    Helpful information
  </LegacyTooltip>
</div>

// After
<Tooltip content="Helpful information" placement="bottom">
  <TooltipFocusableTrigger>
    <button>Hover me</button>
  </TooltipFocusableTrigger>
</Tooltip>
```

## Step 5: Handle non-button triggers

The new `Tooltip` requires its child to be a focusable element. For triggers that aren't `Button` or `IconButton`, wrap them in `TooltipFocusableTrigger`:

```tsx
// Icon trigger
<Tooltip content="More information" placement="right">
  <TooltipFocusableTrigger>
    <Icon name="alertInfo" size={30} />
  </TooltipFocusableTrigger>
</Tooltip>

// Avatar trigger
<Tooltip content="Jane Doe" placement="bottom">
  <TooltipFocusableTrigger>
    <Avatar name="Jane Doe" />
  </TooltipFocusableTrigger>
</Tooltip>

// Custom element trigger
<Tooltip content="Click to copy" placement="top">
  <TooltipFocusableTrigger tag="div">
    <span>Some text</span>
  </TooltipFocusableTrigger>
</Tooltip>
```

`TooltipFocusableTrigger` accepts a `tag` prop (`'button'` | `'div'` | `'summary'`; default: `'button'`).

## Step 6: Handle controlled state

If the legacy code programmatically controlled tooltip visibility:

```tsx
// Before — manual state management
const [showTooltip, setShowTooltip] = useState(false);

<LegacyTooltipWrapper
  content={showTooltip ? "Visible" : ""}
  position="north"
>
  {({ childProps }) => <button {...childProps}>Hover</button>}
</LegacyTooltipWrapper>

// After — controlled via isOpen/onOpenChange
const [isOpen, setIsOpen] = useState(false);

<Tooltip
  content="Visible"
  placement="top"
  isOpen={isOpen}
  onOpenChange={setIsOpen}
>
  <Button>Hover</Button>
</Tooltip>
```

## Step 7: Handle edge cases

### Tooltip on disabled buttons

If a tooltip was shown on a disabled button, the new `Tooltip` still works — React Aria handles this. No changes needed.

### Empty content

If `content` was conditionally empty (e.g. `content={hasHelp ? "Help text" : ""}`), don't render the Tooltip when there's no content:

```tsx
// Before
<LegacyTooltipWrapper content={helpText || ""} position="south">
  {({ childProps }) => <button {...childProps}>?</button>}
</LegacyTooltipWrapper>

// After
{helpText ? (
  <Tooltip content={helpText} placement="bottom">
    <IconButton aria-label="Help" name="alertInfo" />
  </Tooltip>
) : (
  <IconButton aria-label="Help" name="alertInfo" />
)}
```

## Step 8: Verify

After migrating each file:

1. Run the type checker
2. Hover over triggers to verify tooltip appears in the correct position
3. Test keyboard: tooltip should show on focus and hide on blur/Escape
4. Verify `allowMultiline` works for long content
5. Check that `aria-describedby` is correctly associated (inspect DOM)
