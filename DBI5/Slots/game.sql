SET SERVEROUTPUT ON SIZE UNLIMITED
SET FEEDBACK OFF
SET VERIFY OFF

EXEC slot_pkg.print_menu_gui;

ACCEPT p_choice PROMPT 'Select option (0-6): '

BEGIN
  slot_pkg.handle_menu_choice('&p_choice');
END;
/

-- EXEC slot_pkg.change_bet(10);