-- Buffer Table
CREATE TABLE IF NOT EXISTS buffer_table2
(
    id UInt64,
    name String,
    timestamp DateTime
) ENGINE = Buffer('default', 'main_table2', 16, 10, 20, 25, 30, 40, 200);



-- Main Table
CREATE TABLE IF NOT EXISTS main_table2
(
    id UInt64,
    name String,
    timestamp DateTime
) ENGINE = MergeTree()
ORDER BY (id);



-- Materialized View
CREATE MATERIALIZED VIEW IF NOT EXISTS materialized_view2
TO local_table2
AS SELECT 
    id, 
    name, 
    toStartOfDay(timestamp) AS day
FROM main_table2;



CREATE TABLE IF NOT EXISTS local_table2
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
) ENGINE = Distributed('clickhouse_cluster', 'default', 'local_table2', rand());



-- Inserting dummy data into buffer table

INSERT INTO buffer_table2 (id, name, timestamp) VALUES (1, 'e', now());
INSERT INTO buffer_table2 (id, name, timestamp) VALUES (2, 'f', now());
INSERT INTO buffer_table2 (id, name, timestamp) VALUES (3, 'g', now());
INSERT INTO buffer_table2 (id, name, timestamp) VALUES (4, 'h',now());