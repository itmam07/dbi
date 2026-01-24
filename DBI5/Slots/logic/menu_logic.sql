-- Menu Logic Package
-- Contains all menu-related functionality: display, navigation, and information screens

CREATE OR REPLACE PACKAGE menu_pkg IS
  -- Menu display and handling
  PROCEDURE print_menu_gui;
  PROCEDURE handle_menu_choice(p_choice VARCHAR2, p_balance IN OUT NUMBER, p_current_bet IN OUT NUMBER, p_stats IN OUT game_pkg.game_stats_rec);
  
  -- Information display procedures
  PROCEDURE show_payouts;
  PROCEDURE show_rules;
  PROCEDURE show_balance(p_balance NUMBER, p_current_bet NUMBER, p_total_won NUMBER, p_total_bet NUMBER);
  PROCEDURE show_statistics(p_balance NUMBER, p_current_bet NUMBER, p_stats game_pkg.game_stats_rec);
  
  -- Game configuration
  PROCEDURE change_bet(p_new_bet NUMBER, p_balance NUMBER, p_current_bet IN OUT NUMBER);
END menu_pkg;
/

CREATE OR REPLACE PACKAGE BODY menu_pkg IS

  PROCEDURE print_menu_gui IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('                          ');
    DBMS_OUTPUT.PUT_LINE('  ╔═══════════════════════════════╗');
    DBMS_OUTPUT.PUT_LINE('  ║        🎰 MAIN MENU 🎰        ║');
    DBMS_OUTPUT.PUT_LINE('  ╠═══════════════════════════════╣');
    DBMS_OUTPUT.PUT_LINE('  ║ 1 │ Play Slot Machine         ║');
    DBMS_OUTPUT.PUT_LINE('  ║ 2 │ Show Balance              ║');
    DBMS_OUTPUT.PUT_LINE('  ║ 3 │ View Payout Table         ║');
    DBMS_OUTPUT.PUT_LINE('  ║ 4 │ Change Bet Amount         ║');
    DBMS_OUTPUT.PUT_LINE('  ║ 5 │ View Rules                ║');
    DBMS_OUTPUT.PUT_LINE('  ║ 6 │ Show Statistics           ║');
    DBMS_OUTPUT.PUT_LINE('  ╠───────────────────────────────╢');
    DBMS_OUTPUT.PUT_LINE('  ║ 0 │ Exit Game                 ║');
    DBMS_OUTPUT.PUT_LINE('  ╚═══════════════════════════════╝');
  END print_menu_gui;

  PROCEDURE handle_menu_choice(p_choice VARCHAR2, p_balance IN OUT NUMBER, p_current_bet IN OUT NUMBER, p_stats IN OUT game_pkg.game_stats_rec) IS
  BEGIN
    IF p_choice = '1' THEN
      -- Check if player has enough balance
      IF p_balance < p_current_bet THEN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('  ❌ INSUFFICIENT FUNDS!');
        DBMS_OUTPUT.PUT_LINE('  ----------------');
        DBMS_OUTPUT.PUT_LINE('  Your balance: ' || p_balance || ' coins');
        DBMS_OUTPUT.PUT_LINE('  Current bet: ' || p_current_bet || ' coins');
        DBMS_OUTPUT.PUT_LINE('  Please reduce your bet or reset the game.');
        RETURN;
      END IF;
      
      -- Call game logic to spin reels
      game_pkg.spin_reels(p_current_bet, p_balance, p_stats);
  
    ELSIF p_choice = '2' THEN
      show_balance(p_balance, p_current_bet, p_stats.total_coins_won, p_stats.total_coins_bet);
      
    ELSIF p_choice = '3' THEN
      show_payouts;
      
    ELSIF p_choice = '4' THEN
      DBMS_OUTPUT.PUT_LINE('');
      DBMS_OUTPUT.PUT_LINE('  🎲 CHANGE BET');
      DBMS_OUTPUT.PUT_LINE('  ================');
      DBMS_OUTPUT.PUT_LINE('  Current bet: ' || p_current_bet || ' coins');
      DBMS_OUTPUT.PUT_LINE('  Your balance: ' || p_balance || ' coins');
      DBMS_OUTPUT.PUT_LINE('  ');
      DBMS_OUTPUT.PUT_LINE('  Available bet amounts:');
      DBMS_OUTPUT.PUT_LINE('  • 1 coin (Low risk, low reward)');
      DBMS_OUTPUT.PUT_LINE('  • 5 coins (Medium risk, medium reward)');
      DBMS_OUTPUT.PUT_LINE('  • 10 coins (High risk, high reward)');
      DBMS_OUTPUT.PUT_LINE('  ');
      DBMS_OUTPUT.PUT_LINE('  Please enter your bet amount when prompted.');
      DBMS_OUTPUT.PUT_LINE('  (Then run: EXEC slot_pkg.change_bet(<amount>);)');
      DBMS_OUTPUT.PUT_LINE('  ');
      
    ELSIF p_choice = '5' THEN
      show_rules;
      
    ELSIF p_choice = '6' THEN
      show_statistics(p_balance, p_current_bet, p_stats);
  
    ELSIF p_choice = '0' THEN
      DBMS_OUTPUT.PUT_LINE('');
      DBMS_OUTPUT.PUT_LINE('  👋 Thanks for playing!');
      DBMS_OUTPUT.PUT_LINE('  Exiting game...');
  
    ELSE
      DBMS_OUTPUT.PUT_LINE('');
      DBMS_OUTPUT.PUT_LINE('  ❌ Invalid menu option');
      DBMS_OUTPUT.PUT_LINE('  Please choose 0-6');
    END IF;
  END handle_menu_choice;
  
  -- Show payout table with symbol values
  PROCEDURE show_payouts IS
    CURSOR c_symbols IS
      SELECT symbol_char, symbol_name, rarity, base_value
      FROM symbols
      ORDER BY base_value DESC;
  BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('  ╔════════════════════════════════════════════════════╗');
    DBMS_OUTPUT.PUT_LINE('  ║              💰 PAYOUT TABLE 💰                    ║');
    DBMS_OUTPUT.PUT_LINE('  ╠════════════════════════════════════════════════════╣');
    DBMS_OUTPUT.PUT_LINE('  ║ Symbol  │ Name       │ Rarity    │ Triple Payout  ║');
    DBMS_OUTPUT.PUT_LINE('  ╟─────────┼────────────┼───────────┼────────────────╢');
    
    FOR rec IN c_symbols LOOP
      DBMS_OUTPUT.PUT_LINE('  ║ ' || RPAD(rec.symbol_char, 7) || ' │ ' || 
                          RPAD(rec.symbol_name, 10) || ' │ ' || 
                          RPAD(rec.rarity, 9) || ' │ ' || 
                          LPAD(rec.base_value || 'x bet', 14) || ' ║');
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('  ╠════════════════════════════════════════════════════╣');
    DBMS_OUTPUT.PUT_LINE('  ║ 🎯 Double Match: 2x bet minimum                   ║');
    DBMS_OUTPUT.PUT_LINE('  ║ 🎰 Triple Match: Base value x your bet            ║');
    DBMS_OUTPUT.PUT_LINE('  ╚════════════════════════════════════════════════════╝');
    DBMS_OUTPUT.PUT_LINE('');
  END show_payouts;
  
  -- Show game rules and help
  PROCEDURE show_rules IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('  ╔════════════════════════════════════════════════════╗');
    DBMS_OUTPUT.PUT_LINE('  ║              📖 GAME RULES ' || CHR(38) || ' HELP 📖               ║');
    DBMS_OUTPUT.PUT_LINE('  ╠════════════════════════════════════════════════════╣');
    DBMS_OUTPUT.PUT_LINE('  ║                                                    ║');
    DBMS_OUTPUT.PUT_LINE('  ║  HOW TO PLAY:                                      ║');
    DBMS_OUTPUT.PUT_LINE('  ║  • Place your bet (default: 1 coin)                ║');
    DBMS_OUTPUT.PUT_LINE('  ║  • Spin the reels and match symbols!               ║');
    DBMS_OUTPUT.PUT_LINE('  ║  • Win coins based on what you match               ║');
    DBMS_OUTPUT.PUT_LINE('  ║                                                    ║');
    DBMS_OUTPUT.PUT_LINE('  ║  WINNING COMBINATIONS:                             ║');
    DBMS_OUTPUT.PUT_LINE('  ║  🎯 TRIPLE MATCH - All 3 symbols the same          ║');
    DBMS_OUTPUT.PUT_LINE('  ║     Payout = Bet × Symbol Value                    ║');
    DBMS_OUTPUT.PUT_LINE('  ║                                                    ║');
    DBMS_OUTPUT.PUT_LINE('  ║  🎲 DOUBLE MATCH - Any 2 symbols the same          ║');
    DBMS_OUTPUT.PUT_LINE('  ║     Payout = 2x bet (minimum)                      ║');
    DBMS_OUTPUT.PUT_LINE('  ║                                                    ║');
    DBMS_OUTPUT.PUT_LINE('  ║  SPECIAL SYMBOLS:                                  ║');
    DBMS_OUTPUT.PUT_LINE('  ║  💎 Diamond - LEGENDARY (100x bet on triple!)      ║');
    DBMS_OUTPUT.PUT_LINE('  ║  🍀 Clover - EPIC (50x bet on triple!)             ║');
    DBMS_OUTPUT.PUT_LINE('  ║  ⛔ Stop - Three stops = lose your bet             ║');
    DBMS_OUTPUT.PUT_LINE('  ║                                                    ║');
    DBMS_OUTPUT.PUT_LINE('  ║  TIP: Higher rarity symbols = bigger payouts!      ║');
    DBMS_OUTPUT.PUT_LINE('  ║                                                    ║');
    DBMS_OUTPUT.PUT_LINE('  ╚════════════════════════════════════════════════════╝');
    DBMS_OUTPUT.PUT_LINE('');
  END show_rules;
  
  -- Show balance with details
  PROCEDURE show_balance(p_balance NUMBER, p_current_bet NUMBER, p_total_won NUMBER, p_total_bet NUMBER) IS
    v_net_profit NUMBER;
  BEGIN
    v_net_profit := p_total_won - p_total_bet;
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('  ╔════════════════════════════════════════════════════╗');
    DBMS_OUTPUT.PUT_LINE('  ║              💰 CURRENT BALANCE 💰                 ║');
    DBMS_OUTPUT.PUT_LINE('  ╠════════════════════════════════════════════════════╣');
    DBMS_OUTPUT.PUT_LINE('  ║                                                    ║');
    DBMS_OUTPUT.PUT_LINE('  ║  Current Balance:      ' || LPAD(p_balance || ' coins', 25) || '   ║');
    DBMS_OUTPUT.PUT_LINE('  ║  Current Bet:          ' || LPAD(p_current_bet || ' coins', 25) || '   ║');
    DBMS_OUTPUT.PUT_LINE('  ║                                                    ║');
    DBMS_OUTPUT.PUT_LINE('  ╟────────────────────────────────────────────────────╢');
    DBMS_OUTPUT.PUT_LINE('  ║  Starting Balance:     ' || LPAD('1000 coins', 25) || '   ║');
    DBMS_OUTPUT.PUT_LINE('  ║  Total Won:            ' || LPAD(p_total_won || ' coins', 25) || '   ║');
    DBMS_OUTPUT.PUT_LINE('  ║  Total Bet:            ' || LPAD(p_total_bet || ' coins', 25) || '   ║');
    DBMS_OUTPUT.PUT_LINE('  ║  Net Profit/Loss:      ' || 
                          LPAD(
                            CASE 
                              WHEN v_net_profit >= 0 THEN '+' || v_net_profit 
                              ELSE TO_CHAR(v_net_profit) 
                            END || ' coins', 25) || '   ║');
    DBMS_OUTPUT.PUT_LINE('  ║                                                    ║');
    DBMS_OUTPUT.PUT_LINE('  ╚════════════════════════════════════════════════════╝');
    DBMS_OUTPUT.PUT_LINE('');
  END show_balance;
  
  -- Change bet amount with validation
  PROCEDURE change_bet(p_new_bet NUMBER, p_balance NUMBER, p_current_bet IN OUT NUMBER) IS
  BEGIN
    IF p_new_bet < 1 OR p_new_bet > 100 THEN
      DBMS_OUTPUT.PUT_LINE('');
      DBMS_OUTPUT.PUT_LINE('  ❌ Invalid bet amount!');
      DBMS_OUTPUT.PUT_LINE('  Bet must be between 1 and 100 coins');
      RETURN;
    END IF;
    
    IF p_new_bet > p_balance THEN
      DBMS_OUTPUT.PUT_LINE('');
      DBMS_OUTPUT.PUT_LINE('  ❌ Insufficient balance!');
      DBMS_OUTPUT.PUT_LINE('  Your balance: ' || p_balance || ' coins');
      DBMS_OUTPUT.PUT_LINE('  Requested bet: ' || p_new_bet || ' coins');
      RETURN;
    END IF;
    
    p_current_bet := p_new_bet;
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('  ✓ Bet successfully changed!');
    DBMS_OUTPUT.PUT_LINE('  New bet amount: ' || p_current_bet || ' coins');
    DBMS_OUTPUT.PUT_LINE('  Your balance: ' || p_balance || ' coins');
    DBMS_OUTPUT.PUT_LINE('');
  END change_bet;
  
  -- Show game statistics with calculations
  PROCEDURE show_statistics(p_balance NUMBER, p_current_bet NUMBER, p_stats game_pkg.game_stats_rec) IS
    v_win_rate NUMBER;
    v_net_profit NUMBER;
  BEGIN
    -- Calculate win rate
    IF p_stats.total_spins > 0 THEN
      v_win_rate := ROUND((p_stats.total_wins / p_stats.total_spins) * 100, 2);
    ELSE
      v_win_rate := 0;
    END IF;
    
    v_net_profit := p_stats.total_coins_won - p_stats.total_coins_bet;
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('  ╔════════════════════════════════════════════════════╗');
    DBMS_OUTPUT.PUT_LINE('  ║              📊 GAME STATISTICS 📊                 ║');
    DBMS_OUTPUT.PUT_LINE('  ╠════════════════════════════════════════════════════╣');
    DBMS_OUTPUT.PUT_LINE('  ║                                                    ║');
    DBMS_OUTPUT.PUT_LINE('  ║  Total Spins:          ' || LPAD(TO_CHAR(p_stats.total_spins), 25) || '   ║');
    DBMS_OUTPUT.PUT_LINE('  ║  Total Wins:           ' || LPAD(TO_CHAR(p_stats.total_wins), 25) || '   ║');
    DBMS_OUTPUT.PUT_LINE('  ║  Win Rate:             ' || LPAD(TO_CHAR(v_win_rate) || '%', 25) || '   ║');
    DBMS_OUTPUT.PUT_LINE('  ║                                                    ║');
    DBMS_OUTPUT.PUT_LINE('  ╟────────────────────────────────────────────────────╢');
    DBMS_OUTPUT.PUT_LINE('  ║  Total Coins Won:      ' || LPAD(TO_CHAR(p_stats.total_coins_won), 25) || '   ║');
    DBMS_OUTPUT.PUT_LINE('  ║  Total Coins Bet:      ' || LPAD(TO_CHAR(p_stats.total_coins_bet), 25) || '   ║');
    DBMS_OUTPUT.PUT_LINE('  ║  Net Profit/Loss:      ' || 
                          LPAD(
                            CASE 
                              WHEN v_net_profit >= 0 THEN '+' || v_net_profit 
                              ELSE TO_CHAR(v_net_profit) 
                            END, 25) || '   ║');
    DBMS_OUTPUT.PUT_LINE('  ║  Biggest Single Win:   ' || LPAD(TO_CHAR(p_stats.biggest_win), 25) || '   ║');
    DBMS_OUTPUT.PUT_LINE('  ║                                                    ║');
    DBMS_OUTPUT.PUT_LINE('  ╟────────────────────────────────────────────────────╢');
    DBMS_OUTPUT.PUT_LINE('  ║  Current Balance:      ' || LPAD(TO_CHAR(p_balance), 25) || '   ║');
    DBMS_OUTPUT.PUT_LINE('  ║  Current Bet:          ' || LPAD(TO_CHAR(p_current_bet), 25) || '   ║');
    DBMS_OUTPUT.PUT_LINE('  ║                                                    ║');
    DBMS_OUTPUT.PUT_LINE('  ╚════════════════════════════════════════════════════╝');
    DBMS_OUTPUT.PUT_LINE('');
  END show_statistics;

END menu_pkg;
/
