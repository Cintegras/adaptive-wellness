import React from 'react';
import { View, Text, Image, TouchableOpacity, StyleSheet, Platform } from 'react-native';

const WelcomeScreen = ({ navigation, isFirst1000, platform }) => {
  const subtext = isFirst1000
    ? `You’re one of the first 1,000 on ${platform}! 🎉 Enjoy FormCoach premium—AI-driven plans, form coaching, and integrations with Whoop, Apple Health, and more—free for one year. Basic tracking is always free!`
    : 'Your AI-driven coach for smarter, safer training. Basic tracking is free forever, and you get a 30-day trial of premium features like AI plans, form coaching, and integrations with Whoop, Apple Health, and more—let’s get started!';

  return (
    <View style={styles.container}>
      <Text style={styles.heading}>Welcome to FormCoach!</Text>
      <Image
        source={require('../../assets/kai-avatar.png')}
        style={styles.avatar}
      />
      <Text style={styles.subtext}>{subtext}</Text>
      <Text style={styles.note}>
        Use FormCoach 5 times to join the Founder’s Circle—get premium features free and early access to future tools by sharing your experience!
      </Text>
      <TouchableOpacity
        style={styles.button}
        onPress={() => navigation.navigate('MedicalDisclaimer')}
        accessible
        accessibilityLabel="Continue to Medical Disclaimer"
      >
        <Text style={styles.buttonText}>Continue</Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#020D0C',
    padding: 16,
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  heading: {
    fontFamily: 'Poppins-Bold',
    fontSize: 32,
    color: '#FFFFFF',
    textAlign: 'center',
    marginTop: 40,
  },
  avatar: {
    width: 150,
    height: 150,
    marginVertical: 20,
  },
  subtext: {
    fontFamily: 'Poppins-Regular',
    fontSize: 16,
    color: '#FFFFFF',
    textAlign: 'center',
    width: 300,
    marginBottom: 20,
  },
  note: {
    fontFamily: 'Poppins-Regular',
    fontSize: 14,
    color: '#9CA3AF',
    textAlign: 'center',
    width: 300,
    marginBottom: 40,
  },
  button: {
    backgroundColor: '#00C4B4',
    width: '100%',
    height: 50,
    borderRadius: 8,
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 20,
  },
  buttonText: {
    fontFamily: 'Poppins-SemiBold',
    fontSize: 16,
    color: '#000000',
  },
});

export default WelcomeScreen;