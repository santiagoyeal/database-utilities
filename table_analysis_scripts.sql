-- Retrieve all tables that do not have relationships (no foreign keys).
SELECT t.name AS table_name
FROM sys.tables t
WHERE NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys fk
    WHERE fk.parent_object_id = t.object_id
);

-- Retrieve all foreign key constraints that reference a specific table ('CAT_RAP').
SELECT 
    fk.name AS ForeignKeyName,
    OBJECT_NAME(fk.parent_object_id) AS TableName,
    COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS ColumnName
FROM 
    sys.foreign_keys AS fk
INNER JOIN 
    sys.foreign_key_columns AS fkc
    ON fk.object_id = fkc.constraint_object_id
WHERE 
    OBJECT_NAME(fk.referenced_object_id) = 'CAT_RAP';

-- Retrieve all tables that do not contain any records (empty tables).
SELECT 
    t.name AS TableName,
    SUM(p.rows) AS RowCounts
FROM 
    sys.tables t
INNER JOIN 
    sys.partitions p ON t.object_id = p.object_id
WHERE 
    p.index_id IN (0, 1) 
GROUP BY 
    t.name
HAVING 
    SUM(p.rows) = 0;

-- Retrieve the number of records per table, sorted in descending order.
SELECT 
    t.name AS TableName,
    SUM(p.rows) AS RowCounts
FROM 
    sys.tables t
JOIN 
    sys.partitions p ON t.object_id = p.object_id
WHERE 
    p.index_id IN (0, 1)
GROUP BY 
    t.name
ORDER BY 
    RowCounts DESC;

-- List all foreign keys along with their origin and destination tables, including the involved columns.
SELECT 
    fk.name AS ForeignKeyName,
    OBJECT_NAME(fk.parent_object_id) AS ParentTable,
    c1.name AS ParentColumn,
    OBJECT_NAME(fk.referenced_object_id) AS ReferencedTable,
    c2.name AS ReferencedColumn
FROM 
    sys.foreign_keys fk
JOIN 
    sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
JOIN 
    sys.columns c1 ON fkc.parent_object_id = c1.object_id AND fkc.parent_column_id = c1.column_id
JOIN 
    sys.columns c2 ON fkc.referenced_object_id = c2.object_id AND fkc.referenced_column_id = c2.column_id;

-- Retrieve tables that do not have a primary key defined
SELECT 
    t.name AS TableName
FROM 
    sys.tables t
LEFT JOIN 
    sys.indexes i ON t.object_id = i.object_id AND i.is_primary_key = 1
WHERE 
    i.object_id IS NULL;