---
name: zinnia-audit
description: Use when asked to review, audit, improve, or check existing code for Zinnia design system compliance. Also activates during code review contexts when evaluating design system usage.
status: recommended
---

# Audit Zinnia Compliance

You are auditing existing code for correct Zinnia design system usage. This skill provides a structured methodology for producing accurate, actionable audit reports with minimal false positives.

## Before You Start: Tool Checks

### Zinnia MCP

Call `list_components` to verify zinnia-mcp is available. If it responds, use MCP tools as your sole source of truth for component APIs, tokens, and conventions. Every finding must be traceable to a specific MCP tool call.

If zinnia-mcp is not available, note: "Zinnia MCP was not available — audit findings could not be validated against the component catalog. Install the Zinnia plugin for accurate audits." You can still check conventions encoded in this skill, but flag all component/token findings as "unverifiable."

### ZDev Docs

Check if `zdev docs search` is available. When unsure whether a pattern is correct or just unfamiliar, query ZDev before flagging it as an issue. Try: `zdev docs search "zinnia design tokens"`, `zdev docs search "zinnia scss"`, or `zdev docs search "developing with zinnia"`.

## Audit Methodology

Follow these seven steps in order. Do not skip steps.

### Step 1: Read the Source File

Read the file(s) to audit. Note:

- All imports — component names, source packages, and usage
- All `var(--zds-*)` token references
- All hardcoded colors, spacing, typography, shadows, and borders
- Whether `'use client'` is present
- Styling approach — CSS modules, inline styles, styled-components
- Any raw HTML elements and their purpose

### Step 2: Inventory What the File Uses

Create a structured inventory:

1. **Imported components** — name, source package, how each is used
2. **Design tokens** — every `var(--zds-*)` reference, plus every hardcoded value
3. **Raw HTML elements** — every `<div>`, `<button>`, `<a>`, `<h1>`, `<input>`, `<span>`, etc. and their purpose
4. **Typography elements** — every raw text element (`<span>`, `<p>`, `<div>` used for text, `<h1>`–`<h6>`) that should be a Text or Heading component
5. **Event handlers** — naming conventions used (`onClick` vs `onPress`)
6. **Icons** — how imported and rendered

### Step 3: Cross-Reference Against Zinnia MCP

Validate each inventory item against the MCP:

**Component validation:**

- Call `list_components` for the full catalog.
- Call `get_component_docs` for each imported component — verify the package, check deprecation status, and confirm prop names/types.

**Token validation:**

- Call `list_tokens` then `get_token_docs` for relevant categories (semantic first, then primitive).
- Verify every `var(--zds-*)` reference exists in the catalog. Token naming patterns can be misleading — scales have gaps and not every plausible name is valid. A token must appear in `list_tokens` output to be considered correct.
- Check all hardcoded values for token equivalents.

**Component coverage:**

- For each raw HTML element, call `search` with the element's purpose to check if a DS component should replace it.
- For every raw text element (`<span>`, `<p>`, `<div>` displaying text, `<h1>`–`<h6>`), verify it should be using the Text or Heading component via `get_component_docs("Text")` and `get_component_docs("Heading")`. All visible text must use these components.

**Event handlers:**

- Compare handler names against what `get_component_docs` returns for each component.

**Icons:**

- Verify icons are imported from `@zapier/zinnia-icons` and rendered with `Icon` or `IconButton`.

**Accessibility:**

- Check labels on interactive elements, heading hierarchy, keyboard accessibility, touch targets (24x24px minimum), and color-only indicators.

### Step 4: Classify Findings

Every finding gets one severity:

| Severity    | Criteria                                                                                                                                                                        |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **error**   | Definitively wrong — MCP confirms the issue. Wrong package, deprecated component with known replacement, hardcoded value with an exact token equivalent, missing required prop. |
| **warning** | Likely wrong or suboptimal — raw HTML where a DS component exists, primitive token where semantic exists, unusual prop usage.                                                   |
| **info**    | Observation — non-standard pattern that may be intentional, edge case, or unverifiable claim.                                                                                   |

### Step 5: Apply False Positive Prevention Rules

Before finalizing findings, check each one against these rules. These address the most common audit errors observed across 40+ evaluation runs:

**"Not documented" does not mean "not valid."** When a prop or value isn't found in MCP docs, classify as info (unverifiable), not error or warning. This is the #1 source of false positives.

**Distinguish component props from CSS values.** Values passed as React props (e.g., `<Icon color="GrayWarm4">`) are typed component API values, not hardcoded CSS colors. Only flag CSS/style values as hardcoded — not prop enum values.

