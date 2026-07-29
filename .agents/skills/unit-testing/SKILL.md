---
name: unit-testing
description: "Write accurate, complete, independent unit tests for Dart and Flutter projects with strict adherence to TDD (Test-Driven Development) principles."
---

# 🚨 Important: Two-Phase Workflow — Stop Between Phases

**You MUST follow this exact two-phase workflow. Do NOT skip to Phase 2 without user approval.**

After Phase 1, you **STOP completely** and use the `ask_user` tool to present the plan to the user and wait for their explicit go-ahead (e.g., "OK proceed" or "Start writing"). Only then do you move to Phase 2.

---

# Phase 1: Test Planning

Analyze the provided scope and classify each file or class into **Test** or **Skip**. Complete this classification before generating any tests.

A file should be marked as **Test** only when it contains observable behavior such as business logic, validation, data transformation, state changes, error handling, dependency interaction, or decision making.

## Test Candidates

Repositories - Use Cases - Cubits / Blocs - Services with logic - Validators - Mappers - Models with behavior (fromJson, toJson, copyWith, equality, custom methods) - Extensions with logic - Helpers with logic - Pure Dart functions with business logic

## Skip

Constants - Configuration files - Static resources (colors, strings, assets, routes, endpoints) - Data holders without behavior - DTOs with fields only - Enums without logic - Generated files - Widgets - Screens - Themes - UI components - Third-party packages - Files that only store values or data

Skip any class that only contains fields, constructors, getters, setters, or static values without behavior.

If a file contains multiple classes, classify each class separately.

Use this rule:
- If changing the input can change the output or behavior → **Test**
- If it only stores or exposes values → **Skip**

## Output at the End of Phase 1

Create a markdown file at `test/test_plan.md` documenting the full app scope structure with each file classified as **Yes** (test) or **No** (skip) and the reason why, in this format:

```md
# 📋 Unit Test Plan

| # | File | Class / Functions | Test? | Reason |
|---|------|-------------------|-------|--------|
| 1 | `path/to/file1.dart` | `ClassName` | **Yes** | fromJson, toJson, business logic |
| 2 | `path/to/file2.dart` | `ClassName` | **Yes** | state management, fallback logic |
| 3 | `path/to/file3.dart` | `AppConstants` | **No** | Constants only — static values, no behavior |
| 4 | `path/to/file4.dart` | `AppTheme` | **No** | Theme/static resources |
```

The MD file must include:
- **Each file** in the entire scope as a separate row
- **Class / Functions** column listing the main classes or functions in the file
- **Test?** column marked **Yes** or **No**
- **Reason** column explaining the classification
- Organized by directory structure
- A **Summary** table at the end with counts of Yes/No

After creating `test/test_plan.md`, present the summary to the user using the `ask_user` tool.

## ⛔ STOP. Present the Plan to the User NOW

Use the `ask_user` tool to present your Test Planning summary with multiple-choice options:

```json
{
  "questions": [
    {
      "question": "Do you approve this test plan?",
      "header": "Test Plan",
      "options": [
        {"label": "Yes, proceed to Phase 2", "description": "I approve this plan, start writing tests"},
        {"label": "I have revisions", "description": "I have changes to suggest to the classification"}
      ]
    }
  ]
}
```

**Do NOT write any test code. Do NOT proceed to Phase 2 until the user explicitly tells you to.**

---

# Phase 2: Writing Tests (Only After User Approval)

Once the user says "proceed" or "OK, start writing":

1. Create the test directory structure under `test/` mirroring `lib/`
2. Write one test file per source file classified as **Test**
3. Each test file must cover:
   - Normal/expected behavior (happy path)
   - Edge cases (empty data, boundary values, nulls)
   - Error/failure scenarios
   - Equality and hashCode where applicable
4. Use `flutter_test` and manual mocks (avoid adding new dependencies unless the user agrees)
5. Run all tests and fix any failures
6. Report the results to the user