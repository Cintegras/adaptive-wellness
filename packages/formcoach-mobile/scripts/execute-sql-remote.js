import { createClient } from '@supabase/supabase-js';
import * as fs from 'fs';
import * as path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

// Set up __dirname equivalent for ES modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Get Supabase URL and key from environment variables
const SUPABASE_URL = process.env.VITE_SUPABASE_URL || process.env.VITE_SUPABASE_URL_DEV || 'https://gfaqeouktaxibmyzfnwr.supabase.co';
const SUPABASE_KEY = process.env.VITE_SUPABASE_ANON_KEY || process.env.VITE_SUPABASE_KEY_DEV || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdmYXFlb3VrdGF4aWJteXpmbndyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDYyMzAxMDIsImV4cCI6MjA2MTgwNjEwMn0.EmzRZtlWoZBpcYflghiULEQbDI_pQtGCUG1J9KuH3rw';

// Create Supabase client
const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

// Check if a specific SQL file was provided as a command-line argument
const specificSqlFile = process.argv[2];

// Path to SQL files
let sqlFiles = [];

if (specificSqlFile) {
    // If a specific file was provided, use that
    const filePath = path.resolve(process.cwd(), specificSqlFile);
    if (fs.existsSync(filePath)) {
        sqlFiles = [filePath];
    } else {
        console.error(`❌ SQL file not found: ${specificSqlFile}`);
        process.exit(1);
    }
} else {
    // Otherwise, use all SQL files in the default directory
    const sqlDir = path.join(__dirname, '..', 'docs', 'supabase', 'sql');
    sqlFiles = fs.readdirSync(sqlDir)
        .filter(file => file.endsWith('.sql'))
        .sort() // Sort to ensure they're executed in order
        .map(file => path.join(sqlDir, file));
}

console.log('Starting SQL execution using Supabase client...');
console.log(`Using Supabase URL: ${SUPABASE_URL}`);

// Check if exec_sql procedure exists, create if it doesn't
async function ensureExecSqlProcedure() {
    console.log('Checking for exec_sql stored procedure...');

    try {
        // Try to call the procedure with a simple query to check if it exists
        const { data, error } = await supabase.rpc('exec_sql', { sql_text: 'SELECT 1' });

        if (error && error.message.includes('function exec_sql does not exist')) {
            console.log('❌ exec_sql procedure does not exist');
            console.log('Please run the following SQL in the Supabase SQL Editor:');
            console.log(`
CREATE OR REPLACE PROCEDURE exec_sql(sql_text TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
  EXECUTE sql_text;
END;
$$;
            `);

            // Ask user if they've created the procedure
            console.log('\nHave you created the exec_sql procedure? (y/n)');
            // Since we can't do interactive prompts in this script, we'll just exit
            console.log('Exiting. Please run this script again after creating the procedure.');
            process.exit(1);
        } else {
            console.log('✅ exec_sql procedure exists');
        }
    } catch (error) {
        console.error('❌ Error checking exec_sql procedure:', error.message);
        console.log('Please run the following SQL in the Supabase SQL Editor:');
        console.log(`
CREATE OR REPLACE PROCEDURE exec_sql(sql_text TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
  EXECUTE sql_text;
END;
$$;
        `);
        process.exit(1);
    }
}

// Execute each SQL file
async function executeSQL() {
    // Ensure exec_sql procedure exists
    await ensureExecSqlProcedure();

    for (const file of sqlFiles) {
        const filePath = path.join(sqlDir, file);
        console.log(`Executing ${file}...`);

        try {
            // Read the SQL file
            const sql = fs.readFileSync(filePath, 'utf8');

            // Execute the SQL using Supabase client
            const { data, error } = await supabase.rpc('exec_sql', { sql_text: sql });

            if (error) {
                console.error(`❌ Error executing ${file}:`, error.message);
            } else {
                console.log(`✅ Successfully executed ${file}`);
            }
        } catch (error) {
            console.error(`❌ Error executing ${file}:`, error.message);
        }
    }

    console.log('SQL execution completed.');
}

executeSQL();
