# Kill all PG connections
alias kill_all_pg_con='psql -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'flatlooker_dev' AND pid <> pg_backend_pid();"'

