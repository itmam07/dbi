-- Main Slot Machine Package
-- Coordinates game logic and menu logic packages
-- Dependencies: game_pkg (game_logic.sql), menu_pkg (menu_logic.sql)

CREATE OR REPLACE PACKAGE slot_pkg IS
  -- Main procedures (delegated to game_pkg and menu_pkg)
  PROCEDURE print_slot_machine_gui(p_r1 VARCHAR2, p_r2 VARCHAR2, p_r3 VARCHAR2);
  PROCEDURE print_menu_gui;
  PROCEDURE handle_menu_choice(p_choice VARCHAR2);
  PROCEDURE show_payouts;
  PROCEDURE show_rules;
  PROCEDURE change_bet(p_new_bet NUMBER);
  PROCEDURE show_statistics;
  PROCEDURE reset_game;
  PROCEDURE show_balance;

  -- Functions (delegated to game_pkg)
  FUNCTION get_random_symbol RETURN VARCHAR2;
  FUNCTION pad_symbol(sym VARCHAR2) RETURN VARCHAR2;
  FUNCTION evaluate_win(p_r1 VARCHAR2, p_r2 VARCHAR2, p_r3 VARCHAR2, p_bet NUMBER := 1) RETURN NUMBER;
  FUNCTION get_balance RETURN NUMBER;
  FUNCTION get_current_bet RETURN NUMBER;
END slot_pkg;
/

CREATE OR REPLACE PACKAGE BODY slot_pkg IS
  
  -- Package-level variables for game state
  g_balance NUMBER := 1000;          -- Starting balance
  g_current_bet NUMBER := 1;         -- Current bet amount
  g_total_spins NUMBER := 0;         -- Total spins counter
  g_total_wins NUMBER := 0;          -- Total wins counter
  g_total_coins_won NUMBER := 0;     -- Total coins won
  g_total_coins_bet NUMBER := 0;     -- Total coins bet
  g_biggest_win NUMBER := 0;         -- Biggest single win

  -- Statistics record for passing to sub-packages
  g_stats game_pkg.game_stats_rec;

  -- Initialize stats records
  PROCEDURE init_stats IS
  BEGIN
    g_stats.total_spins := g_total_spins;
    g_stats.total_wins := g_total_wins;
    g_stats.total_coins_won := g_total_coins_won;
    g_stats.total_coins_bet := g_total_coins_bet;
    g_stats.biggest_win := g_biggest_win;
  END init_stats;

  -- Sync stats back from records
  PROCEDURE sync_stats IS
  BEGIN
    g_total_spins := g_stats.total_spins;
    g_total_wins := g_stats.total_wins;
    g_total_coins_won := g_stats.total_coins_won;
    g_total_coins_bet := g_stats.total_coins_bet;
    g_biggest_win := g_stats.biggest_win;
  END sync_stats;

  -- Delegated procedures to game_pkg
  PROCEDURE print_slot_machine_gui(p_r1 VARCHAR2, p_r2 VARCHAR2, p_r3 VARCHAR2) IS
  BEGIN
    game_pkg.print_slot_machine_gui(p_r1, p_r2, p_r3);
  END print_slot_machine_gui;

  -- Delegated procedures to menu_pkg
  PROCEDURE print_menu_gui IS
  BEGIN
    menu_pkg.print_menu_gui;
  END print_menu_gui;

  PROCEDURE handle_menu_choice(p_choice VARCHAR2) IS
  BEGIN
    init_stats;
    menu_pkg.handle_menu_choice(p_choice, g_balance, g_current_bet, g_stats);
    sync_stats;
  END handle_menu_choice;

  PROCEDURE show_payouts IS
  BEGIN
    menu_pkg.show_payouts;
  END show_payouts;

  PROCEDURE show_rules IS
  BEGIN
    menu_pkg.show_rules;
  END show_rules;

  PROCEDURE show_balance IS
  BEGIN
    menu_pkg.show_balance(g_balance, g_current_bet, g_total_coins_won, g_total_coins_bet);
  END show_balance;

  PROCEDURE change_bet(p_new_bet NUMBER) IS
  BEGIN
    menu_pkg.change_bet(p_new_bet, g_balance, g_current_bet);
  END change_bet;

  PROCEDURE show_statistics IS
  BEGIN
    init_stats;
    menu_pkg.show_statistics(g_balance, g_current_bet, g_stats);
  END show_statistics;

  -- Delegated functions to game_pkg
  FUNCTION get_random_symbol RETURN VARCHAR2 IS
  BEGIN
    RETURN game_pkg.get_random_symbol;
  END get_random_symbol;

  FUNCTION pad_symbol(sym VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN game_pkg.pad_symbol(sym);
  END pad_symbol;

  FUNCTION evaluate_win(p_r1 VARCHAR2, p_r2 VARCHAR2, p_r3 VARCHAR2, p_bet NUMBER := 1) RETURN NUMBER IS
  BEGIN
    RETURN game_pkg.evaluate_win(p_r1, p_r2, p_r3, p_bet);
  END evaluate_win;
  
  -- Reset game to initial state
  PROCEDURE reset_game IS
  BEGIN
    g_balance := 1000;
    g_current_bet := 1;
    g_total_spins := 0;
    g_total_wins := 0;
    g_total_coins_won := 0;
    g_total_coins_bet := 0;
    g_biggest_win := 0;
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('  ╔════════════════════════════════════════════════════╗');
    DBMS_OUTPUT.PUT_LINE('  ║              🔄 GAME RESET 🔄                      ║');
    DBMS_OUTPUT.PUT_LINE('  ╠════════════════════════════════════════════════════╣');
    DBMS_OUTPUT.PUT_LINE('  ║                                                    ║');
    DBMS_OUTPUT.PUT_LINE('  ║  ✓ Balance reset to 1000 coins                     ║');
    DBMS_OUTPUT.PUT_LINE('  ║  ✓ Bet reset to 1 coin                             ║');
    DBMS_OUTPUT.PUT_LINE('  ║  ✓ All statistics cleared                          ║');
    DBMS_OUTPUT.PUT_LINE('  ║                                                    ║');
    DBMS_OUTPUT.PUT_LINE('  ║  Good luck! 🍀                                      ║');
    DBMS_OUTPUT.PUT_LINE('  ║                                                    ║');
    DBMS_OUTPUT.PUT_LINE('  ╚════════════════════════════════════════════════════╝');
    DBMS_OUTPUT.PUT_LINE('');
  END reset_game;
  
  -- Get current balance
  FUNCTION get_balance RETURN NUMBER IS
  BEGIN
    RETURN g_balance;
  END get_balance;
  
  -- Get current bet amount
  FUNCTION get_current_bet RETURN NUMBER IS
  BEGIN
    RETURN g_current_bet;
  END get_current_bet;

END slot_pkg;
/
