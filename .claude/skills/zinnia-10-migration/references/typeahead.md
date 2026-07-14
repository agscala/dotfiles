# Migrate LegacyTypeahead → Typeahead

Migrates `LegacyTypeahead` (the Downshift-based autocomplete) to the promoted `Typeahead` component in `@zapier/design-system` v10. This is one of the more complex migrations because the two components have fundamentally different APIs — the legacy version is data-driven (pass an `items` array) while the new version uses React Aria's collection pattern (render `TypeaheadItem` children).

---

## Step 1: Find all LegacyTypeahead usages

```sh
rg "LegacyTypeahead" -t ts -g '!node_modules' -l
```

Work through each file one at a time. This migration requires careful attention because the APIs are very different.

## Step 2: Understand the API difference

**Legacy pattern** — Downshift-based, data-driven:

```tsx
import { LegacyTypeahead } from '@zapier/design-system';

const items = [
  { label: 'Apple', value: 'apple' },
  { label: 'Banana', value: 'banana' },
  { label: 'Cherry', value: 'cherry' },
];

<LegacyTypeahead
  items={items}
  label="Fruit"
  placeholder="Search fruits..."
  selectedItem={selectedItem}
  onSelect={(item) => setSelectedItem(item)}
  onChange={(value) => setInputValue(value)}
  getLabelForItem={(item) => item.label}
  getKeyForItem={(item) => item.value}
/>
```

**New pattern** — React Aria collection-based:

```tsx
import { Typeahead, TypeaheadItem } from '@zapier/design-system';

<Typeahead
  label="Fruit"
  placeholder="Search fruits..."
  selectedKey={selectedItem?.value ?? null}
  onChange={(key) => {
    const item = items.find(i => i.value === key);
    setSelectedItem(item);
  }}
>
  {items.map(item => (
    <TypeaheadItem key={item.value} id={item.value}>
      {item.label}
    </TypeaheadItem>
  ))}
</Typeahead>
```

Key differences:
- Items are rendered as `TypeaheadItem` children, not passed as a data array
- Selection is key-based (`selectedKey` / `onChange` with a `Key`) instead of item-object-based
- No `getLabelForItem` / `getKeyForItem` — items self-describe via `id` and children
- Built-in filtering — the new Typeahead filters items automatically based on input
- `onSelect` → `onChange` (renamed in v10, was `onSelectionChange` in beta)

## Step 3: Migration recipe

### Basic migration

```tsx
// Before
import { LegacyTypeahead } from '@zapier/design-system';

<LegacyTypeahead
  items={items}
  label="Choose a fruit"
  placeholder="Search..."
  selectedItem={selected}
  onSelect={(item) => setSelected(item)}
  getLabelForItem={(item) => item.label}
  getKeyForItem={(item) => item.value}
/>

// After
import { Typeahead, TypeaheadItem } from '@zapier/design-system';

<Typeahead
  label="Choose a fruit"
  placeholder="Search..."
  selectedKey={selected?.value ?? null}
  onChange={(key) => {
    const item = items.find(i => i.value === key);
    setSelected(item ?? null);
  }}
>
  {items.map(item => (
    <TypeaheadItem key={item.value} id={item.value}>
      {item.label}
    </TypeaheadItem>
  ))}
</Typeahead>
```

### Prop mapping

| LegacyTypeahead prop | Typeahead prop | Notes |
|----------------------|---------------|-------|
| `items` | — | Render `TypeaheadItem` children instead |
| `label` | `label` | Preserved (required) |
| `placeholder` | `placeholder` | Preserved |
| `selectedItem` | `selectedKey` | Pass the item's key/id instead of the item object |
| `onSelect` | `onChange` | Receives `Key` instead of item object |
| `onChange` (input text) | `onInputChange` | Renamed |
| `getLabelForItem` | — | Removed. Use `TypeaheadItem` children or `textValue` prop |
| `getKeyForItem` | — | Removed. Use `id` prop on `TypeaheadItem` |
| `inputId` | `id` | Preserved |
| `name` | `name` | Preserved |
| `isDisabled` | `isDisabled` | Preserved |
| `isFullWidth` | — | The new Typeahead fills its container by default |
| `isRequired` | `isRequired` | Preserved |
| `isErrored` | `isInvalid` | Renamed |
| `size` | `size` | Preserved (`'compact' \| 'small' \| 'medium' \| 'large'`) |
| `menuAriaLabel` | — | React Aria handles listbox labeling automatically |
| `renderFloatingMenu` | — | Removed. Popover rendering is handled internally |
| `renderButtonForItem` | — | Use `TypeaheadItem` children for custom rendering |
| `renderIcon` | — | Removed. Not applicable to the new API |
| `onBlur` | `onBlur` | Preserved (if supported via React Aria) |
| `onFocus` | `onFocus` | Preserved (if supported via React Aria) |

