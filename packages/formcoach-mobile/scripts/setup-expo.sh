#!/bin/bash

echo "🔁 Setting up FormCoach Mobile with Expo..."

# Check if the formcoach-mobile directory exists
if [ -d "formcoach-mobile" ]; then
  echo "❓ The formcoach-mobile directory already exists. Do you want to overwrite it? (y/n)"
  read -r overwrite
  if [ "$overwrite" = "y" ] || [ "$overwrite" = "Y" ]; then
    echo "🗑️ Removing existing formcoach-mobile directory..."
    rm -rf formcoach-mobile
  else
    echo "❌ Setup aborted. Please rename or remove the existing formcoach-mobile directory."
    exit 1
  fi
fi

# Create a new Expo project
echo "🚀 Creating a new Expo project..."
npx create-expo-app formcoach-mobile --template blank-typescript

# Change to the project directory
cd formcoach-mobile

# Install dependencies
echo "📦 Installing dependencies..."
npm install @supabase/supabase-js @react-navigation/native @react-navigation/bottom-tabs @react-navigation/native-stack expo-secure-store react-native-screens react-native-safe-area-context nativewind
npm install -D tailwindcss

# Initialize NativeWind
echo "🎨 Setting up NativeWind..."
npx tailwindcss init

# Create tailwind.config.js
echo "⚙️ Configuring Tailwind CSS..."
cat > tailwind.config.js << 'EOL'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./App.{js,jsx,ts,tsx}", "./src/**/*.{js,jsx,ts,tsx}"],
  theme: {
    extend: {
      colors: {
        formcoach: {
          primary: '#3B82F6',
          secondary: '#10B981',
          accent: '#8B5CF6',
          dark: '#1F2937',
          light: '#F9FAFB',
        },
        status: {
          success: '#10B981',
          warning: '#F59E0B',
          error: '#EF4444',
          info: '#3B82F6',
        }
      },
      fontFamily: {
        sans: ['Inter', 'sans-serif'],
        heading: ['Poppins', 'sans-serif'],
      }
    },
  },
  plugins: [],
}
EOL

# Create babel.config.js with NativeWind
echo "⚙️ Configuring Babel for NativeWind..."
cat > babel.config.js << 'EOL'
module.exports = function(api) {
  api.cache(true);
  return {
    presets: ['babel-preset-expo'],
    plugins: ["nativewind/babel"],
  };
};
EOL

# Create app.d.ts for TypeScript
echo "⚙️ Setting up TypeScript definitions..."
mkdir -p src/types
cat > src/types/app.d.ts << 'EOL'
/// <reference types="nativewind/types" />
EOL

# Create Supabase configuration
echo "⚙️ Setting up Supabase configuration..."
mkdir -p src/lib
cat > src/lib/supabase.ts << 'EOL'
import 'react-native-url-polyfill/auto';
import { createClient } from '@supabase/supabase-js';
import * as SecureStore from 'expo-secure-store';
import { Platform } from 'react-native';

// Supabase URL and anon key from environment variables
const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL || 'https://gfaqeouktaxibmyzfnwr.supabase.co';
const supabaseAnonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdmYXFlb3VrdGF4aWJteXpmbndyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDYyMzAxMDIsImV4cCI6MjA2MTgwNjEwMn0.EmzRZtlWoZBpcYflghiULEQbDI_pQtGCUG1J9KuH3rw';

// Custom storage implementation for Supabase
const ExpoSecureStoreAdapter = {
  getItem: (key: string) => {
    return SecureStore.getItemAsync(key);
  },
  setItem: (key: string, value: string) => {
    SecureStore.setItemAsync(key, value);
  },
  removeItem: (key: string) => {
    SecureStore.deleteItemAsync(key);
  },
};

// Create Supabase client
export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    storage: Platform.OS === 'web' ? localStorage : ExpoSecureStoreAdapter,
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: Platform.OS === 'web',
  },
});
EOL

# Create AuthContext
echo "🔐 Setting up Authentication Context..."
mkdir -p src/contexts
cat > src/contexts/AuthContext.tsx << 'EOL'
import React, { createContext, useState, useEffect, useContext } from 'react';
import { supabase } from '../lib/supabase';
import { Session, User } from '@supabase/supabase-js';
import { Alert } from 'react-native';

