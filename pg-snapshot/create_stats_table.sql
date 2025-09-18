create table pg_stat_activity_snap as 
SELECT now() ts, a.* FROM pg_stat_activity a WHERE state <> 'idle';

create table pg_stat_statements_snap
as SELECT now() ts, a.* FROM pg_stat_statements a WHERE calls > 0;

create index pg_stat_statements_snap_ts_idx on pg_stat_statements_snap(ts);
create index pg_stat_activity_snap_ts_idx on pg_stat_activity_snap(ts);
grant select on pg_stat_statements_snap to public;
grant select on pg_stat_activity_snap to public;
\q
