# Clean Up Divider Spacing

In v10, the `Divider` component now renders with a fixed height of **16px** (`var(--zds-space-16)`). Previously, the height was implicit and determined by font line-height, which could vary. Because of this, many consumers added their own spacing (margins, padding, wrapper divs) around `Divider` to get consistent spacing. With the fixed height, that extra spacing may now cause double spacing.

The `Divider` also now accepts `className` and `style` props for customization.

---

## Step 1: Find all Divider usages

```sh
rg "Divider" -t ts -g '!node_modules' -l
```

Also search for CSS/SCSS that might target Divider wrappers:

```sh
rg "divider|Divider" -t css -g '!node_modules' -l
```

## Step 2: Inspect each Divider usage

For each file, look for spacing applied around `Divider`:

### Pattern 1: Wrapper div with margin/padding

```tsx
// Before — wrapper adds spacing that now doubles up
<div style={{ margin: '16px 0' }}>
  <Divider height={1} />
</div>

// After — remove the wrapper, Divider has 16px height built in
<Divider height={1} />
```

### Pattern 2: Adjacent margin/padding in CSS

```css
/* Before — custom spacing in CSS module */
.divider {
  margin: 16px 0;
}

/* or */
.section + .section {
  border-top: none; /* using Divider instead */
  padding-top: 16px;
}
```

Look for class names applied to elements wrapping or adjacent to `Divider` and check if they add vertical spacing.

### Pattern 3: Spacer components

```tsx
// Before
<Spacer height={16} />
<Divider height={1} />
<Spacer height={16} />

// After — Divider's built-in 16px height provides the spacing
<Divider height={1} />
```

### Pattern 4: Inline styles

```tsx
// Before
<Divider height={1} style={{ marginBlock: '16px' }} />

// After — if the built-in 16px is sufficient, remove the margin
<Divider height={1} />

// Or if different spacing is intentional:
<Divider height={1} style={{ marginBlock: '24px' }} />
```

## Step 3: Determine the right fix

For each instance of extra spacing around `Divider`, ask:

1. **Is the extra spacing meant to match the Divider's natural height?** (e.g. `margin: 16px 0` or `padding: 16px 0`) → Remove it — the built-in 16px handles this.

2. **Is the extra spacing larger than 16px?** (e.g. `margin: 24px 0`) → The consumer likely wants more spacing than the default. Use the new `style` or `className` prop:

```tsx
<Divider height={1} style={{ marginBlock: '24px' }} />
```

3. **Is the extra spacing from a parent layout** (e.g. flex gap, grid gap)? → This may still be correct. The Divider's 16px height participates in the gap calculation. Visual inspection is recommended.

## Step 4: Check CSS files

Search for CSS rules that specifically target Divider or its containers:

```sh
rg -i "divider" -t css -g '!node_modules'
```

Look for:
- `margin-top`, `margin-bottom`, `margin-block` on Divider containers
- `padding-top`, `padding-bottom`, `padding-block` on Divider containers
- `height` overrides on Divider wrappers
- `line-height` adjustments that were compensating for the old variable height

## Step 5: Ask the user for visual verification

Since spacing changes are visual and context-dependent, ask the user to verify:

> **I've identified [N] Divider instances with extra spacing that may be redundant after the v10 fixed-height change.** Here's what I found:
>
> | File | Line | Current spacing | Recommendation |
> |------|------|-----------------|----------------|
> | ... | ... | `margin: 16px 0` wrapper | Remove wrapper |
> | ... | ... | `padding-top: 24px` adjacent | Keep — intentional larger spacing |
>
> Would you like me to apply the recommended changes? You should visually verify each one after the change.

## Step 6: Apply changes

For each approved change:

1. Remove redundant wrapper divs
2. Remove redundant margin/padding from CSS
3. If custom spacing is needed, use the `style` or `className` prop on `Divider` directly

## Step 7: Verify

After making changes:

1. Run the type checker
2. Visually inspect each modified Divider to confirm spacing looks correct
3. Check responsive behavior — the 16px height is fixed across all viewport sizes
4. Look for any double spacing or missing spacing
