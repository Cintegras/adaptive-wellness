#!/bin/bash

# Ensure we're in the formcoach-mobile directory
cd "$(dirname "$0")"

# Create a backup of the current package.json
cp package.json package.json.backup

# Replace package.json with the Expo 53 version
cp package.json.expo53 package.json

# Create a backup of the current metro.config.js
cp metro.config.js metro.config.js.backup

# Create a simpler metro.config.js that uses @expo/metro-config
cat > metro.config.js << 'EOL'
// Learn more https://docs.expo.io/guides/customizing-metro
const { getDefaultConfig } = require('@expo/metro-config');
module.exports = getDefaultConfig(__dirname);
EOL

echo "Installing dependencies for Expo 53..."
# Remove node_modules and package-lock.json to ensure a clean install
rm -rf node_modules package-lock.json
npm install

echo "Testing Expo 53 startup..."
# Run expo start with debugging and capture the output
EXPO_DEBUG=true npx expo start --clear > metro_error.log 2>&1 || true

echo "Error logs saved to metro_error.log"

# Restore the original package.json and metro.config.js
mv package.json.backup package.json
mv metro.config.js.backup metro.config.js

echo "Restoring original dependencies..."
# Reinstall the original dependencies
rm -rf node_modules package-lock.json
npm install

echo "Test completed. Check metro_error.log for error details."