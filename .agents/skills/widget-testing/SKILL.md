---
name: widget-testing
description: "Write comprehensive widget tests for Flutter UI components using flutter_test, covering rendering, interaction, state changes, and integration with Bloc/Mocks."
---

# 🚨 Important: Two-Phase Workflow — Stop Between Phases

**You MUST follow this exact two-phase workflow. Do NOT skip to Phase 2 without user approval.**

After Phase 1, you **STOP completely** and use the `ask_user` tool to present the plan to the user and wait for their explicit go-ahead (e.g., "OK proceed" or "Start writing"). Only then do you move to Phase 2.

---

# Phase 1: Test Planning

Analyze the provided scope and classify each widget file into **Test** or **Skip**.

## Widget Test Candidates

- **Stateful interactive widgets** (forms, buttons, keypads, dialogs, lists with selection)
- **Stateless widgets with behavior** (navigation callbacks, conditional rendering logic)
- **Custom form fields** (validation, input formatting, controllers)
- **Widgets that consume Bloc/Cubit** (BlocBuilder, BlocListener, context.select)
- **Widgets with gesture detection** (onTap, onLongPress, onKeyPressed callbacks)
- **Reusable UI components** (cards, headers, buttons with multiple states)
- **Overlay / dialog widgets** (showDialog, showModalBottomSheet, custom overlays)
- **Animated widgets** (animation controllers, micro-interactions)

## Skip

- Pure layout widgets without logic
- Theme / style only widgets
- Empty container/sized box wrappers
- Third-party widgets (tested by their authors)
- Widgets that are purely pass-through (only delegate to child widgets)
- Generated code

## Output at the End of Phase 1

Create a markdown file at `test/widget_test_plan.md` documenting the widget test scope:

```md
# 📋 Widget Test Plan

| # | File | Widget(s) | Test? | Reason |
|---|------|-----------|-------|--------|
| 1 | `path/to/car_number_form.dart` | `CarNumberForm`, `_CarNumberFormState` | **Yes** | Keypad input, validation, clearAll with PIN |
| 2 | `path/to/car_number_text_field.dart` | `CarNumberTextField` | **Yes** | Custom validation logic, input formatting |
| 3 | `path/to/empty_state_widget.dart` | `EmptyStateWidget` | **No** | Pure layout, no logic |
```

Include a **Summary** table with counts of Yes/No.

## ⛔ STOP. Present the Plan to the User NOW

Use the `ask_user` tool to present your Test Planning summary with multiple-choice options:

```json
{
  "questions": [
    {
      "question": "Do you approve this widget test plan?",
      "header": "Widget Test Plan",
      "options": [
        {"label": "Yes, proceed to Phase 2", "description": "I approve this plan, start writing widget tests"},
        {"label": "I have revisions", "description": "I have changes to suggest to the classification"}
      ]
    }
  ]
}
```

**Do NOT write any test code until the user explicitly tells you to.**

---

# Phase 2: Writing Widget Tests (Only After User Approval)

Once the user says "proceed" or "OK, start writing":

1. Create the test directory structure under `test/widget_test/` mirroring `lib/` widget locations
2. Write one test file per widget classified as **Test**
3. For each widget test, cover:
   - **Rendering** — does the widget build without errors?
   - **Initial state** — correct text, styles, icons displayed
   - **User interaction** — tapping buttons, entering text, long-press
   - **State changes** — widget reacts to state changes (BlocBuilder)
   - **Callbacks** — `onTap`, `onChanged`, `onSubmitted` fire correctly
   - **Conditional rendering** — widget shows/hides elements based on props
   - **Dialog / navigation** — modals appear/disappear correctly
   - **Edge cases** — empty list, loading state, error state, max length
4. Use `flutter_test` (WidgetTester):
   - `tester.pumpWidget()` to render
   - `tester.tap()`, `tester.enterText()`, `tester.longPress()` for interaction
   - `tester.pump()` / `tester.pumpAndSettle()` for animations/async
   - `find.text()`, `find.byType()`, `find.byKey()` for element discovery
5. For Bloc-dependent widgets, provide a mocked Bloc using `BlocProvider.value` with a pre-built state
6. Run all widget tests and fix any failures
7. Report the results to the user
