import { describe, it, expect } from 'vitest';

// Simple utility function to test
function sum(a: number, b: number): number {
  return a + b;
}

describe('Utils', () => {
  it('sum adds two numbers correctly', () => {
    expect(sum(1, 2)).toBe(3);
    expect(sum(5, 7)).toBe(12);
    expect(sum(-1, 1)).toBe(0);
  });
});