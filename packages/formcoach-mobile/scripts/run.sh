#!/bin/bash

echo "🔁 Starting FormCoach..."

# --- BACKEND ---
echo "▶ Starting FastAPI backend..."
cd packages/backend

# Use virtualenv if it exists
if [ -d "venv" ]; then
  source venv/bin/activate
else
  echo "⚠️ No virtual environment found. You may need to run: python3 -m venv venv && source venv/bin/activate"
fi

# Check if app/main.py exists
if [ -f "app/main.py" ]; then
  uvicorn app.main:app --reload &
elif [ -f "main.py" ]; then
  uvicorn main:app --reload &
else
  echo "❌ Cannot find main.py. Please check the backend directory structure."
  exit 1
fi

BACK_PID=$!
cd ../../

# --- CHOOSE FRONTEND ---
echo "🔄 Choose frontend to start:"
echo "  1) React Native Mobile (Expo)"
echo "  2) Web Frontend (Vite)"
read -r frontend_choice

if [ "$frontend_choice" = "1" ]; then
  # --- MOBILE FRONTEND ---
  echo "▶ Starting React Native Expo app..."

  # Check if formcoach-mobile directory exists
  if [ ! -d "formcoach-mobile" ]; then
    echo "❌ formcoach-mobile directory not found. Please check the project structure."
    kill $BACK_PID
    exit 1
  fi

  cd formcoach-mobile

  # Install dependencies if needed
  if [ ! -d "node_modules" ]; then
    echo "📦 Installing mobile dependencies..."
    npm install
  fi

  # Start Expo
  echo "▶ Starting Expo development server..."
  npx expo start &
  FRONT_PID=$!

else
  # --- WEB FRONTEND ---
  echo "▶ Starting React web frontend..."

  # For monorepo structure, we can start the frontend from the root
  if [ ! -d "node_modules" ]; then
    echo "📦 Installing web frontend dependencies..."
    npm install
  fi

  # Start the frontend with increased memory limit
  NODE_OPTIONS=--max_old_space_size=4096 npm run dev &
  FRONT_PID=$!
fi

# Wait for both processes
echo "✅ Backend and frontend are running. Press Ctrl+C to stop."
wait $BACK_PID $FRONT_PID
