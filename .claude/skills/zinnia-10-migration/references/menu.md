# Migrate LegacyMenu / LegacyMenuItem → BetaMenuTrigger

Migrates `LegacyMenu` and `LegacyMenuItem` to the `BetaMenuTrigger*` flat components from `@zapier/design-system`. In v10, the former beta `MenuTrigger` compound component was moved into the main package and renamed with a `Beta` prefix. The dot-notation API (`MenuTrigger.Root`, `MenuTrigger.Item`) has been flattened to individual component imports (`BetaMenuTriggerRoot`, `BetaMenuTriggerItem`).

---

## Step 1: Find all LegacyMenu usages

```sh
rg "LegacyMenu" -t ts -g '!node_modules' -l
```

Work through each file one at a time.

## Step 2: Understand the structural change

**Legacy pattern** — simple list with click handlers:

```tsx
import { LegacyMenu, LegacyMenuItem } from '@zapier/design-system';

<LegacyMenu aria-label="Actions">
  <LegacyMenuItem onClick={() => handleEdit()}>Edit</LegacyMenuItem>
  <LegacyMenuItem onClick={() => handleDuplicate()}>Duplicate</LegacyMenuItem>
  <LegacyMenuItem onClick={() => handleDelete()}>Delete</LegacyMenuItem>
</LegacyMenu>
```

**New pattern** — flat components with trigger, popover, and list:

```tsx
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
    <BetaMenuTriggerList onAction={(key) => {
      if (key === 'edit') handleEdit();
      if (key === 'duplicate') handleDuplicate();
      if (key === 'delete') handleDelete();
    }}>
      <BetaMenuTriggerItem key="edit" id="edit">Edit</BetaMenuTriggerItem>
      <BetaMenuTriggerItem key="duplicate" id="duplicate">Duplicate</BetaMenuTriggerItem>
      <BetaMenuTriggerItem key="delete" id="delete" variant="danger">Delete</BetaMenuTriggerItem>
    </BetaMenuTriggerList>
  </BetaMenuTriggerPopover>
</BetaMenuTriggerRoot>
```

Key differences:
- Flat component imports (`BetaMenuTriggerRoot`, `BetaMenuTriggerPopover`, `BetaMenuTriggerList`, `BetaMenuTriggerItem`, `BetaMenuTriggerSeparator`) — all from `@zapier/design-system`
- Requires a trigger element (usually `Button` or `IconButton`) as the first child of `BetaMenuTriggerRoot`
- Click handlers move from individual items to `onAction` on the `BetaMenuTriggerList`
- Item identity via `id` prop (used as the `key` argument in `onAction`)
- Built-in popover positioning and keyboard navigation via React Aria
- `variant="danger"` on items for destructive actions

## Step 3: Migration recipe

### Basic menu migration

```tsx
// Before
import { LegacyMenu, LegacyMenuItem } from '@zapier/design-system';

<SomeTriggerComponent onClick={() => setMenuOpen(true)} />
{menuOpen && (
  <LegacyMenu aria-label="Options">
    <LegacyMenuItem onClick={() => { handleEdit(); setMenuOpen(false); }}>
      Edit
    </LegacyMenuItem>
    <LegacyMenuItem onClick={() => { handleDelete(); setMenuOpen(false); }}>
      Delete
    </LegacyMenuItem>
  </LegacyMenu>
)}

// After
import {
  BetaMenuTriggerRoot, BetaMenuTriggerPopover,
  BetaMenuTriggerList, BetaMenuTriggerItem, IconButton,
} from '@zapier/design-system';

<BetaMenuTriggerRoot>
  <IconButton aria-label="Options" name="moreHorizontal" variant="ghost" />
  <BetaMenuTriggerPopover>
    <BetaMenuTriggerList onAction={(key) => {
      if (key === 'edit') handleEdit();
      if (key === 'delete') handleDelete();
    }}>
      <BetaMenuTriggerItem id="edit">Edit</BetaMenuTriggerItem>
      <BetaMenuTriggerItem id="delete" variant="danger">Delete</BetaMenuTriggerItem>
    </BetaMenuTriggerList>
  </BetaMenuTriggerPopover>
</BetaMenuTriggerRoot>
```

### Component mapping

| Legacy | BetaMenuTrigger | Notes |
|--------|----------------|-------|
| `LegacyMenu` | `BetaMenuTriggerRoot` + `BetaMenuTriggerPopover` + `BetaMenuTriggerList` | Three-level structure replaces one |
| `LegacyMenuItem` | `BetaMenuTriggerItem` | Requires `id` prop |
| — | `BetaMenuTriggerSeparator` | New: visual divider between item groups |

### Prop mapping (LegacyMenu)

| LegacyMenu prop | BetaMenuTrigger equivalent | Notes |
|-----------------|---------------------------|-------|
| `aria-label` | `aria-label` on trigger element | Or use visible label on trigger button |
| `children` | `BetaMenuTriggerItem` children inside `BetaMenuTriggerList` | Structural change |
| `className` | `className` on `BetaMenuTriggerPopover` | For style overrides |
| `role` | — | React Aria sets `role="menu"` automatically |

### Prop mapping (LegacyMenuItem)

