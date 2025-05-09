import { render, screen, fireEvent } from '@testing-library/react';
import { MemoryRouter, Routes, Route } from 'react-router-dom';
import { describe, it, expect, vi } from 'vitest';

// Mock components for testing
const WorkoutPlansPage = () => (
  <div>
    <h1>Workout Plans</h1>
    <button onClick={() => window.location.href = '/workout-plan-editor'}>Create New Plan</button>
    <ul>
      <li>Plan 1</li>
      <li>Plan 2</li>
    </ul>
  </div>
);

const WorkoutPlanEditor = () => (
  <div>
    <h1>Create Workout Plan</h1>
    <form>
      <input placeholder="Enter plan name" />
      <button type="button">Add Exercise</button>
      <button type="submit">Save Plan</button>
    </form>
  </div>
);

// Mock the hooks
vi.mock('@/hooks/useWorkoutPlans', () => ({
  useWorkoutPlans: () => ({
    workoutPlans: [
      { id: '1', name: 'Plan 1', exercises: [] },
      { id: '2', name: 'Plan 2', exercises: [] }
    ],
    isLoading: false,
    error: null
  })
}));

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

    // Verify we're on the plans page
    expect(screen.getByText('Workout Plans')).toBeInTheDocument();
    
    // Click create plan button
    fireEvent.click(screen.getByText('Create New Plan'));
    
    // Verify navigation to editor
    expect(await screen.findByText('Create Workout Plan')).toBeInTheDocument();
  });
});