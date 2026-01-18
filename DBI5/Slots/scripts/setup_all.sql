-- Complete setup script for Slot Machine game
-- Run this script to set up all tables, data, and packages

PROMPT
PROMPT ═══════════════════════════════════════════════════════
PROMPT   SLOT MACHINE GAME - INSTALLATION SCRIPT
PROMPT ═══════════════════════════════════════════════════════
PROMPT

-- Step 1: Create tables
PROMPT [1/5] Creating database tables...
@@../tables/symbols_table.sql
@@../data/slot_data.sql

PROMPT ✓ Tables created successfully
PROMPT

-- Step 2: Insert data
PROMPT [2/5] Inserting symbol and payout data...
@@../data/symbols_data.sql

PROMPT ✓ Data inserted successfully
PROMPT

-- Step 3: Create packages
PROMPT [3/5] Creating game packages...
PROMPT   → Creating game_pkg (game logic)...
@@../logic/game_logic.sql
PROMPT   → Creating menu_pkg (menu logic)...
@@../logic/menu_logic.sql
PROMPT   → Creating slot_pkg (main coordinator)...
@@../logic/slot_logic.sql

PROMPT ✓ All packages created successfully
PROMPT

-- Step 4: Verify installation
PROMPT [4/5] Verifying installation...

SELECT COUNT(*) AS "Symbols Count" FROM symbols;
SELECT COUNT(*) AS "Win Combinations Count" FROM win_combinations;

PROMPT

-- Step 5: Show payout table
PROMPT [5/5] Displaying payout table...
PROMPT
BEGIN
    slot_pkg.show_payouts;
END;
/

PROMPT
PROMPT ═══════════════════════════════════════════════════════
PROMPT   INSTALLATION COMPLETE! 🎉
PROMPT ═══════════════════════════════════════════════════════
PROMPT
PROMPT   To play the game, run: @../cli/slot_gui.sql
PROMPT   To test all features, run: @test_menu.sql
PROMPT
PROMPT ═══════════════════════════════════════════════════════
