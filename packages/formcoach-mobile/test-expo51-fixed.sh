#!/bin/bash

# Ensure we're in the formcoach-mobile directory
cd "$(dirname "$0")"

# Create a backup of the current package.json
cp package.json package.json.backup

# Replace package.json with the fixed Expo 51 version
cp package.json.expo51.fixed package.json

# Create a backup of the current metro.config.js
cp metro.config.js metro.config.js.backup

# Replace metro.config.js with the fixed version
cp metro.config.js.fixed metro.config.js

# Create a backup of the current start.sh
cp start.sh start.sh.backup

# Create a modified start.sh that uses NODE_PATH to ensure we only use our node_modules
cat > start.sh << 'EOL'
#!/bin/bash

# Ensure we're in the formcoach-mobile directory
cd "$(dirname "$0")"

# Set NODE_PATH to only include our node_modules
export NODE_PATH="$(pwd)/node_modules"

# Run expo start with debugging
EXPO_DEBUG=true npx expo start
EOL

# Make start.sh executable
chmod +x start.sh

echo "Installing dependencies for fixed Expo 51..."
# Remove node_modules and package-lock.json to ensure a clean install
rm -rf node_modules package-lock.json
npm install --legacy-peer-deps

echo "Testing fixed Expo 51 startup..."
# Run expo start with debugging and capture the output
EXPO_DEBUG=true NODE_PATH="$(pwd)/node_modules" npx expo start --clear > metro_expo51_fixed.log 2>&1 || true

echo "Error logs saved to metro_expo51_fixed.log"

# Restore the original files
mv package.json.backup package.json
mv metro.config.js.backup metro.config.js
mv start.sh.backup start.sh

echo "Restoring original dependencies..."
# Reinstall the original dependencies
rm -rf node_modules package-lock.json
npm install

echo "Test completed. Check metro_expo51_fixed.log for error details."
