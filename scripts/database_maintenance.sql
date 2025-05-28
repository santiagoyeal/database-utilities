-- =============================================
-- DATABASE MAINTENANCE & MONITORING SCRIPT
-- =============================================
-- This script contains useful SQL commands for:
-- 1. Checking database status
-- 2. Recovering a database from RESTORING state
-- 3. Checking available database space
-- 4. Monitoring active sessions and locks
-- 5. Backing up the database
-- 6. Restoring the database from a backup
-- 7. Listing users and roles
-- 8. Identifying slow queries
-- 9. Terminating inactive sessions
-- =============================================

-- 1️⃣ Check Database Status
-- This query checks if the database "DB_NAME" is online.
SELECT name, state_desc 
FROM sys.databases 
WHERE name = 'DB_NAME';

-- If the state is "RESTORING", "OFFLINE", or "RECOVERY_PENDING", recovery is required.

-- 2️⃣ Recover Database from RESTORING State
-- If the database is in RESTORING mode, execute this command.
RESTORE DATABASE DB_NAME WITH RECOVERY;

-- 3️⃣ Check Available Database Space
-- Shows database size and available space.
EXEC sp_spaceused;

-- 4️⃣ Monitor Active Sessions and Locks
-- Displays sessions that are blocking other processes.
SELECT blocking_session_id, session_id, status, wait_type, wait_time, last_wait_type, cpu_time, reads, writes  
FROM sys.dm_exec_requests  
WHERE blocking_session_id <> 0;

-- 5️⃣ Backup the Database
-- Creates a full backup of the database.
BACKUP DATABASE DB_NAME  
TO DISK = 'C:\Backups\DB_NAME.bak'  
WITH FORMAT, INIT, COMPRESSION, STATS = 10;

-- 6️⃣ Restore Database from a Backup
-- Restores the database from the latest backup.
RESTORE DATABASE DB_NAME  
FROM DISK = 'C:\Backups\DB_NAME.bak'  
WITH REPLACE, RECOVERY, STATS = 10;

-- 7️⃣ List Users and Roles
-- Retrieves database users and their assigned roles.
SELECT sp.name AS UserName, sp.create_date, sp.modify_date,  
       sl.name AS LoginName, dp.name AS Role  
FROM sys.database_principals sp  
LEFT JOIN sys.server_principals sl ON sp.principal_id = sl.principal_id  
LEFT JOIN sys.database_role_members drm ON sp.principal_id = drm.member_principal_id  
LEFT JOIN sys.database_principals dp ON drm.role_principal_id = dp.principal_id  
WHERE sp.type IN ('S', 'U', 'G');

-- 8️⃣ Identify Slow or High-Resource Queries
-- Retrieves the most expensive queries based on execution time.
SELECT TOP 10  
    qs.total_elapsed_time / qs.execution_count AS AvgElapsedTime,  
    qs.total_worker_time / qs.execution_count AS AvgCPUTime,  
    qs.execution_count,  
    qs.total_elapsed_time,  
    qs.total_worker_time,  
    SUBSTRING(qt.text, qs.statement_start_offset / 2,  
        (CASE WHEN qs.statement_end_offset = -1  
              THEN LEN(CONVERT(nvarchar(MAX), qt.text)) * 2  
              ELSE qs.statement_end_offset  
         END - qs.statement_start_offset) / 2) AS SQLQuery  
FROM sys.dm_exec_query_stats qs  
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt  
ORDER BY AvgElapsedTime DESC;

-- 9️⃣ Terminate Inactive Sessions
-- Closes inactive or sleeping sessions.
DECLARE @SPID INT;  
SELECT @SPID = session_id FROM sys.dm_exec_sessions WHERE status = 'sleeping';  
IF @SPID IS NOT NULL  
    KILL @SPID;
