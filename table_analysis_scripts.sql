-- Tables without relationships
SELECT t.name AS table_name
FROM sys.tables t
WHERE NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys fk
    WHERE fk.parent_object_id = t.object_id
);

-- Check contraints that has a specific table
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

-- Script to find records without data

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

-- Row counts
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