type AuthContextType = {
  user: User | null;
  session: Session | null;
  loading: boolean;
  signIn: (email: string, password: string) => Promise<void>;
  signUp: (email: string, password: string) => Promise<void>;
  signOut: () => Promise<void>;
};

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [session, setSession] = useState<Session | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Get session on mount
    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(session);
      setUser(session?.user ?? null);
      setLoading(false);
    });

    // Listen for auth changes
    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      setSession(session);
      setUser(session?.user ?? null);
      setLoading(false);
    });

    return () => {
      subscription.unsubscribe();
    };
  }, []);

  const signIn = async (email: string, password: string) => {
    try {
      setLoading(true);
      const { error } = await supabase.auth.signInWithPassword({ email, password });
      if (error) throw error;
    } catch (error: any) {
      Alert.alert('Error signing in', error.message);
    } finally {
      setLoading(false);
    }
  };

  const signUp = async (email: string, password: string) => {
    try {
      setLoading(true);
      const { error } = await supabase.auth.signUp({ email, password });
      if (error) throw error;
      Alert.alert('Success', 'Check your email for the confirmation link');
    } catch (error: any) {
      Alert.alert('Error signing up', error.message);
    } finally {
      setLoading(false);
    }
  };

  const signOut = async () => {
    try {
      setLoading(true);
      const { error } = await supabase.auth.signOut();
      if (error) throw error;
    } catch (error: any) {
      Alert.alert('Error signing out', error.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <AuthContext.Provider value={{ user, session, loading, signIn, signUp, signOut }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};
EOL

# Create navigation
echo "🧭 Setting up Navigation..."
mkdir -p src/navigation
cat > src/navigation/index.tsx << 'EOL'
import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { useAuth } from '../contexts/AuthContext';
import { ActivityIndicator, View, Text } from 'react-native';

// Import screens
import HomeScreen from '../screens/HomeScreen';
import PlansScreen from '../screens/PlansScreen';
import HistoryScreen from '../screens/HistoryScreen';
import ProfileScreen from '../screens/ProfileScreen';
import LoginScreen from '../screens/LoginScreen';
import SignUpScreen from '../screens/SignUpScreen';
import ExerciseLogScreen from '../screens/ExerciseLogScreen';

// Define navigation types
export type RootStackParamList = {
  Main: undefined;
  Login: undefined;
  SignUp: undefined;
  ExerciseLog: { exerciseId: string; workoutPlanId?: string };
};

export type MainTabParamList = {
  Home: undefined;
  Plans: undefined;
  History: undefined;
  Profile: undefined;
};

// Create navigators
const Stack = createNativeStackNavigator<RootStackParamList>();
const Tab = createBottomTabNavigator<MainTabParamList>();

// Main tab navigator
const MainNavigator = () => {
  return (
    <Tab.Navigator
      screenOptions={{
        tabBarActiveTintColor: '#3B82F6',
        tabBarInactiveTintColor: '#9CA3AF',
        tabBarLabelStyle: { fontSize: 12 },
        headerShown: false,
      }}
    >
      <Tab.Screen 
        name="Home" 
        component={HomeScreen} 
        options={{ 
          tabBarIcon: ({ color }) => <Text style={{ color }}>🏠</Text>,
        }} 
      />
      <Tab.Screen 
        name="Plans" 
        component={PlansScreen} 
        options={{ 
          tabBarIcon: ({ color }) => <Text style={{ color }}>📋</Text>,
        }} 
      />
      <Tab.Screen 
        name="History" 
        component={HistoryScreen} 
        options={{ 
          tabBarIcon: ({ color }) => <Text style={{ color }}>📊</Text>,
        }} 
      />
      <Tab.Screen 
        name="Profile" 
        component={ProfileScreen} 
        options={{ 
          tabBarIcon: ({ color }) => <Text style={{ color }}>👤</Text>,
        }} 
      />
    </Tab.Navigator>
  );
};

// Root navigator
export const Navigation = () => {
  const { user, loading } = useAuth();

  if (loading) {
    return (
      <View className="flex-1 justify-center items-center bg-white">
        <ActivityIndicator size="large" color="#3B82F6" />
      </View>
    );
  }

  return (
    <NavigationContainer>
      <Stack.Navigator screenOptions={{ headerShown: false }}>
        {user ? (
          <>
            <Stack.Screen name="Main" component={MainNavigator} />
            <Stack.Screen name="ExerciseLog" component={ExerciseLogScreen} options={{ headerShown: true, title: 'Log Exercise' }} />
          </>
        ) : (
          <>
            <Stack.Screen name="Login" component={LoginScreen} />
            <Stack.Screen name="SignUp" component={SignUpScreen} />
          </>
        )}
      </Stack.Navigator>
    </NavigationContainer>
  );
};
EOL

# Create basic screens
echo "📱 Creating basic screens..."
mkdir -p src/screens

# Login Screen
cat > src/screens/LoginScreen.tsx << 'EOL'
import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, ActivityIndicator, Alert, Platform } from 'react-native';
import { useAuth } from '../contexts/AuthContext';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { RootStackParamList } from '../navigation';

type Props = NativeStackScreenProps<RootStackParamList, 'Login'>;

const LoginScreen: React.FC<Props> = ({ navigation }) => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const { signIn, loading } = useAuth();

  const handleLogin = async () => {
    if (!email || !password) {
      Alert.alert('Error', 'Please enter both email and password');
      return;
    }
    await signIn(email, password);
  };

  return (
    <View className="flex-1 justify-center p-6 bg-white">
      <Text className="text-3xl font-bold mb-6 text-center text-formcoach-dark">FormCoach</Text>
      <Text className="text-xl font-semibold mb-6 text-center text-formcoach-dark">Login</Text>
      
      <View className="mb-4">
        <Text className="text-sm font-medium text-gray-700 mb-1">Email</Text>
        <TextInput
          className="w-full p-3 border border-gray-300 rounded-md bg-gray-50"
          placeholder="Enter your email"
          value={email}
          onChangeText={setEmail}
          autoCapitalize="none"
          keyboardType="email-address"
        />
      </View>
      
      <View className="mb-6">
        <Text className="text-sm font-medium text-gray-700 mb-1">Password</Text>
        <TextInput
          className="w-full p-3 border border-gray-300 rounded-md bg-gray-50"
          placeholder="Enter your password"
          value={password}
          onChangeText={setPassword}
          secureTextEntry
        />
      </View>
      
      <TouchableOpacity
        className="w-full bg-formcoach-primary p-3 rounded-md items-center"
        onPress={handleLogin}
        disabled={loading}
      >
        {loading ? (
          <ActivityIndicator color="white" />
        ) : (
          <Text className="text-white font-semibold text-center">Login</Text>
        )}
      </TouchableOpacity>
      
      <TouchableOpacity 
        className="mt-4" 
        onPress={() => navigation.navigate('SignUp')}
      >
        <Text className="text-formcoach-primary text-center">Don't have an account? Sign Up</Text>
      </TouchableOpacity>

      {Platform.OS === 'ios' && (
        <TouchableOpacity 
          className="mt-6 w-full bg-black p-3 rounded-md items-center flex-row justify-center"
          onPress={() => Alert.alert('Apple Sign In', 'This would trigger Apple Sign In')}
        >
          <Text className="text-white font-semibold text-center ml-2">Sign in with Apple</Text>
        </TouchableOpacity>
      )}
    </View>
  );
};

export default LoginScreen;
EOL

# SignUp Screen
cat > src/screens/SignUpScreen.tsx << 'EOL'
import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, ActivityIndicator, Alert } from 'react-native';
import { useAuth } from '../contexts/AuthContext';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { RootStackParamList } from '../navigation';

