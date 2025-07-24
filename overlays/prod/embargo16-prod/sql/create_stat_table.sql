\c postgres
create table pg_stat_activity_snap as
postgres-# SELECT
              now() ts
              ,pid
              ,usename
              ,datname
              ,xact_start
              ,query_start
              ,state
              ,wait_event_type
              ,wait_event
              ,query
     FROM pg_stat_activity
     WHERE state <> 'idle';

create table pg_stat_statements_snap
as SELECT
              now() ts
              ,queryid
              ,calls
              ,rows
              ,shared_blks_hit
              ,shared_blks_read
              ,shared_blks_dirtied
              ,shared_blks_written
              ,local_blks_hit
              ,local_blks_read
              ,local_blks_dirtied
              ,local_blks_written
              ,temp_blks_read
              ,temp_blks_written
              ,blk_read_time
              ,blk_write_time
              ,temp_blk_read_time
              ,temp_blk_write_time
              ,query
     FROM pg_stat_statements
     WHERE calls > 0;
