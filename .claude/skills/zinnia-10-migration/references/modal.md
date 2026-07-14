# Migrate LegacyModal → ModalDialog

Migrates `LegacyModal`, `LegacyModalContent`, `LegacyModalContentHeader`, `LegacyModalContentBody`, `LegacyModalContentFooter`, and `LegacyModalMediaContent` to the `ModalDialog` compound component in `@zapier/design-system` v10. The new `ModalDialog` is built on React Aria and uses a different structural pattern.

---

## Step 1: Find all LegacyModal usages

```sh
rg "LegacyModal" -t ts -g '!node_modules' -l
```

Work through each file one at a time.

## Step 2: Understand the structural change

The legacy and new APIs have fundamentally different structures:

**Legacy pattern** — mount/unmount to open/close:

```tsx
import {
  LegacyModal,
  LegacyModalContent,
  LegacyModalContentHeader,
  LegacyModalContentBody,
  LegacyModalContentFooter,
} from '@zapier/design-system';

{isOpen && (
  <LegacyModal onClosed={() => setIsOpen(false)} aria-label="Settings">
    <LegacyModalContent maxWidth="600px">
      {({ closeButton }) => (
        <>
          <LegacyModalContentHeader>
            {closeButton}
            <h2>Settings</h2>
          </LegacyModalContentHeader>
          <LegacyModalContentBody>
            <p>Modal content here</p>
          </LegacyModalContentBody>
          <LegacyModalContentFooter>
            <Button onPress={() => setIsOpen(false)}>Done</Button>
          </LegacyModalContentFooter>
        </>
      )}
    </LegacyModalContent>
  </LegacyModal>
)}
```

**New pattern** — controlled via `isOpen` prop:

```tsx
import { ModalDialog } from '@zapier/design-system';

<ModalDialog.Root
  isOpen={isOpen}
  onOpenChange={setIsOpen}
  aria-label="Settings"
>
  {({ close }) => (
    <>
      <ModalDialog.Header>Settings</ModalDialog.Header>
      <ModalDialog.Body>
        <p>Modal content here</p>
      </ModalDialog.Body>
      <ModalDialog.Footer>
        <Button onPress={close}>Done</Button>
      </ModalDialog.Footer>
    </>
  )}
</ModalDialog.Root>
```

Key differences:
- `ModalDialog.Root` stays in the tree and uses `isOpen`/`onOpenChange` to control visibility (no conditional rendering needed)
- `ModalDialog.Root` renders the close button automatically (no manual `closeButton` placement)
- No `LegacyModalContent` wrapper — `Header`, `Body`, `Footer` are direct children of `Root`
- `close` function is available via render prop on `Root`'s children

## Step 3: Apply prop mapping

### LegacyModal → ModalDialog.Root

| LegacyModal prop | ModalDialog.Root prop | Notes |
|------------------|----------------------|-------|
| `aria-label` | `aria-label` | Preserved. Required if no `ModalDialog.Header` is used |
| `canClose` | `isDismissable` | Same behavior: when `false`, no close button renders and overlay click doesn't close |
| `canScrollBody` | — | Removed. Body scrolling is handled automatically inside `ModalDialog.Body` |
| `onClosed` | `onOpenChange` | Signature change: `() => void` → `(isOpen: boolean) => void` |
| `children` | `children` | Can be ReactNode or render prop `({ close }) => ReactNode` |

### LegacyModalContent → removed

| LegacyModalContent prop | Replacement | Notes |
|--------------------------|-------------|-------|
| `maxWidth` | `className` or `style` on `ModalDialog.Root` | Apply width overrides to Root |
| `closeButton` | Built-in | `ModalDialog.Root` renders the close button automatically |

### LegacyModalContentHeader → ModalDialog.Header

| LegacyModalContentHeader prop | ModalDialog.Header prop | Notes |
|-------------------------------|------------------------|-------|
| `children` | `children` | Remove any `{closeButton}` rendering — it's automatic now |
| — | `textAlign` | New prop: `'start' \| 'end' \| 'justify' \| 'center'` (default: `'start'`) |
| — | `className` | New prop for style overrides |

### LegacyModalContentBody → ModalDialog.Body

| LegacyModalContentBody prop | ModalDialog.Body prop | Notes |
|-----------------------------|----------------------|-------|
| `children` | `children` | Preserved |
| `size` | — | Removed. Sizing is automatic |
| `scrollable` | — | Removed. Scroll behavior is automatic with resize observer and scroll fade |
| — | `textAlign` | New prop: `'start' \| 'end' \| 'justify' \| 'center'` (default: `'start'`) |
| — | `className` | New prop for style overrides |

### LegacyModalContentFooter → ModalDialog.Footer

