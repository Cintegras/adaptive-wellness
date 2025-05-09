-- Create the exec_sql stored procedure for executing SQL statements
-- This procedure is required for the execute-sql-remote.js script to work

CREATE OR REPLACE PROCEDURE exec_sql(sql_text TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
  EXECUTE sql_text;
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON PROCEDURE exec_sql(TEXT) TO authenticated;
GRANT EXECUTE ON PROCEDURE exec_sql(TEXT) TO anon;
GRANT EXECUTE ON PROCEDURE exec_sql(TEXT) TO service_role;

-- Verify the procedure was created
DO $$
BEGIN
  RAISE NOTICE 'exec_sql procedure created successfully';
END $$;