type Props = NativeStackScreenProps<RootStackParamList, 'SignUp'>;

const SignUpScreen: React.FC<Props> = ({ navigation }) => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const { signUp, loading } = useAuth();

  const handleSignUp = async () => {
    if (!email || !password || !confirmPassword) {
      Alert.alert('Error', 'Please fill in all fields');
      return;
    }
    
    if (password !== confirmPassword) {
      Alert.alert('Error', 'Passwords do not match');
      return;
    }
    
    await signUp(email, password);
  };

  return (
    <View className="flex-1 justify-center p-6 bg-white">
      <Text className="text-3xl font-bold mb-6 text-center text-formcoach-dark">FormCoach</Text>
      <Text className="text-xl font-semibold mb-6 text-center text-formcoach-dark">Create Account</Text>
      
      <View className="mb-4">
        <Text className="text-sm font-medium text-gray-700 mb-1">Email</Text>
        <TextInput
          className="w-full p-3 border border-gray-300 rounded-md bg-gray-50"
          placeholder="Enter your email"
          value={email}
          onChangeText={setEmail}
          autoCapitalize="none"
          keyboardType="email-address"
        />
      </View>
      
      <View className="mb-4">
        <Text className="text-sm font-medium text-gray-700 mb-1">Password</Text>
        <TextInput
          className="w-full p-3 border border-gray-300 rounded-md bg-gray-50"
          placeholder="Create a password"
          value={password}
          onChangeText={setPassword}
          secureTextEntry
        />
      </View>
      
      <View className="mb-6">
        <Text className="text-sm font-medium text-gray-700 mb-1">Confirm Password</Text>
        <TextInput
          className="w-full p-3 border border-gray-300 rounded-md bg-gray-50"
          placeholder="Confirm your password"
          value={confirmPassword}
          onChangeText={setConfirmPassword}
          secureTextEntry
        />
      </View>
      
      <TouchableOpacity
        className="w-full bg-formcoach-primary p-3 rounded-md items-center"
        onPress={handleSignUp}
        disabled={loading}
      >
        {loading ? (
          <ActivityIndicator color="white" />
        ) : (
          <Text className="text-white font-semibold text-center">Sign Up</Text>
        )}
      </TouchableOpacity>
      
      <TouchableOpacity 
        className="mt-4" 
        onPress={() => navigation.navigate('Login')}
      >
        <Text className="text-formcoach-primary text-center">Already have an account? Login</Text>
      </TouchableOpacity>
    </View>
  );
};

