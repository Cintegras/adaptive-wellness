CREATE TABLE exercise_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES profiles(id),
  exercise_id UUID REFERENCES exercises(id),
  sets_completed INTEGER,
  reps_completed INTEGER,
  weights_used INTEGER,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);