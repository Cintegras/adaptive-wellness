#!/bin/bash

# FormCoach Mobile - Expo 51 Fix Implementation Script
# This script implements the fixed Expo 51 configuration for the FormCoach mobile app.

# Ensure we're in the formcoach-mobile directory
cd "$(dirname "$0")"

# Create backup directory
BACKUP_DIR="backup-$(date +%Y%m%d%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "Creating backups in $BACKUP_DIR..."
# Backup current files
cp package.json "$BACKUP_DIR/"
cp metro.config.js "$BACKUP_DIR/"
cp start.sh "$BACKUP_DIR/"

echo "Implementing fixed Expo 51 configuration..."
# Replace package.json with the fixed Expo 51 version
cp package.json.expo51.fixed package.json

# Replace metro.config.js with the fixed version
cp metro.config.js.fixed metro.config.js

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

echo "Installing dependencies..."
# Remove node_modules and package-lock.json to ensure a clean install
rm -rf node_modules package-lock.json
npm install --legacy-peer-deps

echo "Implementation complete!"
echo ""
echo "Next steps:"
echo "1. Test the solution by running: ./start.sh"
echo "2. Test Supabase connectivity by running: node -r dotenv/config test-supabase.js"
echo "3. Run the Jest tests to ensure everything works: npm test"
echo ""
echo "If you encounter any issues, you can restore the original files from the $BACKUP_DIR directory."
echo "For more information, see the docs/METRO_DIAGNOSTICS.md file."