export default SignUpScreen;
EOL

# Home Screen
cat > src/screens/HomeScreen.tsx << 'EOL'
import React, { useEffect, useState } from 'react';
import { View, Text, ScrollView, TouchableOpacity, ActivityIndicator } from 'react-native';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';

const HomeScreen = () => {
  const { user } = useAuth();
  const [loading, setLoading] = useState(true);
  const [profile, setProfile] = useState<any>(null);
  const [recentWorkouts, setRecentWorkouts] = useState<any[]>([]);

  useEffect(() => {
    if (user) {
      fetchProfile();
      fetchRecentWorkouts();
    }
  }, [user]);

  const fetchProfile = async () => {
    try {
      const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', user?.id)
        .single();

      if (error) throw error;
      setProfile(data);
    } catch (error) {
      console.error('Error fetching profile:', error);
    } finally {
      setLoading(false);
    }
  };

  const fetchRecentWorkouts = async () => {
    try {
      const { data, error } = await supabase
        .from('workout_sessions')
        .select('*, workout_plans(name)')
        .eq('user_id', user?.id)
        .order('created_at', { ascending: false })
        .limit(5);

      if (error) throw error;
      setRecentWorkouts(data || []);
    } catch (error) {
      console.error('Error fetching recent workouts:', error);
    }
  };

  if (loading) {
    return (
      <View className="flex-1 justify-center items-center bg-white">
        <ActivityIndicator size="large" color="#3B82F6" />
      </View>
    );
  }

  return (
    <ScrollView className="flex-1 bg-gray-50">
      <View className="p-6 bg-formcoach-primary">
        <Text className="text-2xl font-bold text-white">
          Welcome, {profile?.full_name || profile?.username || 'User'}
        </Text>
        <Text className="text-white opacity-80 mt-1">
          Let's track your fitness journey
        </Text>
      </View>

      <View className="p-6">
        <Text className="text-xl font-semibold mb-4">Recent Workouts</Text>
        
        {recentWorkouts.length === 0 ? (
          <View className="bg-white p-4 rounded-lg shadow-sm border border-gray-200">
            <Text className="text-gray-600">No recent workouts found. Start logging your exercises!</Text>
          </View>
        ) : (
          recentWorkouts.map((workout) => (
            <View key={workout.id} className="bg-white p-4 rounded-lg shadow-sm border border-gray-200 mb-3">
              <Text className="font-semibold">{workout.workout_plans?.name || 'Workout'}</Text>
              <Text className="text-gray-600 text-sm mt-1">
                {new Date(workout.created_at).toLocaleDateString()}
              </Text>
            </View>
          ))
        )}

        <TouchableOpacity className="mt-6 bg-formcoach-secondary p-4 rounded-lg items-center">
          <Text className="text-white font-semibold">Start New Workout</Text>
        </TouchableOpacity>
      </View>
    </ScrollView>
  );
};

export default HomeScreen;
EOL

