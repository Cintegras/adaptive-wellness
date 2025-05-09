#!/bin/bash

# Ensure we're in the formcoach-mobile directory
cd "$(dirname "$0")"

# Run expo start with a simple command
EXPO_DEBUG=true npx expo start
