#!/bin/bash

echo "🔁 Starting FormCoach..."

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "❌ .env file not found. Please create one based on .env.example"
    exit 1
fi

# Prompt for Supabase mode
echo "🔄 Choose Supabase mode:"
echo "  1) Supabase Cloud (recommended)"
echo "  2) Local Supabase (requires Docker)"
read -r supabase_mode

if [ "$supabase_mode" = "2" ]; then
    # Check if Docker is running
    if ! docker info &> /dev/null; then
        echo "❌ Docker is not running. Please start Docker Desktop first."
        exit 1
    fi

    # Check if Supabase CLI is installed
    if ! command -v supabase &> /dev/null; then
        echo "❌ Supabase CLI is not installed. Installing now..."
        npm install -g supabase
    fi

    echo "▶ Starting local Supabase..."
    supabase start

    # Execute SQL scripts to set up the database
    echo "▶ Setting up the database..."
    node scripts/execute-sql.js

    echo "✅ Local Supabase is running!"
else
    echo "ℹ️ Using Supabase Cloud as configured in .env"

    # Verify Supabase Cloud connection
    echo "▶ Verifying Supabase Cloud connection..."
    cat > temp-verify-connection.mjs << 'EOF'
import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

// Load environment variables
dotenv.config();

const SUPABASE_URL = process.env.VITE_SUPABASE_URL || process.env.VITE_SUPABASE_URL_DEV;
const SUPABASE_KEY = process.env.VITE_SUPABASE_ANON_KEY || process.env.VITE_SUPABASE_KEY_DEV;

if (!SUPABASE_URL || !SUPABASE_KEY) {
    console.error('❌ Supabase URL or key not found in .env file');
    process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

async function testConnection() {
    try {
        const { data, error } = await supabase.from('profiles').select('*').limit(1);
        if (error) throw error;
        console.log('✅ Successfully connected to Supabase Cloud');
    } catch (error) {
        console.error('❌ Failed to connect to Supabase Cloud:', error.message);
        process.exit(1);
    }
}

testConnection();
EOF

    node temp-verify-connection.mjs
    rm temp-verify-connection.mjs

    # Ask if user wants to seed the database
    echo "🔄 Do you want to seed the database with sample data? (y/n)"
    read -r seed_database

    if [ "$seed_database" = "y" ] || [ "$seed_database" = "Y" ]; then
        echo "▶ Seeding the database..."
        node scripts/seed-dev.mjs
    fi
fi

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Start the Vite development server with increased memory limit
echo "▶ Starting Vite development server..."
NODE_OPTIONS=--max_old_space_size=4096 npm run dev

# Note: The script will hang here until the dev server is stopped with Ctrl+C
