-- Buffer Table
CREATE TABLE IF NOT EXISTS buffer_table
(
    id UInt64,
    name String,
    timestamp DateTime
) ENGINE = Buffer('default', 'main_table', 16, 10, 20, 25, 30, 40, 200);



-- Main Table
CREATE TABLE IF NOT EXISTS main_table
(
    id UInt64,
    name String,
    timestamp DateTime
) ENGINE = MergeTree()
ORDER BY (id);



-- Materialized View
CREATE MATERIALIZED VIEW IF NOT EXISTS materialized_view
ENGINE = MergeTree()
ORDER BY (id)
AS SELECT 
    id, 
    name, 
    toStartOfDay(timestamp) AS day
FROM main_table;



--Another Table
CREATE TABLE IF NOT EXISTS local_table
(
    id UInt64,
    name String,
    day Date
) ENGINE = MergeTree()
ORDER BY (id);



-- Distributed Table
CREATE TABLE IF NOT EXISTS local_table_distributed
(
    id UInt64,
    name String,
    day Date
) ENGINE = Distributed('clickhouse_cluster', 'default', 'local_table', rand());



-- Inserting dummy data into buffer table

INSERT INTO buffer_table (id, name, timestamp) VALUES (1, 'Joy_DADA', now());
INSERT INTO buffer_table (id, name, timestamp) VALUES (2, 'Ishmam_Bhai', now());
INSERT INTO buffer_table (id, name, timestamp) VALUES (3, 'Anik_Bhai', now());
INSERT INTO buffer_table (id, name, timestamp) VALUES (4, 'Nuri_APu',now());