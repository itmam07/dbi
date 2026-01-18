-- 03_main_menu.sql
-- Interactive Slot Machine Game Menu
SET SERVEROUTPUT ON SIZE UNLIMITED
SET FEEDBACK OFF
SET VERIFY OFF

PROMPT  ╔════════════════════════════════════════════════════╗
PROMPT  ║                                                    ║
PROMPT  ║         🎰  WELCOME TO SLOT MACHINE!  🎰           ║
PROMPT  ║                                                    ║
PROMPT  ╚════════════════════════════════════════════════════╝

-- Display menu
EXEC slot_pkg.print_menu_gui;

PROMPT
-- Accept user input
ACCEPT p_choice PROMPT 'Select option (0-6): '

BEGIN
  slot_pkg.handle_menu_choice('&p_choice');
END;
/

UNDEFINE p_choice
