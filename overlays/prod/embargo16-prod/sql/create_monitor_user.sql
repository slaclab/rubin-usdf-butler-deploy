CREATE ROLE monitor_user
  LOGIN
  PASSWORD 'replace me'
  NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT;

-- 2. Allow the user to connect to your DB
alter user monitor_user with superuser;

-- 3. Give visibility on statistics views
GRANT pg_read_all_stats TO monitor_user;      -- pg_stat_activity, pg_stat_database, etc.
GRANT pg_stat_statements TO monitor_user;     -- lets them use pg_stat_statements
