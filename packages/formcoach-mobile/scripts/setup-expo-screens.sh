#!/bin/bash

echo "📱 Creating remaining screens for FormCoach Mobile..."

# Check if the formcoach-mobile directory exists
if [ ! -d "formcoach-mobile" ]; then
  echo "❌ The formcoach-mobile directory doesn't exist. Please run setup-expo.sh first."
  exit 1
fi

# Change to the project directory
cd formcoach-mobile

# Create remaining screens
echo "📱 Creating History, Profile, and ExerciseLog screens..."
mkdir -p src/screens

# History Screen (complete version)
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
      weekday: 'short',
      month: 'short',
      day: 'numeric',
      year: 'numeric',
    });
  };

  const formatTime = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleTimeString('en-US', {
      hour: '2-digit',
      minute: '2-digit',
    });
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
        <Text className="text-2xl font-bold">Workout History</Text>
      </View>

      {workoutHistory.length === 0 ? (
        <View className="flex-1 justify-center items-center p-6">
          <Text className="text-gray-600 text-center">
            You haven't logged any workouts yet.
          </Text>
        </View>
      ) : (
        <FlatList
          data={workoutHistory}
          keyExtractor={(item) => item.id}
          contentContainerStyle={{ padding: 16 }}
          renderItem={({ item }) => (
            <TouchableOpacity
              className="bg-white p-4 rounded-lg shadow-sm border border-gray-200 mb-3"
              onPress={() => Alert.alert('Workout Details', `View details for ${item.workout_plans?.name || 'Workout'}`)}
            >
              <Text className="font-semibold text-lg">{item.workout_plans?.name || 'Workout'}</Text>
              <Text className="text-gray-600 mt-1">{formatDate(item.created_at)}</Text>
              <View className="flex-row justify-between mt-2">
                <Text className="text-gray-500 text-sm">
                  {formatTime(item.start_time)} - {formatTime(item.end_time)}
                </Text>
                <Text className="text-gray-500 text-sm">
                  Feeling: {item.overall_feeling || 'Not recorded'}
                </Text>
              </View>
              {item.notes && (
                <Text className="text-gray-600 mt-2 italic">"{item.notes}"</Text>
              )}
            </TouchableOpacity>
          )}
        />
      )}
    </View>
  );
};

export default HistoryScreen;
EOL

# Profile Screen
cat > src/screens/ProfileScreen.tsx << 'EOL'
import React, { useEffect, useState } from 'react';
import { View, Text, ScrollView, TouchableOpacity, ActivityIndicator, Alert, TextInput } from 'react-native';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';

type Profile = {
  id: string;
  username: string;
  full_name: string;
  avatar_url: string | null;
  goals: string[];
  fitness_level: string;
  created_at: string;
};

