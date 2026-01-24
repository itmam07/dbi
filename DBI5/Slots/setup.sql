SET SERVEROUTPUT ON SIZE UNLIMITED
SET FEEDBACK ON
SET VERIFY OFF

-- Drop packages if they exist
DROP PACKAGE slot_pkg;
DROP PACKAGE menu_pkg;
DROP PACKAGE game_pkg;

-- Drop tables
DROP TABLE win_combinations CASCADE CONSTRAINTS;
DROP TABLE symbols CASCADE CONSTRAINTS;

-- Create tables
@@tables/symbols_table.sql

-- Create packages
@@logic/game_logic.sql
@@logic/menu_logic.sql
@@logic/slot_logic.sql

PROMPT ═══════════════════════════════════════════════════════
PROMPT   INSTALLATION COMPLETE! NOW RUN GAME.SQL
PROMPT ═══════════════════════════════════════════════════════