| LegacyModalContentFooter prop | ModalDialog.Footer prop | Notes |
|-------------------------------|------------------------|-------|
| `children` | `children` | Preserved. Buttons inside Footer get `size="medium"` via context |
| — | `backgroundColor` | New prop for footer background color |
| — | `justify` | New prop: `'end' \| 'start' \| 'space-between'` (default: `'end'`) |
| — | `className` | New prop for style overrides |

### LegacyModalMediaContent → custom layout

There is no direct `ModalDialog` equivalent for `LegacyModalMediaContent`. Media content should be placed inside `ModalDialog.Body` or as custom content directly inside `ModalDialog.Root`.

```tsx
// Before
<LegacyModal onClosed={onClose} aria-label="Image preview">
  <LegacyModalMediaContent>
    {({ closeButton }) => (
      <>
        {closeButton}
        <img src={imageUrl} alt="Preview" />
      </>
    )}
  </LegacyModalMediaContent>
</LegacyModal>

// After
<ModalDialog.Root isOpen={isOpen} onOpenChange={setIsOpen} aria-label="Image preview">
  <ModalDialog.Body>
    <img src={imageUrl} alt="Preview" />
  </ModalDialog.Body>
</ModalDialog.Root>
```

## Step 4: Handle state management changes

### Mount/unmount → controlled state

The most common pattern change is removing the conditional rendering:

```tsx
// Before — LegacyModal is mounted/unmounted to open/close
const [isOpen, setIsOpen] = useState(false);

{isOpen && (
  <LegacyModal onClosed={() => setIsOpen(false)}>
    ...
  </LegacyModal>
)}

// After — ModalDialog stays in the tree, controlled by isOpen
const [isOpen, setIsOpen] = useState(false);

<ModalDialog.Root isOpen={isOpen} onOpenChange={setIsOpen}>
  ...
</ModalDialog.Root>
```

### Uncontrolled (trigger-based) modals

If the modal is opened by a button click and doesn't need external state, use `ModalDialog.Trigger`:

```tsx
import { ModalDialog, Button } from '@zapier/design-system';

<ModalDialog.Trigger>
  <Button>Open Settings</Button>
  <ModalDialog.Root aria-label="Settings">
    {({ close }) => (
      <>
        <ModalDialog.Header>Settings</ModalDialog.Header>
        <ModalDialog.Body>
          <p>Content</p>
        </ModalDialog.Body>
        <ModalDialog.Footer>
          <Button variant="secondary" onPress={close}>Cancel</Button>
          <Button onPress={close}>Save</Button>
        </ModalDialog.Footer>
      </>
    )}
  </ModalDialog.Root>
</ModalDialog.Trigger>
```

### Using the close function

The render prop pattern provides `close` for programmatic closing:

```tsx
<ModalDialog.Root isOpen={isOpen} onOpenChange={setIsOpen}>
  {({ close }) => (
    <>
      <ModalDialog.Header>Confirm</ModalDialog.Header>
      <ModalDialog.Body>Are you sure?</ModalDialog.Body>
      <ModalDialog.Footer>
        <Button variant="secondary" onPress={close}>Cancel</Button>
        <Button onPress={() => { handleConfirm(); close(); }}>Confirm</Button>
      </ModalDialog.Footer>
    </>
  )}
</ModalDialog.Root>
```

## Step 5: Handle maxWidth customization

```tsx
// Before
<LegacyModalContent maxWidth="800px">
  ...
</LegacyModalContent>

// After — use className or style on ModalDialog.Root
<ModalDialog.Root
  isOpen={isOpen}
  onOpenChange={setIsOpen}
  style={{ maxWidth: '800px' }}
>
  ...
</ModalDialog.Root>
```

## Step 6: Handle aria labeling

If the modal has a visible heading in `ModalDialog.Header`, `aria-label` is optional. If using a custom heading or no heading, provide either:

- `aria-label` — describes the dialog
- `aria-labelledby` — references the ID of a visible heading element

```tsx
// With ModalDialog.Header (aria-label optional)
<ModalDialog.Root isOpen={isOpen} onOpenChange={setIsOpen}>
  <ModalDialog.Header>Settings</ModalDialog.Header>
  ...
</ModalDialog.Root>

// Without ModalDialog.Header (aria-label required)
<ModalDialog.Root isOpen={isOpen} onOpenChange={setIsOpen} aria-label="Settings">
  <ModalDialog.Body>...</ModalDialog.Body>
</ModalDialog.Root>
```

## Step 7: Verify

After migrating each file:

1. Run the type checker
2. Test that the modal opens and closes correctly
3. Verify the close button appears (unless `isDismissable={false}`)
4. Test keyboard interaction: Escape key should close the modal
5. Verify focus management: focus should move into the modal on open and return to the trigger on close