const ProfileScreen = () => {
  const { user, signOut } = useAuth();
  const [loading, setLoading] = useState(true);
  const [profile, setProfile] = useState<Profile | null>(null);
  const [editing, setEditing] = useState(false);
  const [fullName, setFullName] = useState('');
  const [username, setUsername] = useState('');
  const [fitnessLevel, setFitnessLevel] = useState('');
  const [goals, setGoals] = useState<string[]>([]);

  useEffect(() => {
    if (user) {
      fetchProfile();
    }
  }, [user]);

  const fetchProfile = async () => {
    try {
      setLoading(true);
      const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', user?.id)
        .single();

      if (error) throw error;
      
      setProfile(data);
      setFullName(data.full_name || '');
      setUsername(data.username || '');
      setFitnessLevel(data.fitness_level || '');
      setGoals(data.goals || []);
    } catch (error: any) {
      Alert.alert('Error fetching profile', error.message);
    } finally {
      setLoading(false);
    }
  };

  const handleSaveProfile = async () => {
    try {
      setLoading(true);
      
      const updates = {
        id: user?.id,
        full_name: fullName,
        username,
        fitness_level: fitnessLevel,
        goals,
        updated_at: new Date().toISOString(),
      };
      
      const { error } = await supabase
        .from('profiles')
        .upsert(updates);
        
      if (error) throw error;
      
      Alert.alert('Success', 'Profile updated successfully');
      setEditing(false);
      fetchProfile();
    } catch (error: any) {
      Alert.alert('Error updating profile', error.message);
    } finally {
      setLoading(false);
    }
  };

  const handleLogout = async () => {
    Alert.alert(
      'Confirm Logout',
      'Are you sure you want to log out?',
      [
        {
          text: 'Cancel',
          style: 'cancel',
        },
        {
          text: 'Logout',
          onPress: signOut,
          style: 'destructive',
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
    <ScrollView className="flex-1 bg-gray-50">
      <View className="p-6 bg-formcoach-primary">
        <Text className="text-2xl font-bold text-white">
          {editing ? 'Edit Profile' : 'Your Profile'}
        </Text>
      </View>

      <View className="p-6">
        {editing ? (
          // Edit mode
          <View>
            <View className="mb-4">
              <Text className="text-sm font-medium text-gray-700 mb-1">Full Name</Text>
              <TextInput
                className="w-full p-3 border border-gray-300 rounded-md bg-gray-50"
                value={fullName}
                onChangeText={setFullName}
                placeholder="Enter your full name"
              />
            </View>
            
            <View className="mb-4">
              <Text className="text-sm font-medium text-gray-700 mb-1">Username</Text>
              <TextInput
                className="w-full p-3 border border-gray-300 rounded-md bg-gray-50"
                value={username}
                onChangeText={setUsername}
                placeholder="Enter a username"
              />
            </View>
            
            <View className="mb-4">
              <Text className="text-sm font-medium text-gray-700 mb-1">Fitness Level</Text>
              <TextInput
                className="w-full p-3 border border-gray-300 rounded-md bg-gray-50"
                value={fitnessLevel}
                onChangeText={setFitnessLevel}
                placeholder="beginner, intermediate, advanced"
              />
            </View>
            
            <View className="flex-row mt-6">
              <TouchableOpacity
                className="flex-1 bg-gray-300 p-3 rounded-md items-center mr-2"
                onPress={() => setEditing(false)}
              >
                <Text className="font-semibold">Cancel</Text>
              </TouchableOpacity>
              
              <TouchableOpacity
                className="flex-1 bg-formcoach-primary p-3 rounded-md items-center ml-2"
                onPress={handleSaveProfile}
              >
                <Text className="text-white font-semibold">Save</Text>
              </TouchableOpacity>
            </View>
          </View>
        ) : (
          // View mode
          <View>
            <View className="bg-white p-4 rounded-lg shadow-sm border border-gray-200 mb-4">
              <Text className="text-gray-500 text-sm">Full Name</Text>
              <Text className="font-semibold text-lg">{profile?.full_name || 'Not set'}</Text>
            </View>
            
            <View className="bg-white p-4 rounded-lg shadow-sm border border-gray-200 mb-4">
              <Text className="text-gray-500 text-sm">Username</Text>
              <Text className="font-semibold text-lg">{profile?.username || 'Not set'}</Text>
            </View>
            
            <View className="bg-white p-4 rounded-lg shadow-sm border border-gray-200 mb-4">
              <Text className="text-gray-500 text-sm">Email</Text>
              <Text className="font-semibold text-lg">{user?.email}</Text>
            </View>
            
            <View className="bg-white p-4 rounded-lg shadow-sm border border-gray-200 mb-4">
              <Text className="text-gray-500 text-sm">Fitness Level</Text>
              <Text className="font-semibold text-lg capitalize">{profile?.fitness_level || 'Not set'}</Text>
            </View>
            
            <View className="bg-white p-4 rounded-lg shadow-sm border border-gray-200 mb-6">
              <Text className="text-gray-500 text-sm">Goals</Text>
              {profile?.goals && profile.goals.length > 0 ? (
                <View className="flex-row flex-wrap mt-1">
                  {profile.goals.map((goal, index) => (
                    <View key={index} className="bg-gray-100 px-2 py-1 rounded-md mr-2 mt-1">
                      <Text className="text-gray-800 capitalize">{goal}</Text>
                    </View>
                  ))}
                </View>
              ) : (
                <Text className="font-semibold text-lg">No goals set</Text>
              )}
            </View>
            
            <TouchableOpacity
              className="bg-formcoach-primary p-3 rounded-md items-center mb-3"
              onPress={() => setEditing(true)}
            >
              <Text className="text-white font-semibold">Edit Profile</Text>
            </TouchableOpacity>
            
            <TouchableOpacity
              className="bg-gray-200 p-3 rounded-md items-center"
              onPress={handleLogout}
            >
              <Text className="font-semibold text-gray-800">Logout</Text>
            </TouchableOpacity>
          </View>
        )}
      </View>
    </ScrollView>
  );
};

export default ProfileScreen;
EOL

# ExerciseLog Screen (Priority)
cat > src/screens/ExerciseLogScreen.tsx << 'EOL'
import React, { useEffect, useState } from 'react';
import { View, Text, ScrollView, TextInput, TouchableOpacity, ActivityIndicator, Alert } from 'react-native';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { RootStackParamList } from '../navigation';

type Props = NativeStackScreenProps<RootStackParamList, 'ExerciseLog'>;

type Exercise = {
  id: string;
  name: string;
  description: string;
  muscle_groups: string[];
  equipment: string[];
  difficulty_level: string;
};

type SetData = {
  reps: string;
  weight: string;
};

const ExerciseLogScreen: React.FC<Props> = ({ route, navigation }) => {
  const { exerciseId, workoutPlanId } = route.params;
  const { user } = useAuth();
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [exercise, setExercise] = useState<Exercise | null>(null);
  const [sets, setSets] = useState<SetData[]>([{ reps: '', weight: '' }]);
  const [notes, setNotes] = useState('');
  const [formFeedback, setFormFeedback] = useState('');
  const [sorenessRating, setSorenessRating] = useState<number | null>(null);
  const [sessionId, setSessionId] = useState<string | null>(null);

  useEffect(() => {
    if (user && exerciseId) {
      fetchExercise();
      checkOrCreateSession();
    }
  }, [user, exerciseId]);

  const fetchExercise = async () => {
    try {
      const { data, error } = await supabase
        .from('exercises')
        .select('*')
        .eq('id', exerciseId)
        .single();

      if (error) throw error;
      setExercise(data);
    } catch (error: any) {
      Alert.alert('Error fetching exercise', error.message);
    } finally {
      setLoading(false);
    }
  };

  const checkOrCreateSession = async () => {
    try {
      // Check if there's an active session for today
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      
      const { data, error } = await supabase
        .from('workout_sessions')
        .select('id')
        .eq('user_id', user?.id)
        .eq('workout_plan_id', workoutPlanId || null)
        .gte('created_at', today.toISOString())
        .order('created_at', { ascending: false })
        .limit(1);

      if (error) throw error;

      if (data && data.length > 0) {
        // Use existing session
        setSessionId(data[0].id);
      } else {
        // Create new session
        const { data: newSession, error: createError } = await supabase
          .from('workout_sessions')
          .insert({
            user_id: user?.id,
            workout_plan_id: workoutPlanId || null,
            start_time: new Date().toISOString(),
            end_time: new Date(Date.now() + 3600000).toISOString(), // 1 hour later
          })
          .select('id');

        if (createError) throw createError;
        
        if (newSession && newSession.length > 0) {
          setSessionId(newSession[0].id);
        }
      }
    } catch (error: any) {
      Alert.alert('Error creating workout session', error.message);
    }
  };

  const addSet = () => {
    setSets([...sets, { reps: '', weight: '' }]);
  };

  const removeSet = (index: number) => {
    if (sets.length > 1) {
      const newSets = [...sets];
      newSets.splice(index, 1);
      setSets(newSets);
    }
  };

  const updateSet = (index: number, field: 'reps' | 'weight', value: string) => {
    const newSets = [...sets];
    newSets[index][field] = value;
    setSets(newSets);
  };

  const handleSubmit = async () => {
    if (!sessionId) {
      Alert.alert('Error', 'No active workout session');
      return;
    }

    // Validate inputs
    const validSets = sets.filter(set => set.reps.trim() !== '' && set.weight.trim() !== '');
    if (validSets.length === 0) {
      Alert.alert('Error', 'Please enter at least one set with reps and weight');
      return;
    }

    try {
      setSubmitting(true);

      const repsArray = validSets.map(set => parseInt(set.reps, 10));
      const weightsArray = validSets.map(set => parseFloat(set.weight));

      const { error } = await supabase
        .from('exercise_logs')
        .insert({
          workout_session_id: sessionId,
          exercise_id: exerciseId,
          sets_completed: validSets.length,
          reps_completed: repsArray,
          weights_used: weightsArray,
          form_feedback: formFeedback,
          soreness_rating: sorenessRating,
          notes: notes,
        });

      if (error) throw error;

      Alert.alert('Success', 'Exercise logged successfully', [
        { text: 'OK', onPress: () => navigation.goBack() }
      ]);
    } catch (error: any) {
      Alert.alert('Error logging exercise', error.message);
    } finally {
      setSubmitting(false);
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
      <View className="p-6">
        <Text className="text-2xl font-bold mb-2">{exercise?.name}</Text>
        <Text className="text-gray-600 mb-4">{exercise?.description}</Text>
        
        <View className="flex-row flex-wrap mb-4">
          {exercise?.muscle_groups?.map((muscle, index) => (
            <View key={index} className="bg-formcoach-primary bg-opacity-20 px-2 py-1 rounded-md mr-2 mb-2">
              <Text className="text-formcoach-primary capitalize">{muscle}</Text>
            </View>
          ))}
        </View>
        
        <Text className="text-xl font-semibold mb-4">Log Your Sets</Text>
        
        {sets.map((set, index) => (
          <View key={index} className="flex-row items-center mb-3">
            <View className="w-10">
              <Text className="font-semibold text-center">{index + 1}</Text>
            </View>
            
            <View className="flex-1 mr-2">
              <Text className="text-sm text-gray-600 mb-1">Reps</Text>
              <TextInput
                className="border border-gray-300 rounded-md p-2 bg-white"
                value={set.reps}
                onChangeText={(value) => updateSet(index, 'reps', value)}
                keyboardType="number-pad"
                placeholder="0"
              />
            </View>
            
            <View className="flex-1 mr-2">
              <Text className="text-sm text-gray-600 mb-1">Weight (kg)</Text>
              <TextInput
                className="border border-gray-300 rounded-md p-2 bg-white"
                value={set.weight}
                onChangeText={(value) => updateSet(index, 'weight', value)}
                keyboardType="decimal-pad"
                placeholder="0.0"
              />
            </View>
            
            <TouchableOpacity
              className="w-10 h-10 justify-center items-center"
              onPress={() => removeSet(index)}
            >
              <Text className="text-red-500 text-xl">×</Text>
            </TouchableOpacity>
          </View>
        ))}
        
        <TouchableOpacity
          className="bg-gray-200 p-2 rounded-md items-center mb-6"
          onPress={addSet}
        >
          <Text className="font-semibold">Add Set</Text>
        </TouchableOpacity>
        
        <View className="mb-4">
          <Text className="text-sm font-medium text-gray-700 mb-1">Form Feedback</Text>
          <TextInput
            className="border border-gray-300 rounded-md p-3 bg-white"
            value={formFeedback}
            onChangeText={setFormFeedback}
            placeholder="How was your form? Any issues?"
            multiline
          />
        </View>
        
        <View className="mb-4">
          <Text className="text-sm font-medium text-gray-700 mb-1">Soreness Rating (1-5)</Text>
          <View className="flex-row justify-between mb-2">
            {[1, 2, 3, 4, 5].map((rating) => (
              <TouchableOpacity
                key={rating}
                className={`w-16 h-16 rounded-full justify-center items-center ${
                  sorenessRating === rating ? 'bg-formcoach-primary' : 'bg-gray-200'
                }`}
                onPress={() => setSorenessRating(rating)}
              >
                <Text
                  className={`text-lg font-bold ${
                    sorenessRating === rating ? 'text-white' : 'text-gray-700'
                  }`}
                >
                  {rating}
                </Text>
              </TouchableOpacity>
            ))}
          </View>
          <View className="flex-row justify-between px-2">
            <Text className="text-xs text-gray-500">None</Text>
            <Text className="text-xs text-gray-500">Severe</Text>
          </View>
        </View>
        
        <View className="mb-6">
          <Text className="text-sm font-medium text-gray-700 mb-1">Notes</Text>
          <TextInput
            className="border border-gray-300 rounded-md p-3 bg-white"
            value={notes}
            onChangeText={setNotes}
            placeholder="Any additional notes about this exercise"
            multiline
            numberOfLines={3}
          />
        </View>
        
        <TouchableOpacity
          className="bg-formcoach-primary p-4 rounded-md items-center"
          onPress={handleSubmit}
          disabled={submitting}
        >
          {submitting ? (
            <ActivityIndicator color="white" />
          ) : (
            <Text className="text-white font-semibold">Save Exercise Log</Text>
          )}
        </TouchableOpacity>
      </View>
    </ScrollView>
  );
};

export default ExerciseLogScreen;
EOL

# Update App.tsx
cat > ../App.tsx << 'EOL'
import React from 'react';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { AuthProvider } from './src/contexts/AuthContext';
import { Navigation } from './src/navigation';
import { StatusBar } from 'react-native';

export default function App() {
  return (
    <SafeAreaProvider>
      <StatusBar barStyle="dark-content" backgroundColor="#FFFFFF" />
      <AuthProvider>
        <Navigation />
      </AuthProvider>
    </SafeAreaProvider>
  );
}
EOL

# Create a basic test setup
echo "🧪 Setting up testing infrastructure..."
mkdir -p src/__tests__

# Create a basic test for the LoginScreen
cat > src/__tests__/LoginScreen.test.tsx << 'EOL'
import React from 'react';
import { render, fireEvent, waitFor } from '@testing-library/react-native';
import LoginScreen from '../screens/LoginScreen';
import { AuthProvider } from '../contexts/AuthContext';

// Mock the navigation
const mockNavigation = {
  navigate: jest.fn(),
};

// Mock the auth context
jest.mock('../contexts/AuthContext', () => ({
  AuthProvider: ({ children }: { children: React.ReactNode }) => children,
  useAuth: () => ({
    signIn: jest.fn(),
    loading: false,
  }),
}));

describe('LoginScreen', () => {
  it('renders correctly', () => {
    const { getByText, getByPlaceholderText } = render(
      <LoginScreen navigation={mockNavigation as any} route={{} as any} />
    );
    
    expect(getByText('FormCoach')).toBeTruthy();
    expect(getByText('Login')).toBeTruthy();
    expect(getByPlaceholderText('Enter your email')).toBeTruthy();
    expect(getByPlaceholderText('Enter your password')).toBeTruthy();
  });

  it('shows error when submitting empty form', () => {
    const { getByText } = render(
      <LoginScreen navigation={mockNavigation as any} route={{} as any} />
    );
    
    const alertMock = jest.spyOn(global, 'alert').mockImplementation();
    
    fireEvent.press(getByText('Login'));
    
    expect(alertMock).toHaveBeenCalledWith('Error', 'Please enter both email and password');
    alertMock.mockRestore();
  });
});
EOL

# Create a basic E2E test with Jest/jsdom for web
cat > src/__tests__/web-e2e.test.tsx << 'EOL'
/**
 * Web E2E tests using Jest/jsdom
 * 
 * These tests simulate user flows in the web version of the app.
 * Run with: npm test -- web-e2e
 */

import React from 'react';
import { render, fireEvent, waitFor } from '@testing-library/react-native';
import App from '../../App';

// Mock the Platform to simulate web environment
jest.mock('react-native/Libraries/Utilities/Platform', () => ({
  OS: 'web',
  select: jest.fn(obj => obj.web),
}));

// Mock Supabase client
jest.mock('../lib/supabase', () => ({
  supabase: {
    auth: {
      getSession: jest.fn().mockResolvedValue({ data: { session: null } }),
      onAuthStateChange: jest.fn().mockReturnValue({ data: { subscription: { unsubscribe: jest.fn() } } }),
      signInWithPassword: jest.fn().mockResolvedValue({ error: null }),
      signUp: jest.fn().mockResolvedValue({ error: null }),
    },
  },
}));

describe('Web App E2E', () => {
  it('renders login screen initially', async () => {
    const { getByText, getByPlaceholderText } = render(<App />);
    
    await waitFor(() => {
      expect(getByText('FormCoach')).toBeTruthy();
      expect(getByText('Login')).toBeTruthy();
      expect(getByPlaceholderText('Enter your email')).toBeTruthy();
    });
  });

  it('navigates to signup screen', async () => {
    const { getByText } = render(<App />);
    
    await waitFor(() => {
      const signupLink = getByText("Don't have an account? Sign Up");
      fireEvent.press(signupLink);
    });
    
    await waitFor(() => {
      expect(getByText('Create Account')).toBeTruthy();
    });
  });
});
EOL