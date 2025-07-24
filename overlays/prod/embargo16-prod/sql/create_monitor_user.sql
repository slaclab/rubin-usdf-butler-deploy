\c lsstdb1
CREATE ROLE monitor_user
  LOGIN
  PASSWORD '9RNlmZMMubGUnUJZKgK0'
  NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT;

-- 2. Allow the user to connect to your DB
GRANT CONNECT ON DATABASE mydb TO monitor_user;

-- 3. Give visibility on statistics views
GRANT pg_read_all_stats TO monitor_user;      -- pg_stat_activity, pg_stat_database, etc.
GRANT pg_stat_statements TO monitor_user;     -- lets them use pg_stat_statements

-- (Make sure the extension exists)
\c lsstdb1
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

-- 4. Let the user create tables — choose one of the two options below:

-- Option A: give them their own schema
CREATE SCHEMA IF NOT EXISTS monitor AUTHORIZATION monitor_user;
-- monitor_user can now CREATE/ALTER/DROP objects in schema 'monitor'.

-- Option B: allow CREATE in public (or another shared schema)
GRANT USAGE ON SCHEMA public TO monitor_user;
GRANT CREATE ON SCHEMA public TO monitor_user;
