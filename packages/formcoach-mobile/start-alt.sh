#!/bin/bash

# Ensure we're in the formcoach-mobile directory
cd "$(dirname "$0")"

# Install expo-cli globally if not already installed
if ! command -v expo-cli &> /dev/null; then
    echo "Installing expo-cli globally..."
    npm install -g expo-cli
fi

# Run expo-cli start with the current directory as the project root
echo "Starting Expo project with expo-cli..."
expo-cli start