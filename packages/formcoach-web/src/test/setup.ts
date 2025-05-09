import '@testing-library/jest-dom';
import { beforeAll, afterAll, afterEach } from 'vitest';

// Try to import the server, but don't fail if it's not available
let server: { listen: () => void; resetHandlers: () => void; close: () => void } | undefined;
try {
  // eslint-disable-next-line @typescript-eslint/no-var-requires
  const { server: importedServer } = require('./mocks/server');
  server = importedServer;
} catch (error) {
  console.warn('MSW server not available, API mocking will be disabled');
}

// Establish API mocking before all tests (if server is available)
beforeAll(() => {
  if (server) {
    server.listen();
  }
});

// Reset any request handlers that we may add during the tests,
// so they don't affect other tests (if server is available)
afterEach(() => {
  if (server) {
    server.resetHandlers();
  }
});

// Clean up after the tests are finished (if server is available)
afterAll(() => {
  if (server) {
    server.close();
  }
});