| LegacyMenuItem prop | BetaMenuTriggerItem prop | Notes |
|---------------------|-------------------------|-------|
| `onClick` | — | Use `onAction` on `BetaMenuTriggerList` instead |
| `children` | `children` | Preserved |
| `disabled` | `isDisabled` | Renamed |
| `href` | — | Not directly supported. Use `onAction` with navigation |
| `isSelected` | — | Not directly supported. Menus are action-based, not selection-based |
| `className` | `className` | Preserved |
| `role` | — | React Aria handles roles automatically |

## Step 4: Handle the trigger

The legacy `LegacyMenu` was typically shown/hidden with custom state management. `BetaMenuTrigger` handles this automatically — the first child of `BetaMenuTriggerRoot` becomes the trigger:

```tsx
<BetaMenuTriggerRoot>
  {/* This becomes the trigger that opens the menu */}
  <IconButton aria-label="More actions" name="moreHorizontal" variant="ghost" />
  <BetaMenuTriggerPopover>
    <BetaMenuTriggerList>
      ...
    </BetaMenuTriggerList>
  </BetaMenuTriggerPopover>
</BetaMenuTriggerRoot>
```

You can also use a regular `Button`:

```tsx
<BetaMenuTriggerRoot>
  <Button variant="secondary">Actions</Button>
  <BetaMenuTriggerPopover>
    ...
  </BetaMenuTriggerPopover>
</BetaMenuTriggerRoot>
```

Remove any manual open/close state management — `BetaMenuTriggerRoot` handles it internally.

## Step 5: Handle onClick → onAction

Individual `onClick` handlers on items need to be consolidated into a single `onAction` handler on the list:

```tsx
// Before — individual click handlers
<LegacyMenu aria-label="Actions">
  <LegacyMenuItem onClick={() => editItem(id)}>Edit</LegacyMenuItem>
  <LegacyMenuItem onClick={() => duplicateItem(id)}>Duplicate</LegacyMenuItem>
  <LegacyMenuItem onClick={() => deleteItem(id)}>Delete</LegacyMenuItem>
</LegacyMenu>

// After — consolidated onAction
<BetaMenuTriggerList onAction={(key) => {
  switch (key) {
    case 'edit': editItem(id); break;
    case 'duplicate': duplicateItem(id); break;
    case 'delete': deleteItem(id); break;
  }
}}>
  <BetaMenuTriggerItem id="edit">Edit</BetaMenuTriggerItem>
  <BetaMenuTriggerItem id="duplicate">Duplicate</BetaMenuTriggerItem>
  <BetaMenuTriggerItem id="delete" variant="danger">Delete</BetaMenuTriggerItem>
</BetaMenuTriggerList>
```

## Step 6: Handle menu items with href

If `LegacyMenuItem` used `href` for navigation links:

```tsx
// Before
<LegacyMenuItem href="/settings">Settings</LegacyMenuItem>

// After — use onAction with navigation
<BetaMenuTriggerList onAction={(key) => {
  if (key === 'settings') navigate('/settings');
}}>
  <BetaMenuTriggerItem id="settings">Settings</BetaMenuTriggerItem>
</BetaMenuTriggerList>
```

Ask the user what navigation function to use (e.g. `router.push`, `navigate` from React Router).

## Step 7: Handle separators

If the legacy menu used custom dividers between groups:

```tsx
// Before
<LegacyMenu aria-label="Actions">
  <LegacyMenuItem onClick={handleEdit}>Edit</LegacyMenuItem>
  <LegacyMenuItem onClick={handleDuplicate}>Duplicate</LegacyMenuItem>
  <hr /> {/* or custom divider */}
  <LegacyMenuItem onClick={handleDelete}>Delete</LegacyMenuItem>
</LegacyMenu>

// After
<BetaMenuTriggerList onAction={handleAction}>
  <BetaMenuTriggerItem id="edit">Edit</BetaMenuTriggerItem>
  <BetaMenuTriggerItem id="duplicate">Duplicate</BetaMenuTriggerItem>
  <BetaMenuTriggerSeparator />
  <BetaMenuTriggerItem id="delete" variant="danger">Delete</BetaMenuTriggerItem>
</BetaMenuTriggerList>
```

## Step 8: Handle size

`BetaMenuTriggerRoot` accepts a `size` prop that affects the menu item sizing:

```tsx
<BetaMenuTriggerRoot size="compact">
  ...
</BetaMenuTriggerRoot>
```

Available sizes: `'compact' | 'small' | 'medium' | 'large'` (default: `'medium'`).

## Step 9: Ask about complex cases

If the `LegacyMenu` had selection state (`isSelected`), ask the user:

> **This LegacyMenu uses `isSelected` on items, which suggests a selection/toggle pattern.** `BetaMenuTrigger` is designed for action menus, not selection menus.
>
> Options:
> 1. Convert to `MenuTrigger` and manage selection state externally (via visual indicators in item content)
> 2. Use a different component (e.g. `Select` for single selection, `Popover` for custom selection UI)
> 3. Keep as `LegacyMenu` for now
>
> Which approach fits your use case?

## Step 10: Verify

After migrating each file:

1. Run the type checker
2. Test that clicking the trigger opens the menu
3. Test that clicking an item fires the correct action and closes the menu
4. Test keyboard navigation — arrow keys between items, Enter to activate, Escape to close
5. Verify focus returns to the trigger after the menu closes
6. If using `variant="danger"`, verify the item has the correct visual treatment