**Don't fix props on deprecated components.** If the component is deprecated, flag the deprecation. Don't also flag individual prop issues on the same component — the fix is to migrate, not patch.

**Don't apply new-system conventions to deprecated-system components.** Legacy components follow legacy patterns.

**Verify replacements before suggesting them.** Every suggested DS component replacement must be verified via MCP `list_components` and `get_component_docs`. Never invent components — if `Box`, `Stack`, `Flex`, or `Inline` can't be found in `list_components`, don't recommend them.

**Check layout model compatibility.** When suggesting a DS component to replace raw CSS layout, verify the component's layout model matches the need (grid equal-width vs flex auto-width).

**Match exact token values.** Only classify a hardcoded value as error when an EXACT token match exists. Convert to px and compare — if they differ by even 1px, classify as warning.

**Apply detection uniformly.** If you flag one type of hardcoded value (e.g., `margin: 30px`), also flag all similar instances (e.g., `height={20}`) at the same severity.

**Typography is never optional.** All visible text must use Text or Heading. A raw `<p>` or `<span>` containing user-visible text is always a warning, not an info.

**Token scales have gaps.** Do not assume a token exists because its name follows a plausible pattern. Always verify via `list_tokens`. If a token cannot be found in MCP results, classify it as an error (fabricated token), not info.

### Step 6: Generate the Report

Write the report as `<filename>-audit.md` in the same directory as the audited file. Use this structure:

```markdown
# Zinnia Design System Audit Report

## Metadata

- **Date**: [ISO timestamp]
- **File audited**: `[path]`
- **Tools used**: [list MCP tools called and ZDev queries run]

## Summary

| Category            | Errors | Warnings | Info  |
| ------------------- | ------ | -------- | ----- |
| Component Selection | 0      | 0        | 0     |
| Package Correctness | 0      | 0        | 0     |
| Design Token Usage  | 0      | 0        | 0     |
| Props Correctness   | 0      | 0        | 0     |
| Event Handlers      | 0      | 0        | 0     |
| Icon Usage          | 0      | 0        | 0     |
| Layout Patterns     | 0      | 0        | 0     |
| Accessibility       | 0      | 0        | 0     |
| **Total**           | **0**  | **0**    | **0** |

## Component Inventory

| Component | Imported From | Expected Package | Status  |
| --------- | ------------- | ---------------- | ------- |
| [name]    | [actual]      | [per MCP]        | ✅ / ❌ |

## Design Token Issues

| Location | Current Value    | Suggested Token | Severity      |
| -------- | ---------------- | --------------- | ------------- |
| line X   | `#hex` or `16px` | `var(--zds-*)`  | error/warning |

## Raw HTML Elements

| Element    | Purpose   | DS Replacement | Severity |
| ---------- | --------- | -------------- | -------- |
| `<button>` | [purpose] | Button         | warning  |

## Detailed Findings

### [Category Name]

For each finding:

- **Severity**: error / warning / info
- **Location**: file and line
- **Issue**: what's wrong
- **MCP source**: the tool call that confirmed the finding
- **Recommendation**: specific fix

## Accessibility Issues

| Element          | Issue         | WCAG        | Severity      |
| ---------------- | ------------- | ----------- | ------------- |
| [element] line X | [description] | [criterion] | error/warning |

## Recommendations

[Actionable changes ordered by severity — errors first, then warnings]
```

### Step 7: Verify Report Consistency

Before finalizing, run these checks:

1. **Summary arithmetic** — Count findings in each Detailed Findings subsection. Verify the Summary table totals match exactly.
2. **Cross-section consistency** — If a finding appears in multiple categories, count it once per category at the same severity.
3. **Hardcoded value completeness** — Verify all hardcoded values are flagged consistently, not just the first one found.
4. **Source attribution** — Every finding must cite a specific MCP tool call. If any finding lacks attribution, either make the MCP call or demote to info with a note.
5. **Zero-error sanity check** — If the report shows zero errors, double-check. Real-world code almost always has at least one error-level DS issue.

## Token Accuracy

Never assume a token exists. Before referencing or recommending any `var(--zds-*)` token, verify it through MCP — call `get_token_docs` or `list_tokens` to confirm the token is real. Common hallucination patterns include inventing spacing values that fall outside the defined scale, fabricating semantic tokens by combining valid prefixes with invalid suffixes, and assuming a token exists because the naming pattern "looks right." If MCP is unavailable, flag the token as unverified rather than guessing.
