-- partial credits to Bill Karwin and jknotek on stack overflow

start transaction;
-- this procedure needs to be run somewhere, so just select a database
USE `from_this`;

DELIMITER $$

DROP PROCEDURE IF EXISTS `exec`$$
DROP PROCEDURE IF EXISTS `copy_schema`$$

-- simple procedure to allow statement strings to be built and executed easily
-- using `concat`
CREATE PROCEDURE exec(stmt_text TEXT)
BEGIN
  SET @sql_text = stmt_text;
  PREPARE stmt FROM @sql_text;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;
END $$

-- Copies the database `from_db` into a new database, `to_db`.
-- Be careful: This procedure DROPs `to_db` before copying data
CREATE PROCEDURE copy_schema(from_db VARCHAR(64), to_db VARCHAR(64))
BEGIN
  -- declare variables to be used throughout the procedure
  DECLARE curr_table_name VARCHAR(64) DEFAULT NULL;
  DECLARE done TINYINT DEFAULT FALSE;
  -- This is a cursor that will point to every row in
  -- INFORMATION_SCHEMA.TABLES
  -- Each row corresponds to a table in `from_db`, so this will effectively
  -- give us a foreach loop through the table names
  DECLARE table_cursor
    CURSOR FOR
    SELECT TABLE_NAME
      FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = from_db
        AND NOT TABLE_TYPE = 'VIEW';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  -- initialize `to_db` before attempting to copy data into it
  CALL exec(concat('DROP DATABASE IF EXISTS ', to_db));
  CALL exec(concat('CREATE DATABASE ', to_db));

  OPEN table_cursor;

  -- Loop through all table names
  table_loop:
  LOOP
    FETCH NEXT FROM table_cursor INTO curr_table_name;
    -- Break if no more results
    IF done THEN
      LEAVE table_loop;
    ELSE
      -- Call `CREATE TABLE` for each table, copying the schema from `from_db`
      CALL exec(concat('CREATE TABLE ', to_db, '.', curr_table_name, ' LIKE ', from_db, '.', curr_table_name));
      CALL exec(concat('INSERT INTO ', to_db, '.', curr_table_name, ' SELECT * FROM ', from_db, '.', curr_table_name));
    END IF;
  END LOOP;
  

  CLOSE table_cursor;
END $$

DELIMITER ;


CALL copy_schema('from_this', 'to_that');
-- at this point you can choose to commit or rollback, i would not keep the line written in order to not automatically do either
