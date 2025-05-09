import { rest } from 'msw';

// Define your Supabase URL - hardcoded for tests
const supabaseUrl = 'https://test-supabase-url.supabase.co';

export const handlers = [
  // Profiles
  rest.get(`${supabaseUrl}/rest/v1/profiles`, (req, res, ctx) => {
    return res(
      ctx.status(200),
      ctx.json([
        { 
          id: '1', 
          user_id: 'test-user-id',
          username: 'testuser',
          full_name: 'Test User',
          avatar_url: 'https://example.com/avatar.png',
          created_at: '2023-01-01T00:00:00.000Z'
        }
      ])
    );
  }),

  // Workout Plans
  rest.get(`${supabaseUrl}/rest/v1/workout_plans`, (req, res, ctx) => {
    return res(
      ctx.status(200),
      ctx.json([
        {
          id: '1',
          name: 'Test Plan',
          user_id: 'test-user-id',
          exercises: [
            { id: '1', name: 'Push-ups', sets: 3, reps: 10 }
          ],
          created_at: '2023-01-01T00:00:00.000Z'
        }
      ])
    );
  }),

  rest.post(`${supabaseUrl}/rest/v1/workout_plans`, (req, res, ctx) => {
    return res(
      ctx.status(201),
      ctx.json({ id: '2', ...req.body })
    );
  }),

  // Workouts
  rest.get(`${supabaseUrl}/rest/v1/workouts`, (req, res, ctx) => {
    return res(
      ctx.status(200),
      ctx.json([
        {
          id: '1',
          user_id: 'test-user-id',
          plan_id: '1',
          completed_at: '2023-01-02T00:00:00.000Z',
          exercises: [
            { id: '1', name: 'Push-ups', sets: 3, reps: 10, completed: true }
          ]
        }
      ])
    );
  }),

  // Symptoms
  rest.get(`${supabaseUrl}/rest/v1/symptoms`, (req, res, ctx) => {
    return res(
      ctx.status(200),
      ctx.json([
        { id: '1', name: 'Soreness', user_id: 'test-user-id', severity: 3, recorded_at: '2023-01-03T00:00:00.000Z' }
      ])
    );
  })
];
