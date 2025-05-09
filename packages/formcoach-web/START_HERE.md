# FormCoach - Getting Started Guide

This guide will help you set up and run the FormCoach application on your local machine.

## Prerequisites

Before you begin, make sure you have the following installed:

- [Node.js](https://nodejs.org/) (v16 or later)
- [npm](https://www.npmjs.com/) (comes with Node.js)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (optional, for local Supabase development)
- [Supabase CLI](https://supabase.com/docs/guides/cli) (optional, for local development)
- [Expo CLI](https://docs.expo.dev/get-started/installation/) (for mobile development)

## Environment Setup

### Supabase Cloud Setup (Recommended)

FormCoach uses Supabase Cloud for authentication and database functionality. To set up:

1. Ensure you have the correct environment variables in your `.env` file:
   ```
   VITE_FORMCOACH_ENV=dev
   VITE_SUPABASE_URL=https://your-project-url.supabase.co
   VITE_SUPABASE_ANON_KEY=your-anon-key
   ```

2. Create the required `exec_sql` stored procedure in Supabase Cloud:
   - Go to the [Supabase Dashboard](https://app.supabase.io)
   - Select your project
   - Go to SQL Editor
   - Run the following SQL:
   ```sql
   CREATE OR REPLACE PROCEDURE exec_sql(sql_text TEXT)
   LANGUAGE plpgsql
   AS $$
   BEGIN
     EXECUTE sql_text;
   END;
   $$;

   -- Grant execute permission to authenticated users
   GRANT EXECUTE ON PROCEDURE exec_sql(TEXT) TO authenticated;
   GRANT EXECUTE ON PROCEDURE exec_sql(TEXT) TO anon;
   GRANT EXECUTE ON PROCEDURE exec_sql(TEXT) TO service_role;
   ```

### Local Supabase Setup (Optional)

If you prefer to use a local Supabase instance for development:

1. Install Docker Desktop from [docker.com](https://www.docker.com/products/docker-desktop/)
2. Install Supabase CLI:
   ```bash
   npm install -g supabase
   ```
3. Initialize Supabase in your project:
   ```bash
   npx supabase init
   ```
4. Start a local Supabase instance:
   ```bash
   npx supabase start
   ```
5. Update your `.env` file with the local credentials (shown after running `supabase start`)

## Starting the Application

### Option 1: Using the Start Script (Recommended)

We've created a start script that handles everything for you:

1. Open a terminal in the project root directory
2. Run the start script:
   ```bash
   ./scripts/start-project.sh
   ```
3. Follow the prompts to choose whether to use Supabase Cloud or a local Supabase instance
4. The script will:
    - Verify Supabase connection
    - Install dependencies (if needed)
    - Start the Vite development server with increased memory limits

### Option 2: Manual Setup

If you prefer to set things up manually:

1. Install dependencies:
   ```bash
   npm install
   ```

2. (Optional) Start a local Supabase instance:
   ```bash
   supabase start
   node scripts/execute-sql.js
   ```

3. Start the development server with increased memory limits:
   ```bash
   NODE_OPTIONS=--max_old_space_size=4096 npm run dev
   ```

### Option 3: Running Backend and Frontend Separately

For full-stack development with the FastAPI backend:

1. Run the combined script:
   ```bash
   ./scripts/run.sh
   ```

   This will start both the FastAPI backend in the `packages/backend` directory and the React frontend.

## Accessing the Application

Once the development server is running, you can access the application at:

- **Web App**: [http://localhost:5173](http://localhost:5173)
- **API (if using FastAPI backend)**: [http://localhost:8000](http://localhost:8000)

## Development Workflow

- The application uses Vite for fast development and hot module replacement
- Changes to your code will be reflected immediately in the browser
- The project is connected to Supabase for backend functionality
- React hooks in the `src/hooks` directory provide easy access to Supabase data
- For seeding test data, run:
  ```bash
  node scripts/seed-dev.mjs
  ```

## React Native Development (Expo)

FormCoach has been rebuilt as a mobile-first React Native app using Expo. To work with the mobile app:

1. Navigate to the mobile app directory:
   ```bash
   cd formcoach-mobile
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Set up environment variables:
   Create a `.env` file in the formcoach-mobile directory with:
   ```
   EXPO_PUBLIC_SUPABASE_URL=your_supabase_url
   EXPO_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

4. Start the Expo development server:
   ```bash
   npx expo start
   ```

5. For iOS development (primary target):
   ```bash
   npx expo start --ios
   ```

6. For Android development (secondary target):
   ```bash
   npx expo start --android
   ```

7. For web testing (development only):
   ```bash
   npx expo start --web
   ```

The mobile app includes the following key screens:
- LoginScreen (with Apple Sign-In)
- SignUpScreen
- HomeScreen
- PlansScreen
- HistoryScreen
- ProfileScreen
- ExerciseLogScreen (for logging sets, reps, weights)

## Azure AD B2C Setup for Supabase OAuth

To set up Azure AD B2C with Supabase OAuth:

1. Create an Azure AD B2C tenant in the Azure Portal
2. Register your application in Azure AD B2C
3. Configure the redirect URI to your Supabase auth callback URL:
   ```
   https://your-project-url.supabase.co/auth/v1/callback
   ```
4. In Supabase Dashboard, go to Authentication → Providers → Azure
5. Enter your Azure AD B2C client ID and secret
6. Enable "Sign in with Azure" in your application

## Stopping the Application

To stop the application:

1. Press `Ctrl+C` in the terminal where the development server is running
2. If you started a local Supabase instance, stop it with:
   ```bash
   supabase stop
   ```

## Tasks 1 and 2 SQL Execution

FormCoach requires specific database setup for exercise logging functionality:

1. **Task 1: Schema Setup**
   - Creates the `exercise_logs` table for storing workout data
   - Run with:
   ```bash
   node scripts/execute-sql-remote.js docs/sql/task1.sql
   ```
   - Or execute manually in Supabase Dashboard SQL Editor:
   ```sql
   CREATE TABLE exercise_logs (
     id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
     user_id UUID REFERENCES profiles(id),
     exercise_id UUID REFERENCES exercises(id),
     sets_completed INTEGER,
     reps_completed INTEGER,
     weights_used INTEGER,
     created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
   );
   ```

2. **Task 2: Solo Workout Logging**
   - Seeds sample exercise log data
   - Run with:
   ```bash
   node scripts/execute-sql-remote.js docs/sql/task2.sql
   ```
   - Or execute manually in Supabase Dashboard SQL Editor:
   ```sql
   INSERT INTO exercise_logs (user_id, exercise_id, sets_completed, reps_completed, weights_used)
   VALUES ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000002', 3, 10, 50);
   ```

## Troubleshooting

If you encounter any issues:

1. **Memory Errors**: Increase Node.js memory limit:
   ```bash
   NODE_OPTIONS=--max_old_space_size=4096 npm run dev
   ```

2. **Supabase Connection Issues**:
   - Verify your `.env` file has the correct Supabase URL and anon key
   - Check if the `exec_sql` procedure exists in your Supabase instance
   - Try running `node scripts/execute-sql-remote.js` to verify SQL execution

3. **Script Execution Errors**:
   - Make sure scripts are executable: `chmod +x scripts/*.sh`
   - Check for Node.js version compatibility (v16+)

4. **Docker Issues**:
   - Ensure Docker Desktop is running before starting local Supabase
   - Check Docker resource allocation (memory, CPU) in Docker Desktop settings

5. **Expo Issues**:
   - For iOS simulator issues, try `xcrun simctl list devices` to verify available simulators
   - For Android emulator issues, ensure Android Studio and emulator are properly configured
   - For web testing issues, check browser console for errors

## Next Steps

Now that you have the application running, you can:

1. Explore the codebase to understand how it works
2. Make changes to the code and see them reflected in real-time
3. Use the React hooks in `src/hooks` to interact with the Supabase database
4. Build new features or fix bugs as needed
5. Test the mobile version with Expo

Happy coding!
