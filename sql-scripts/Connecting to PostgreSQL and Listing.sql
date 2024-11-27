-- Connecting to PostgreSQL and listing existing databases
docker exec -it myproject /bin/bash
psql -U postgres -h localhost -p 5432 -W

-- Checking existing databases and tables
\l
\d

-- Dropping the database if it is being accessed by another session
SELECT pid, usename, datname, application_name, client_addr, state
FROM pg_stat_activity
WHERE datname = 'itversity_retail_db';

-- Terminating the active session
SELECT pg_terminate_backend(pid) 
FROM pg_stat_activity 
WHERE datname = 'itversity_retail_db' AND pid <> pg_backend_pid();

-- Dropping and recreating the database
DROP DATABASE itversity_retail_db;
CREATE DATABASE itversity_retail_db;

-- Creating a new user and granting permissions
DROP ROLE IF EXISTS itversity_retail_user;
CREATE USER itversity_retail_user WITH ENCRYPTED PASSWORD 'retail_password';
GRANT ALL ON DATABASE itversity_retail_db TO itversity_retail_user;

-- Granting access to the public schema
\c itversity_retail_db postgres
GRANT ALL ON SCHEMA public TO itversity_retail_user;

-- Connecting as the new user and creating tables
\c itversity_retail_db itversity_retail_user
\i /data/retail_db/create_db_tables_pg.sql

-- Loading data into the tables
\i /data/retail_db/load_db_tables_pg.sql
