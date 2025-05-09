# FormCoach Testing Guide

This guide provides comprehensive information about the testing setup, how to run tests, and how to write new tests for the FormCoach application.

## Table of Contents

1. [Testing Strategy Overview](#testing-strategy-overview)
2. [Test Directory Structure](#test-directory-structure)
3. [Running Tests](#running-tests)
4. [Writing Tests](#writing-tests)
5. [API Mocking](#api-mocking)
6. [End-to-End Testing](#end-to-end-testing)
7. [Test Coverage](#test-coverage)
8. [Continuous Integration](#continuous-integration)

## Testing Strategy Overview

FormCoach uses a comprehensive testing strategy that includes:

1. **Unit Tests**: Testing individual components in isolation
2. **Integration Tests**: Testing how components work together
3. **End-to-End Tests**: Testing complete user flows

Our testing stack includes:

- **Vitest**: Test runner for unit and integration tests
- **React Testing Library**: For testing React components
- **MSW (Mock Service Worker)**: For API mocking
- **Playwright**: For end-to-end testing

## Test Directory Structure

```
formcoach/
├── src/
│   ├── test/
│   │   ├── unit/           # Unit tests for components
│   │   ├── integration/    # Integration tests for flows
│   │   ├── mocks/          # MSW handlers and server setup
│   │   └── setup.ts        # Test setup file
├── e2e/                    # End-to-end tests
│   ├── helpers/            # Helper functions for E2E tests
│   └── *.spec.ts           # E2E test files
```

## Running Tests

### Unit and Integration Tests

To run all unit and integration tests:

```bash
npm test
```

To run tests in watch mode (useful during development):

```bash
npm run test:watch
```

To run tests with coverage reporting:

```bash
npm run test:coverage
```

### End-to-End Tests

To run end-to-end tests:

```bash
# Install Playwright browsers first (only needed once)
npx playwright install

# Run the tests
npm run test:e2e
```

## Writing Tests

> **Note:** The sample tests included in this repository are for demonstration purposes only and may need to be adapted to the actual components in your application. Some tests may fail if the components they're testing don't match the expected structure or behavior.
>
> The basic testing setup has been verified to work with a simple utility test. You can run `npm test` to see the results.

### Unit Tests

Unit tests should be placed in `src/test/unit/` and focus on testing individual components in isolation.

Example unit test for a component:

```tsx
// src/test/unit/LoadingIndicator.test.tsx
import { render, screen } from '@testing-library/react';
import LoadingIndicator from '@/components/LoadingIndicator';
import { describe, it, expect } from 'vitest';

describe('LoadingIndicator', () => {
  it('renders with default props', () => {
    render(<LoadingIndicator />);
    expect(screen.getByText(/loading/i)).toBeInTheDocument();
  });

  it('renders with custom text', () => {
    render(<LoadingIndicator text="Please wait" />);
    expect(screen.getByText('Please wait')).toBeInTheDocument();
  });
});
```

### Integration Tests

Integration tests should be placed in `src/test/integration/` and focus on testing how components work together.

Example integration test:

```tsx
// src/test/integration/WorkoutPlanFlow.test.tsx
import { render, screen, fireEvent } from '@testing-library/react';
import { MemoryRouter, Routes, Route } from 'react-router-dom';
import WorkoutPlansPage from '@/pages/WorkoutPlansPage';
import WorkoutPlanEditor from '@/pages/WorkoutPlanEditor';

describe('Workout Plan Flow', () => {
  it('navigates from plans list to editor', async () => {
    render(
      <MemoryRouter initialEntries={['/workout-plans']}>
        <Routes>
          <Route path="/workout-plans" element={<WorkoutPlansPage />} />
          <Route path="/workout-plan-editor" element={<WorkoutPlanEditor />} />
        </Routes>
      </MemoryRouter>
    );

    // Click create plan button
    fireEvent.click(screen.getByText('Create New Plan'));

    // Verify navigation to editor
    expect(await screen.findByText('Create Workout Plan')).toBeInTheDocument();
  });
});
```

## API Mocking

We use MSW (Mock Service Worker) to mock API calls in our tests. The mock handlers are defined in `src/test/mocks/handlers.ts`.

To add a new mock handler:

1. Open `src/test/mocks/handlers.ts`
2. Add a new handler for the API endpoint you want to mock

Example:

```typescript
// src/test/mocks/handlers.ts
import { rest } from 'msw';

export const handlers = [
  // Add your handler here
  rest.get('https://api.example.com/data', (req, res, ctx) => {
    return res(
      ctx.status(200),
      ctx.json({ data: 'mocked data' })
    );
  }),
];
```

## End-to-End Testing

End-to-end tests use Playwright and should be placed in the `e2e/` directory.

Example E2E test:

```typescript
// e2e/workout-flow.spec.ts
import { test, expect } from '@playwright/test';
import { login } from './helpers/login';

test.describe('Workout Flow', () => {
  test('user can create and complete a workout', async ({ page }) => {
    // Login
    await login(page);

    // Navigate to workout plans
    await page.goto('/workout-plans');

    // Create a new plan
    await page.click('text=Create New Plan');

    // ... rest of the test
  });
});
```

## Test Coverage

We aim for the following test coverage:

- **Unit Tests**: 80% coverage of component code
- **Integration Tests**: Cover all main user flows
- **E2E Tests**: Cover critical paths that affect user experience

To view the test coverage report:

```bash
npm run test:coverage
```

This will generate a coverage report in the `coverage/` directory.

## Continuous Integration

Tests are automatically run in our CI pipeline:

1. Unit and integration tests run on every pull request
2. E2E tests run on the staging branch before deployment to production

If you're setting up CI, you can use the following commands:

```bash
# Install dependencies
npm ci

# Run unit and integration tests
npm test

# Run E2E tests
npx playwright install --with-deps
npm run test:e2e
```

---

For more detailed information about our testing strategy, see [testing-strategy.md](./testing-strategy.md).
