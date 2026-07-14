# Migrate LegacyDropdown → Select

Migrates `LegacyDropdown` (the Downshift-based dropdown) to the promoted `Select` component in `@zapier/design-system` v10. Like the Typeahead migration, this involves moving from a data-driven API to React Aria's collection pattern.

---

## Step 1: Find all LegacyDropdown usages

```sh
rg "LegacyDropdown" -t ts -g '!node_modules' -l
```

Work through each file one at a time.

## Step 2: Understand the API difference

**Legacy pattern** — Downshift-based, data-driven:

```tsx
import { LegacyDropdown } from '@zapier/design-system';

const items = [
  { label: 'Captain', value: '1' },
  { label: '1st Mate', value: '2' },
  { label: 'Crew', value: '3' },
];

<LegacyDropdown
  items={items}
  label="Your role"
  selectedItem={selected}
  onSelect={(item) => setSelected(item)}
  getLabelForItem={(item) => item.label}
  getKeyForItem={(item) => item.value}
/>
```

**New pattern** — React Aria collection-based:

```tsx
import { Select, SelectItem } from '@zapier/design-system';

<Select
  label="Your role"
  selectedKey={selected?.value ?? null}
  onChange={(key) => {
    const item = items.find(i => i.value === key);
    setSelected(item);
  }}
>
  <SelectItem value="1">Captain</SelectItem>
  <SelectItem value="2">1st Mate</SelectItem>
  <SelectItem value="3">Crew</SelectItem>
</Select>
```

Key differences:
- Items are rendered as `SelectItem` children, not passed as a data array
- Selection is key-based (`selectedKey` / `onChange` with a `Key`) instead of item-object-based
- No `getLabelForItem` / `getKeyForItem`
- `label` is required and rendered as a visible field label
- Built-in field integration (`helpText`, `errorMessage`, `isLabelHidden`)

## Step 3: Migration recipe

### Basic migration

```tsx
// Before
import { LegacyDropdown } from '@zapier/design-system';

<LegacyDropdown
  items={options}
  label="Category"
  placeholder="Select a category"
  selectedItem={selected}
  onSelect={(item) => setSelected(item)}
  getLabelForItem={(item) => item.label}
  getKeyForItem={(item) => item.id}
/>

// After
import { Select, SelectItem } from '@zapier/design-system';

<Select
  label="Category"
  placeholder="Select a category"
  selectedKey={selected?.id ?? null}
  onChange={(key) => {
    const item = options.find(i => i.id === key);
    setSelected(item ?? null);
  }}
>
  {options.map(item => (
    <SelectItem key={item.id} value={item.id}>
      {item.label}
    </SelectItem>
  ))}
</Select>
```

### Prop mapping

| LegacyDropdown prop | Select prop | Notes |
|---------------------|------------|-------|
| `items` | — | Render `SelectItem` children instead |
| `label` | `label` | Preserved (now required) |
| `placeholder` | `placeholder` | Preserved |
| `selectedItem` | `selectedKey` | Pass the item's key instead of the item object |
| `initialSelectedItem` | `defaultSelectedKey` | Pass the key instead of the item object |
| `onSelect` | `onChange` | Receives `Key` instead of item object |
| `onChange` (input value) | — | Select doesn't have text input; use Typeahead for search |
| `getLabelForItem` | — | Removed. Use `SelectItem` children or `textValue` |
| `getKeyForItem` | — | Removed. Use `value` prop on `SelectItem` |
| `isDisabled` | `isDisabled` | Preserved |
| `isFullWidth` | — | Select fills its container by default |
| `isRequired` | `isRequired` | Preserved |
| `isErrored` | `isInvalid` | Renamed |
| `isReadonly` | — | Not directly supported; use `isDisabled` |
| `size` | `size` | Preserved (`'compact' \| 'medium' \| 'large'`) — note no `'small'` |
| `name` | `name` | Preserved |
| `inputId` | `id` | Renamed |
| `onBlur` | `onBlur` | Preserved |
| `onFocus` | `onFocus` | Preserved |
| `renderFloatingMenu` | — | Removed. Select handles its own popover |
| `renderIcon` | — | Removed |
| `renderButtonForItem` | — | Use `SelectItem` children for custom rendering |
| `menuAriaLabel` | — | React Aria handles listbox labeling |
| `disabledText` | — | Removed |
| `readOnlyText` | — | Removed |

### Field integration

The new `Select` has built-in field support — no need for a separate `Field` wrapper:

```tsx
// Before
<Field label="Category" helpText="Choose one" errorMessage={error}>
  <LegacyDropdown items={items} ... />
</Field>

// After
<Select
  label="Category"
  helpText="Choose one"
  errorMessage={error}
  isInvalid={!!error}
  ...
>
  {items.map(item => (
    <SelectItem key={item.id} value={item.id}>{item.label}</SelectItem>
  ))}
</Select>
```

If the label should be visually hidden (e.g., in a table cell):

```tsx
<Select label="Category" isLabelHidden ...>
  ...
</Select>
```

## Step 4: Handle custom item rendering

If items had custom rendering (icons, descriptions, etc.):

```tsx
// Before
<LegacyDropdown
  items={items}
  renderButtonForItem={(item) => (
    <div>
      <Icon name={item.icon} />
      <span>{item.label}</span>
    </div>
  )}
/>

// After — complex children with textValue
<Select label="Category" ...>
  {items.map(item => (
    <SelectItem key={item.id} value={item.id} textValue={item.label} iconName={item.icon}>
      {item.label}
    </SelectItem>
  ))}
</Select>
```

`SelectItem` has a built-in `iconName` prop for icons. For more complex custom rendering:

```tsx
<SelectItem value={item.id} textValue={item.label}>
  <div className="custom-item">
    <Avatar name={item.name} />
    <span>{item.label}</span>
    <span className="description">{item.description}</span>
  </div>
</SelectItem>
```

When `SelectItem` has complex children, provide `textValue` for accessibility.

## Step 5: Handle dynamic items

```tsx
// Before
const [items, setItems] = useState([]);
useEffect(() => { fetchItems().then(setItems); }, []);

<LegacyDropdown items={items} ... />

// After
<Select label="Category" ...>
  {items.map(item => (
    <SelectItem key={item.id} value={item.id}>{item.label}</SelectItem>
  ))}
</Select>
```

The dynamic items pattern is essentially the same — just render the items as children.

## Step 6: Handle searchable dropdowns

If the `LegacyDropdown` was being used as a searchable dropdown (with `onChange` for text filtering), use `Typeahead` instead of `Select`:

> **This LegacyDropdown appears to be used as a searchable dropdown** (it uses `onChange` to filter items based on text input). The `Select` component doesn't support text search.
>
> Should I migrate this to `Typeahead` instead? The `Typeahead` component supports search/filtering natively.

If yes, follow the [Typeahead reference](typeahead.md) instructions instead.

## Step 7: Verify

After migrating each file:

1. Run the type checker
2. Test that the select opens and displays all items
3. Test selection — click an item and verify `onChange` fires with the correct key
4. Verify the selected item label displays in the trigger
5. Test keyboard navigation — arrow keys, Enter to select, Escape to close
6. If using `errorMessage`, verify the error state displays correctly
