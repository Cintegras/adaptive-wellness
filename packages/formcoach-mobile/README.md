# FormCoach Mobile

A mobile-first React Native app for FormCoach, built with Expo, NativeWind, and Supabase.

## Overview

FormCoach Mobile is a fitness app for musculoskeletal workouts, allowing users to:
- Create and manage workout plans
- Log exercises (sets, reps, weights)
- Track workout history
- View and update user profiles

## Tech Stack

- **React Native**: Core framework
- **Expo**: Managed workflow for easier development and deployment
- **NativeWind**: Tailwind CSS for React Native
- **Supabase**: Authentication and database
- **React Navigation**: Navigation between screens
- **Jest/Testing Library**: Unit and integration testing
- **Expo Secure Store**: Secure storage for auth tokens

## Getting Started

### Prerequisites

- Node.js (v16 or later)
- npm or yarn
- Expo CLI (`npm install -g expo-cli`)
- iOS Simulator (for macOS) or Android Emulator
- Supabase account and project

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd formcoach-mobile
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Set up environment variables:
   Create a `.env` file in the root directory with:
   ```
   EXPO_PUBLIC_SUPABASE_URL=your_supabase_url
   EXPO_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

4. Start the development server:
   ```bash
   npm start
   ```

   **Note**: There is a known issue where running `npx expo start` directly may route to the parent `formcoach-dev` directory. Always use `npm start` instead, which uses a script that ensures the correct working directory.

5. Run on web (for development testing):
   ```bash
   npm run web
   ```

## Supabase Setup

1. Create a Supabase project at [supabase.com](https://supabase.com)
2. Set up the following tables in your Supabase database:
   - `profiles`: User data (id, username, full_name, avatar_url, goals, fitness_level)
   - `workout_plans`: Programs (id, name, description, duration_weeks, user_id)
   - `workout_plan_exercises`: Planned exercises (id, workout_plan_id, exercise_id, sets, reps, day_of_week)
   - `workout_sessions`: Workout sessions (id, user_id, workout_plan_id, start_time, end_time, notes)
   - `exercise_logs`: Workout logs (id, workout_session_id, exercise_id, sets_completed, reps_completed, weights_used)
   - `exercises`: Exercise catalog (id, name, description, muscle_groups, equipment, difficulty_level)

3. Enable email authentication in Supabase Auth settings

4. For Apple Sign-In (iOS):
   - Register your app with Apple Developer Program
   - Set up Sign in with Apple in Supabase Auth settings
   - Configure the redirect URL

## Project Structure

```
formcoach-mobile/
├── App.tsx                # Main app component
├── babel.config.js        # Babel configuration
├── tailwind.config.js     # NativeWind configuration
├── src/
│   ├── contexts/          # React contexts
│   │   └── AuthContext.tsx # Authentication context
│   ├── lib/               # Utilities and services
│   │   └── supabase.ts    # Supabase client configuration
│   ├── navigation/        # Navigation setup
│   │   └── index.tsx      # Navigation configuration
│   ├── screens/           # App screens
│   │   ├── HomeScreen.tsx
│   │   ├── LoginScreen.tsx
│   │   ├── SignUpScreen.tsx
│   │   ├── PlansScreen.tsx
│   │   ├── HistoryScreen.tsx
│   │   ├── ProfileScreen.tsx
│   │   └── ExerciseLogScreen.tsx
│   ├── types/             # TypeScript type definitions
│   │   └── app.d.ts       # App-wide type definitions
│   └── __tests__/         # Tests
│       ├── LoginScreen.test.tsx
│       └── web-e2e.test.tsx
```

## Testing

### Unit and Integration Tests

Run tests with:
```bash
npm test
```

### Web E2E Tests

Run web E2E tests with:
```bash
npm test -- web-e2e
```

## Building for Production

### iOS

1. Configure app.json with your iOS bundle identifier
2. Build for iOS:
   ```bash
   eas build --platform ios
   ```

3. Submit to App Store:
   ```bash
   eas submit --platform ios
   ```

### Android

1. Configure app.json with your Android package name
2. Build for Android:
   ```bash
   eas build --platform android
   ```

3. Submit to Google Play:
   ```bash
   eas submit --platform android
   ```

## Web Support

Web support is included for development testing only. To test the web version:

```bash
npx expo start --web
```

## Azure AD B2C Integration

To integrate with Azure AD B2C:

1. Create an Azure AD B2C tenant in the Azure Portal
2. Register your application in Azure AD B2C
3. Configure the redirect URI to your Supabase auth callback URL
4. In Supabase Dashboard, go to Authentication → Providers → Azure
5. Enter your Azure AD B2C client ID and secret
6. Update the auth configuration in your app

## Troubleshooting

- **Authentication Issues**: Check Supabase URL and anon key in .env file
- **Build Errors**: Make sure all dependencies are installed and compatible
- **Navigation Errors**: Verify screen names match in the navigation configuration
- **Styling Issues**: Check NativeWind configuration and class names
- **Expo Start Routing to Parent Directory**: If running `npx expo start` routes to the parent directory, use `npm start` instead, which uses a script that ensures the correct working directory. This happens because the parent directory also has Expo as a dependency, which can confuse the Expo CLI.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
