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

  it('renders with fullscreen class when fullScreen is true', () => {
    const { container } = render(<LoadingIndicator fullScreen />);
    expect(container.firstChild).toHaveClass('fixed inset-0');
  });
});