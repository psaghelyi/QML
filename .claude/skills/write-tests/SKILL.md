---
description: Apply test standards when writing or updating test files
allowed-tools: Read, Edit, Write, Grep, Glob
---

Apply these standards when creating or modifying test files.

## Testing Philosophy

- **Only test meaningful algorithms and business logic.** Do not test boilerplate, trivial getters/setters, or framework plumbing.
- **Prefer integration tests with real components** over unit tests with mocked dependencies. Mocks hide real behavior.
- **Fewer, meaningful tests over coverage.** A handful of tests that exercise real logic are worth more than many shallow tests.
- **Remove outdated or irrelevant tests.** Do not try to fix broken tests that no longer reflect current code. Delete them and move forward.
- **No deprecated code.** When functionality changes, tests update immediately. No backward-compatibility shims in tests.

## Test File Header (Required)

Every test file must include a comprehensive docstring **at the top, before any imports**:

```python
"""
<One-line summary of test file purpose.>

<"Tests..." paragraph explaining what is tested:>
- <Bulleted list of 5-8 main test scenarios>

<"These [unit/integration] tests..." paragraph explaining the testing approach and why it matters.>
"""
```

### Required Elements

1. One-line summary of test file purpose
2. Blank line
3. "Tests..." paragraph with what is tested
4. Bulleted list (5-8 items) covering main test scenarios
5. Blank line
6. "These [unit/integration] tests..." paragraph explaining approach and importance

### Example

```python
"""
Integration tests for campaign statistics progression tracking.

Tests that campaign statistics correctly update as campaigns progress:
- Assigned users count (interviewers + target users)
- Progression tracking in both Direct and Interviewer-Assisted modes
- Pending, in-progress, and completed counts
- Response rate calculations
- Statistics accuracy across campaign lifecycle
- Edge cases (no assignments, all completed, partial completion)

These integration tests use real repository interactions to verify that
statistics accurately reflect campaign state changes, which is critical
for project managers monitoring field work progress and response rates.
"""
```

## Test Organization

| Type | Marker | Dependencies | Purpose |
|------|--------|--------------|---------|
| Integration | `@pytest.mark.integration` | Real components / fakes | Test real component interactions (preferred) |
| Unit | `@pytest.mark.unit` | Mocked only when necessary | Isolate complex algorithms that are hard to test via integration |

- Place tests in `tests/integration/` (preferred) or `tests/unit/`
- Register test markers in `pytest.ini`
- Test files: `test_*.py`, classes: `Test*`, methods: `test_*`
- Add component markers (e.g., `@pytest.mark.dto`, `@pytest.mark.repository`)
- Use descriptive names explaining what is being tested
- Group related tests in test classes