### Field integration

If `LegacyTypeahead` was wrapped in a `Field` component, the new `Typeahead` has built-in field support:

```tsx
// Before
<Field label="Fruit" helpText="Choose your favorite" errorMessage={error}>
  <LegacyTypeahead items={items} ... />
</Field>

// After
<Typeahead
  label="Fruit"
  helpText="Choose your favorite"
  errorMessage={error}
  isInvalid={!!error}
  ...
>
  {items.map(item => (
    <TypeaheadItem key={item.value} id={item.value}>{item.label}</TypeaheadItem>
  ))}
</Typeahead>
```

## Step 4: Handle sections/groups

If the legacy typeahead grouped items:

```tsx
// Before — custom rendering with groups
<LegacyTypeahead
  items={groupedItems}
  renderFloatingMenu={({ items, ...menuProps }) => (
    <FloatingMenu {...menuProps}>
      {groups.map(group => (
        <div key={group.name}>
          <h4>{group.name}</h4>
          {group.items.map(item => ...)}
        </div>
      ))}
    </FloatingMenu>
  )}
/>

// After — TypeaheadSection
import { Typeahead, TypeaheadItem, TypeaheadSection } from '@zapier/design-system';

<Typeahead label="Fruit" ...>
  {groups.map(group => (
    <TypeaheadSection key={group.name} label={group.name}>
      {group.items.map(item => (
        <TypeaheadItem key={item.value} id={item.value}>
          {item.label}
        </TypeaheadItem>
      ))}
    </TypeaheadSection>
  ))}
</Typeahead>
```

## Step 5: Handle custom item rendering

```tsx
// Before
<LegacyTypeahead
  items={users}
  getLabelForItem={(user) => user.name}
  renderButtonForItem={(user) => (
    <div>
      <Avatar name={user.name} />
      <span>{user.name}</span>
    </div>
  )}
/>

// After — complex children with textValue
<Typeahead label="Users" ...>
  {users.map(user => (
    <TypeaheadItem key={user.id} id={user.id} textValue={user.name}>
      <Avatar name={user.name} />
      <span>{user.name}</span>
    </TypeaheadItem>
  ))}
</Typeahead>
```

When `TypeaheadItem` has complex children (not just a string), provide `textValue` for filtering and accessibility.

## Step 6: Handle async/dynamic items

If the legacy typeahead loaded items dynamically based on input:

```tsx
// Before
const [inputValue, setInputValue] = useState('');
const [items, setItems] = useState([]);

<LegacyTypeahead
  items={items}
  onChange={(value) => {
    setInputValue(value);
    fetchItems(value).then(setItems);
  }}
  ...
/>

// After
<Typeahead
  label="Search"
  inputValue={inputValue}
  onInputChange={(value) => {
    setInputValue(value);
    fetchItems(value).then(setItems);
  }}
  ...
>
  {items.map(item => (
    <TypeaheadItem key={item.id} id={item.id}>{item.label}</TypeaheadItem>
  ))}
</Typeahead>
```

## Step 7: Ask the user about complex cases

If you encounter a `LegacyTypeahead` with heavy customization (custom `renderFloatingMenu`, complex Downshift state management, or custom keyboard handling), ask the user:

> **This LegacyTypeahead has significant customization that may not map directly to the new API.** Specifically:
> - [describe what's custom]
>
> Options:
> 1. Migrate to the new `Typeahead` and adapt the customization
> 2. Keep as `LegacyTypeahead` for now (it will be removed in v11)
> 3. Let me attempt the migration and you review the result
>
> Which approach do you prefer?

## Step 8: Verify

After migrating each file:

1. Run the type checker
2. Test that the typeahead opens and displays items correctly
3. Test filtering — type in the input and verify items filter
4. Test selection — click or keyboard-select an item and verify the callback fires
5. Test clearing — clear the input and verify the selection resets if applicable
6. If using sections, verify they render with correct headers
