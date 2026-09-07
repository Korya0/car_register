# 📋 Integration Test Plan

| # | Feature / Flow | Scenario | Test? | Status | Reason / Test File |
|---|---------------|----------|-------|--------|-------------------|
| 1 | Adding a car number | Type number → submit → verify it appears in list | **Yes** | ✅ Passed | `add_car_number_test.dart` |
| 2 | Deleting a single car number | Tap delete icon → confirm in dialog → verify removed from list | **Yes** | ✅ Passed | `delete_single_test.dart` |
| 3 | Deleting multiple car numbers | Select items → select all/deselect all → confirm batch delete with PIN → verify gone | **Yes** | ✅ Passed | `delete_multiple_and_clear_test.dart` |
| 4 | Clearing all car numbers | Long-press submit button → confirm clear all → enter PIN → verify list is empty | **Yes** | ✅ Passed | `delete_multiple_and_clear_test.dart` |
| 5 | Navigation between Add and List tabs | Tap bottom nav bar → verify form shows on Add tab → tap List tab → verify list shows | **Yes** | ✅ Passed | `navigation_and_empty_state_test.dart` |
| 6 | Empty state display | Fresh app with no data → verify empty state widget shown with message | **Yes** | ✅ Passed | `navigation_and_empty_state_test.dart` |
| 7 | Empty state → populated state | Start empty → add a number → verify empty state replaced by list with item | **Yes** | ✅ Passed | `navigation_and_empty_state_test.dart` |
| 8 | PIN verification dialog (correct PIN) | Trigger delete → enter correct PIN → verify dialog dismisses and action proceeds | **Yes** | ✅ Passed | `delete_multiple_and_clear_test.dart` |
| 9 | PIN verification dialog (wrong PIN) | Trigger delete → enter wrong PIN → verify attempts counter updates → max attempts dismisses | **Yes** | ✅ Passed | `pin_verification_test.dart` |
| 10 | PIN verification dialog (cancel) | Trigger delete → tap cancel → verify dialog dismisses without action | **Yes** | ✅ Passed | `pin_verification_test.dart` |
| 11 | Form validation (empty submit) | Tap submit with empty field → verify validation error | **Yes** | ✅ Passed | `add_car_number_test.dart` |
| 12 | Duplicate car number prevention | Add a number → add same number again → verify error toast | **Yes** | ✅ Passed | `add_car_number_test.dart` |
| 13 | Toast success message on add | Add a number → verify success toast appears then dismisses | **Yes** | ✅ Passed | `add_car_number_test.dart` |
| 14 | Toast success message on delete | Delete a number → verify success toast appears | **Yes** | ✅ Passed | `delete_multiple_and_clear_test.dart` |
| 15 | Error state with retry | Initialize with no connectivity → verify error state → tap retry → verify recovery | **Yes** | ✅ Passed | `error_and_loading_state_test.dart` |
| 16 | Data persistence | Add a number → restart app → verify number still exists | **Yes** | ✅ Passed | `persistence_test.dart` |
| 17 | Loading / skeleton state | Launch app → verify skeleton screen shown during initialization | **Yes** | ✅ Passed | `error_and_loading_state_test.dart` |

## Skipped

| # | Feature / Flow | Reason |
|---|---------------|--------|
| S1 | Individual widget rendering | Covered by widget tests |
| S2 | Pure unit logic (cubit state transitions, repository logic) | Covered by unit tests |
| S3 | Third-party SDK behavior (gsheets, shared_preferences internals) | Out of scope for integration tests |
| S4 | Animation timing | Not critical to flow |
| S5 | Keypad digit press animations | Covered by widget tests |

## Summary

| Category | Count | Status |
|----------|-------|--------|
| **Test** | 17 | ✅ 17/17 Passed |
| **Skip** | 5 | Skipped as planned |
| **Total** | 22 | 100% Complete |