# Plans Screen
cat > src/screens/PlansScreen.tsx << 'EOL'
import React, { useEffect, useState } from 'react';
import { View, Text, FlatList, TouchableOpacity, ActivityIndicator, Alert } from 'react-native';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import { useNavigation } from '@react-navigation/native';
import { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { RootStackParamList } from '../navigation';

type WorkoutPlan = {
  id: string;
  name: string;
  description: string;
  duration_weeks: number;
  frequency: string;
  created_at: string;
};

const PlansScreen = () => {
  const { user } = useAuth();
  const [loading, setLoading] = useState(true);
  const [workoutPlans, setWorkoutPlans] = useState<WorkoutPlan[]>([]);
  const navigation = useNavigation<NativeStackNavigationProp<RootStackParamList>>();

  useEffect(() => {
    if (user) {
      fetchWorkoutPlans();
    }
  }, [user]);

  const fetchWorkoutPlans = async () => {
    try {
      setLoading(true);
      const { data, error } = await supabase
        .from('workout_plans')
        .select('*')
        .eq('user_id', user?.id)
        .order('created_at', { ascending: false });

      if (error) throw error;
      setWorkoutPlans(data || []);
    } catch (error: any) {
      Alert.alert('Error fetching workout plans', error.message);
    } finally {
      setLoading(false);
    }
  };

  const handlePlanPress = (plan: WorkoutPlan) => {
    // Navigate to plan details or start workout
    Alert.alert(
      plan.name,
      'What would you like to do?',
      [
        {
          text: 'View Details',
          onPress: () => console.log('View details for', plan.id),
        },
        {
          text: 'Start Workout',
          onPress: () => console.log('Start workout for', plan.id),
        },
        {
          text: 'Cancel',
          style: 'cancel',
        },
      ]
    );
  };

  if (loading) {
    return (
      <View className="flex-1 justify-center items-center bg-white">
        <ActivityIndicator size="large" color="#3B82F6" />
      </View>
    );
  }

  return (
    <View className="flex-1 bg-gray-50">
      <View className="p-6 bg-white border-b border-gray-200">
        <Text className="text-2xl font-bold">Workout Plans</Text>
      </View>

      {workoutPlans.length === 0 ? (
        <View className="flex-1 justify-center items-center p-6">
          <Text className="text-gray-600 text-center mb-4">
            You don't have any workout plans yet.
          </Text>
          <TouchableOpacity 
            className="bg-formcoach-primary px-4 py-2 rounded-md"
            onPress={() => Alert.alert('Create Plan', 'This would open the plan creation form')}
          >
            <Text className="text-white font-semibold">Create New Plan</Text>
          </TouchableOpacity>
        </View>
      ) : (
        <FlatList
          data={workoutPlans}
          keyExtractor={(item) => item.id}
          contentContainerStyle={{ padding: 16 }}
          renderItem={({ item }) => (
            <TouchableOpacity
              className="bg-white p-4 rounded-lg shadow-sm border border-gray-200 mb-3"
              onPress={() => handlePlanPress(item)}
            >
              <Text className="font-semibold text-lg">{item.name}</Text>
              <Text className="text-gray-600 mt-1">{item.description}</Text>
              <View className="flex-row mt-2">
                <Text className="text-gray-500 text-sm">{item.duration_weeks} weeks</Text>
                <Text className="text-gray-500 text-sm ml-4">{item.frequency}</Text>
              </View>
            </TouchableOpacity>
          )}
        />
      )}

      <TouchableOpacity 
        className="absolute bottom-6 right-6 bg-formcoach-primary w-14 h-14 rounded-full justify-center items-center shadow-md"
        onPress={() => Alert.alert('Create Plan', 'This would open the plan creation form')}
      >
        <Text className="text-white text-2xl">+</Text>
      </TouchableOpacity>
    </View>
  );
};

export default PlansScreen;
EOL

# History Screen
cat > src/screens/HistoryScreen.tsx << 'EOL'
import React, { useEffect, useState } from 'react';
import { View, Text, FlatList, TouchableOpacity, ActivityIndicator, Alert } from 'react-native';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';

type WorkoutSession = {
  id: string;
  user_id: string;
  workout_plan_id: string;
  start_time: string;
  end_time: string;
  notes: string;
  overall_feeling: string;
  created_at: string;
  workout_plans: {
    name: string;
  };
};

const HistoryScreen = () => {
  const { user } = useAuth();
  const [loading, setLoading] = useState(true);
  const [workoutHistory, setWorkoutHistory] = useState<WorkoutSession[]>([]);

  useEffect(() => {
    if (user) {
      fetchWorkoutHistory();
    }
  }, [user]);

  const fetchWorkoutHistory = async () => {
    try {
      setLoading(true);
      const { data, error } = await supabase
        .from('workout_sessions')
        .select('*, workout_plans(name)')
        .eq('user_id', user?.id)
        .order('created_at', { ascending: false });

      if (error) throw error;
      setWorkoutHistory(data || []);
    } catch (error: any) {
      Alert.alert('Error fetching workout history', error.message);
    } finally {
      setLoading(false);
    }
  };

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', {
      weekday: 'short