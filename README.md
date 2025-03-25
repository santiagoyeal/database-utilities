
# Database Utilities

A collection of SQL scripts for managing and analyzing SQL Server databases. These scripts are designed to help with routine database maintenance, performance monitoring, and table analysis.

## 📜 **Scripts Included**

### 1. **`database_maintenance.sql`**

This script contains various maintenance and monitoring commands for SQL Server databases. It includes:

- **Check Database Status**: Verifies if the database is online, offline, or in recovery.
- **Recover Database from RESTORING State**: Recovers a database that is in the "RESTORING" state.
- **Check Available Database Space**: Displays the total space used and available space for the database.
- **Monitor Active Sessions and Locks**: Identifies and displays sessions causing blocking in the database.
- **Backup Database**: Performs a full backup of the specified database.
- **Restore Database from Backup**: Restores a database from the latest backup file.
- **List Users and Roles**: Lists all users and their associated roles within the database.
- **Identify Slow or High-Resource Queries**: Retrieves queries that are consuming excessive resources and time.
- **Terminate Inactive Sessions**: Terminates sleeping or inactive sessions to free up resources.

### 2. **`table_analysis.sql`**

This script helps with analyzing the structure and relationships of tables in a SQL Server database. It includes:

- **Retrieve Tables without Foreign Keys**: Lists all tables that do not have foreign key relationships.
- **Retrieve Foreign Key Constraints that Reference a Specific Table**: Retrieves foreign keys that reference the table `'CAT_RAP'`.
- **Identify Empty Tables**: Retrieves tables that do not contain any records.
- **Retrieve Row Counts per Table**: Lists the number of rows in each table, sorted in descending order.
- **List Foreign Keys with Origin and Destination Tables/Columns**: Lists all foreign keys along with the involved parent and referenced tables and columns.
- **Retrieve Tables Without a Primary Key**: Identifies tables that do not have a primary key defined.

---

## 🔧 **How to Use**

### Prerequisites

- **SQL Server**: Any version that supports the commands used in the scripts.
- **Access**: You need sufficient privileges (e.g., `sysadmin`, `db_owner`) on the SQL Server instance to run these queries.

### Running the Scripts

1. **Open SQL Server Management Studio (SSMS)** or any SQL query tool of your choice.
2. **Connect** to the appropriate SQL Server instance.
3. **Open** the desired SQL script (`database_maintenance.sql` or `table_analysis.sql`).
4. **Execute** the script or individual queries as needed.

### Notes

- **Backups**: Always ensure that you have current backups before performing any database recovery or restoration operations.
- **Testing**: Test these scripts in a development environment before running them in production to avoid accidental data loss.
- **Permissions**: Make sure you have the necessary permissions to run these scripts, especially for tasks like terminating sessions and restoring databases.

---

## ⚠️ **Important Considerations**

- Be cautious when terminating inactive sessions in production environments.
- The `Restore` and `Backup` operations can overwrite or replace data. Use with caution.
- The **empty tables** query can be helpful for cleaning up unused tables, but make sure not to delete important tables accidentally.

---

## 🤝 **Contributing**

Feel free to open issues or create pull requests if you have additional commands or improvements.

---

## 📄 **License**

This repository is licensed under the [MIT License](LICENSE).
