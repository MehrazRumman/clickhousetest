-- Buffer Table
CREATE TABLE IF NOT EXISTS buffer_table1
(
    id UInt64,
    name String,
    timestamp DateTime
) ENGINE = Buffer('default', 'main_table1', 16, 10, 20, 25, 30, 40, 200);



-- Main Table
CREATE TABLE IF NOT EXISTS main_table1
(
    id UInt64,
    name String,
    timestamp DateTime
) ENGINE = MergeTree()
ORDER BY (id);



-- Materialized View
CREATE MATERIALIZED VIEW IF NOT EXISTS materialized_view1
TO local_table1
AS SELECT 
    id, 
    name, 
    toStartOfDay(timestamp) AS day
FROM main_table1;



CREATE TABLE IF NOT EXISTS local_table1

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
) ENGINE = Distributed('clickhouse_cluster', 'default', 'local_table1', rand());



-- Inserting dummy data into buffer table

INSERT INTO buffer_table1 (id, name, timestamp) VALUES (1, 'a', now());
INSERT INTO buffer_table1 (id, name, timestamp) VALUES (2, 'b', now());
INSERT INTO buffer_table1 (id, name, timestamp) VALUES (3, 'c', now());
INSERT INTO buffer_table1 (id, name, timestamp) VALUES (4, 'd',now());