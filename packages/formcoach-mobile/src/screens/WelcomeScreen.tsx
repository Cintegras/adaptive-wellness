import React, { useEffect, useState } from 'react';
import { View, Text, StyleSheet, ActivityIndicator } from 'react-native';
import { supabase } from '@adaptive-wellness/shared';

export default function WelcomeScreen() {
  const [loading, setLoading] = useState(true);
  const [connected, setConnected] = useState(false);

  useEffect(() => {
    async function testSupabaseConnection() {
      try {
        // Simple query to test connection
        const { data, error } = await supabase
          .from('exercise_logs')
          .select('*')
          .limit(1);

        if (error) {
          console.error('Error connecting to Supabase:', error);
          setConnected(false);
        } else {
          console.log('Successfully connected to Supabase');
          setConnected(true);
        }
      } catch (error) {
        console.error('Unexpected error:', error);
        setConnected(false);
      } finally {
        setLoading(false);
      }
    }

    testSupabaseConnection();
  }, []);

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Welcome to FormCoach</Text>
      <Text style={styles.subtitle}>Your personal fitness companion</Text>
      
      {loading ? (
        <View style={styles.statusContainer}>
          <ActivityIndicator size="large" color="#0000ff" />
          <Text style={styles.statusText}>Testing Supabase connection...</Text>
        </View>
      ) : (
        <View style={styles.statusContainer}>
          <Text style={[styles.statusText, connected ? styles.connected : styles.disconnected]}>
            Supabase: {connected ? 'Connected' : 'Disconnected'}
          </Text>
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
    backgroundColor: '#f5f5f5',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 10,
    textAlign: 'center',
  },
  subtitle: {
    fontSize: 18,
    marginBottom: 30,
    textAlign: 'center',
    color: '#666',
  },
  statusContainer: {
    marginTop: 20,
    padding: 15,
    borderRadius: 10,
    backgroundColor: '#fff',
    width: '100%',
    alignItems: 'center',
  },
  statusText: {
    fontSize: 16,
    marginTop: 10,
  },
  connected: {
    color: 'green',
  },
  disconnected: {
    color: 'red',
  },
});