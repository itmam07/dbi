-- Complete cleanup script for Slot Machine game
-- Run this script to remove all tables, data, and packages
-- This allows you to run setup_all.sql again for a fresh installation

SET SERVEROUTPUT ON SIZE UNLIMITED
SET FEEDBACK ON
SET VERIFY OFF

PROMPT
PROMPT ═══════════════════════════════════════════════════════
PROMPT   SLOT MACHINE GAME - CLEANUP SCRIPT
PROMPT ═══════════════════════════════════════════════════════
PROMPT

-- Step 1: Drop packages (in reverse dependency order)
PROMPT [1/3] Dropping packages...
PROMPT   → Dropping slot_pkg (main coordinator)...
DROP PACKAGE slot_pkg;
PROMPT   → Dropping menu_pkg (menu logic)...
DROP PACKAGE menu_pkg;
PROMPT   → Dropping game_pkg (game logic)...
DROP PACKAGE game_pkg;

PROMPT ✓ All packages dropped successfully
PROMPT

-- Step 2: Drop tables (in reverse dependency order)
PROMPT [2/3] Dropping tables...
PROMPT   → Dropping win_combinations table...
DROP TABLE win_combinations CASCADE CONSTRAINTS;
PROMPT   → Dropping symbols table...
DROP TABLE symbols CASCADE CONSTRAINTS;

PROMPT ✓ All tables dropped successfully
PROMPT

-- Step 3: Verify cleanup
PROMPT [3/3] Verifying cleanup...

DECLARE
  v_pkg_count NUMBER;
  v_tbl_count NUMBER;
BEGIN
  -- Check for remaining packages
  SELECT COUNT(*) INTO v_pkg_count 
  FROM user_objects 
  WHERE object_type = 'PACKAGE' 
  AND object_name IN ('SLOT_PKG', 'MENU_PKG', 'GAME_PKG');
  
  -- Check for remaining tables
  SELECT COUNT(*) INTO v_tbl_count 
  FROM user_tables 
  WHERE table_name IN ('SYMBOLS', 'WIN_COMBINATIONS');
  
  DBMS_OUTPUT.PUT_LINE('  Remaining packages: ' || v_pkg_count);
  DBMS_OUTPUT.PUT_LINE('  Remaining tables: ' || v_tbl_count);
  
  IF v_pkg_count = 0 AND v_tbl_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('  ✓ Cleanup complete! All objects removed.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('  ⚠ Warning: Some objects may still exist.');
  END IF;
END;
/

PROMPT

PROMPT ═══════════════════════════════════════════════════════
PROMPT   CLEANUP COMPLETE! 🧹
PROMPT ═══════════════════════════════════════════════════════
PROMPT
PROMPT   You can now run: @@setup_all.sql
PROMPT   for a fresh installation
PROMPT
PROMPT ═══════════════════════════════════════════════════════
PROMPT
