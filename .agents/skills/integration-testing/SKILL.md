---
name: integration-testing
description: "Write end-to-end integration tests for Flutter apps using integration_test package, covering full user flows, navigation, data persistence, and real API interactions."
---

# 🚨 Important: Two-Phase Workflow — Stop Between Phases

**You MUST follow this exact two-phase workflow. Do NOT skip to Phase 2 without user approval.**

After Phase 1, you **STOP completely** and use the `ask_user` tool to present the plan to the user and wait for their explicit go-ahead (e.g., "OK proceed" or "Start writing"). Only then do you move to Phase 2.

---

# Phase 1: Test Planning

Analyze the app's user flows and classify each flow or feature area into **Test** or **Skip**.

## Integration Test Candidates

- **Full create → read → delete flows** (add car number → verify it appears → delete it)
- **Navigation flows** (tab switching, page transitions, back navigation)
- **Form submission flows** (input validation, submit, success/error feedback)
- **Dialog flows** (PIN verification, confirmation dialogs, cancellation)
- **Data persistence flows** (add number, restart app, verify it still exists)
- **Empty state → populated state transitions**
- **Error recovery flows** (network failure → retry → success)
- **Multi-step flows** (select items → delete → verify)

## Skip

- Individual widget rendering (covered by widget tests)
- Pure unit logic (covered by unit tests)
- Third-party SDK behavior
- Animations timing (unless critical to flow)
- Extreme edge cases that require specific device conditions

## Output at the End of Phase 1

Create a markdown file at `test/integration_test_plan.md` documenting the integration test scope:

```md
# 📋 Integration Test Plan

| # | Feature / Flow | Scenario | Test? | Reason |
|---|---------------|----------|-------|--------|
| 1 | Adding a car number | Type number → submit → verify it appears in list | **Yes** | Core user flow |
| 2 | Deleting a car number via PIN | Long press → PIN verification → delete → verify gone | **Yes** | Security-critical flow |
| 3 | Empty state display | Fresh app → verify empty state shown | **Yes** | First-run experience |
```

Include a **Summary** table with counts of Yes/No.

## ⛔ STOP. Present the Plan to the User NOW

Use the `ask_user` tool to present your Integration Test Planning summary:

```json
{
  "questions": [
    {
      "question": "Do you approve this integration test plan?",
      "header": "Integration Test Plan",
      "options": [
        {"label": "Yes, proceed to Phase 2", "description": "I approve this plan, start writing integration tests"},
        {"label": "I have revisions", "description": "I have changes to suggest to the classification"}
      ]
    }
  ]
}
```

**Do NOT write any test code until the user explicitly tells you to.**

---

# Phase 2: Writing Integration Tests (Only After User Approval)

Once the user says "proceed" or "OK, start writing":

1. Create integration test files under `test/integration_test/`
2. Each integration test file must:
   - Import `package:integration_test/integration_test.dart`
   - Call `IntegrationTestWidgetsFlutterBinding.ensureInitialized()` in `setUpAll`
   - Use `flutter_test` + `integration_test` packages
3. For each flow, cover:
   - **Full user journey** — start → interact → verify final state
   - **Real navigation** — test actual route transitions
   - **Real data persistence** — use real SharedPreferences (or mock at app level)
   - **Dialog interactions** — tap buttons inside dialogs, verify dismiss
   - **Error handling** — simulate network errors where possible
4. Use `tester.pumpWidget(MyApp())` to start the full app
5. Use `find.byType`, `find.text`, `find.byKey` to locate elements
6. Use `tester.tap()`, `tester.enterText()`, `tester.scrollUntilVisible()` for interaction
7. Use `await tester.pumpAndSettle()` after async operations (animations, navigation)
8. Run integration tests on a device/emulator: `flutter test integration_test/`
9. Ensure tests are:
   - **Isolated** — each test starts from a clean app state
   - **Deterministic** — no flaky timeouts or race conditions
   - **Self-verifying** — each test asserts the final expected state
10. Fix any failures and report the results to the user

## Important Notes

- Integration tests run on a real device or emulator — they take longer than unit/widget tests
- Use `setUp` / `tearDown` to reset app state between tests
- For tests involving PIN codes, use `AppConstants.pinCode` directly
- For cloud-dependent features (Google Sheets), mock the datasource layer
