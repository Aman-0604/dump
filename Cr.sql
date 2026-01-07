DECLARE @table_name sysname;
DECLARE @sql nvarchar(max);
DECLARE @results TABLE (table_name sysname, row_count bigint);

DECLARE table_cursor CURSOR FOR
SELECT QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(name)
FROM sys.tables
WHERE is_ms_shipped = 0;

OPEN table_cursor;
FETCH NEXT FROM table_cursor INTO @table_name;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = N'INSERT INTO @results SELECT ''' + @table_name + ''', COUNT(*) FROM ' + @table_name;
    EXEC sp_executesql @sql;
    FETCH NEXT FROM table_cursor INTO @table_name;
END

CLOSE table_cursor;
DEALLOCATE table_cursor;

SELECT table_name, row_count FROM @results ORDER BY table_name;
