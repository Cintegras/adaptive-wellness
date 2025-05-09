// Simple script to test Supabase connectivity
import { createClient } from '@supabase/supabase-js';
import 'react-native-url-polyfill/auto';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL;
const supabaseAnonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  console.error('Error: Supabase URL or Anon Key not found in environment variables.');
  console.error('Make sure you have a .env file with EXPO_PUBLIC_SUPABASE_URL and EXPO_PUBLIC_SUPABASE_ANON_KEY.');
  process.exit(1);
}

// Initialize Supabase client
const supabase = createClient(supabaseUrl, supabaseAnonKey);

async function testSupabase() {
  try {
    console.log('Testing Supabase connectivity...');
    
    // Test a simple query to the exercise_logs table
    const { data, error } = await supabase
      .from('exercise_logs')
      .select('*')
      .limit(1);
    
    if (error) {
      console.error('Error querying Supabase:', error);
      return false;
    }
    
    console.log('Supabase query successful!');
    console.log('Data:', data);
    
    return true;
  } catch (error) {
    console.error('Unexpected error testing Supabase:', error);
    return false;
  }
}

// Run the test
testSupabase()
  .then(success => {
    if (success) {
      console.log('Supabase connectivity test completed successfully.');
      process.exit(0);
    } else {
      console.log('Supabase connectivity test failed.');
      process.exit(1);
    }
  })
  .catch(error => {
    console.error('Unexpected error:', error);
    process.exit(1);
  });
