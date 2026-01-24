-- Game Logic Package
-- Contains all game-specific functionality: spinning reels, evaluating wins, displaying slot machine

CREATE OR REPLACE PACKAGE game_pkg IS
  -- Statistics record type (must be declared before use)
  TYPE game_stats_rec IS RECORD (
    total_spins NUMBER,
    total_wins NUMBER,
    total_coins_won NUMBER,
    total_coins_bet NUMBER,
    biggest_win NUMBER
  );
  
  -- Game display procedures
  PROCEDURE print_slot_machine_gui(p_r1 VARCHAR2, p_r2 VARCHAR2, p_r3 VARCHAR2);
  
  -- Game mechanics functions
  FUNCTION get_random_symbol RETURN VARCHAR2;
  FUNCTION pad_symbol(sym VARCHAR2) RETURN VARCHAR2;
  FUNCTION evaluate_win(p_r1 VARCHAR2, p_r2 VARCHAR2, p_r3 VARCHAR2, p_bet NUMBER := 1) RETURN NUMBER;
  
  -- Game state management
  PROCEDURE spin_reels(p_bet NUMBER, p_balance IN OUT NUMBER, p_stats IN OUT game_stats_rec);
END game_pkg;
/

CREATE OR REPLACE PACKAGE BODY game_pkg IS

  PROCEDURE print_slot_machine_gui (
    p_r1 VARCHAR2,
    p_r2 VARCHAR2,
    p_r3 VARCHAR2
  ) IS   
  BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('  ╔════════════════════════════════════════╗');
    DBMS_OUTPUT.PUT_LINE('  ║          󱄔  SLOT MACHINE 󱄔             ║');
    DBMS_OUTPUT.PUT_LINE('  ╠════════════════════════════════════════╣');
    DBMS_OUTPUT.PUT_LINE('  ║                                        ║');
    DBMS_OUTPUT.PUT_LINE('  ║      ┌───────┐ ┌───────┐ ┌───────┐     ║');
    DBMS_OUTPUT.PUT_LINE('  ║      │       │ │       │ │       │     ║');
    DBMS_OUTPUT.PUT_LINE('  ║      ' || '│' || pad_symbol(p_r1) || '│' || ' │' || pad_symbol(p_r2) || '│' || ' │' || pad_symbol(p_r3) || '│     ║');
    DBMS_OUTPUT.PUT_LINE('  ║      │       │ │       │ │       │     ║');
    DBMS_OUTPUT.PUT_LINE('  ║      └───────┘ └───────┘ └───────┘     ║');
    DBMS_OUTPUT.PUT_LINE('  ║                                        ║');
    DBMS_OUTPUT.PUT_LINE('  ╠════════════════════════════════════════╣');
    DBMS_OUTPUT.PUT_LINE('  ║   INSERT COIN AND PULL THE LEVER!      ║');
    DBMS_OUTPUT.PUT_LINE('  ╚════════════════════════════════════════╝');
    DBMS_OUTPUT.PUT_LINE('');
  END print_slot_machine_gui;

FUNCTION get_random_symbol RETURN VARCHAR2 IS
  v_num NUMBER;
BEGIN
  v_num := TRUNC(DBMS_RANDOM.VALUE(1,10));
  RETURN CASE v_num
    WHEN 1 THEN '🍒'
    WHEN 2 THEN '🍋'
    WHEN 3 THEN '🍌'
    WHEN 4 THEN '🍊'
    WHEN 5 THEN '🍇'
    WHEN 6 THEN '🍉'
    WHEN 7 THEN '🍀'
    WHEN 8 THEN '⛔'
    ELSE '💎'
  END;
END get_random_symbol;

-- Helper to add extra space for emojis
FUNCTION pad_symbol(sym VARCHAR2) RETURN VARCHAR2 IS
BEGIN
  RETURN '   ' || sym || '  '; 
END pad_symbol;

-- Evaluate win combinations and return winnings based on symbol values
FUNCTION evaluate_win(p_r1 VARCHAR2, p_r2 VARCHAR2, p_r3 VARCHAR2, p_bet NUMBER := 1) RETURN NUMBER IS
  v_value1 NUMBER := 0;
  v_value2 NUMBER := 0;
  v_value3 NUMBER := 0;
  v_winnings NUMBER := 0;
BEGIN
  -- Get base values for each symbol from the symbols table
  BEGIN
    SELECT base_value INTO v_value1 FROM symbols WHERE symbol_char = p_r1;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN v_value1 := 5; -- default value
  END;
  
  BEGIN
    SELECT base_value INTO v_value2 FROM symbols WHERE symbol_char = p_r2;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN v_value2 := 5;
  END;
  
  BEGIN
    SELECT base_value INTO v_value3 FROM symbols WHERE symbol_char = p_r3;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN v_value3 := 5;
  END;
  
  -- All three symbols match (TRIPLE)
  IF p_r1 = p_r2 AND p_r2 = p_r3 THEN
    -- Special case: Three stop signs = lose everything
    IF p_r1 = '⛔' THEN
      RETURN 0;
    END IF;
    
    -- Calculate winnings: bet * symbol_value
    v_winnings := p_bet * v_value1;
    RETURN v_winnings;
  
  -- Two symbols match (DOUBLE)
  ELSIF p_r1 = p_r2 OR p_r2 = p_r3 OR p_r1 = p_r3 THEN
    -- Find which symbol appears twice and use its value
    IF p_r1 = p_r2 THEN
      v_winnings := p_bet * (v_value1 / 5);  -- Reduced payout for doubles
    ELSIF p_r2 = p_r3 THEN
      v_winnings := p_bet * (v_value2 / 5);
    ELSE -- p_r1 = p_r3
      v_winnings := p_bet * (v_value1 / 5);
    END IF;
    
    -- Minimum payout of 2x bet for any double
    IF v_winnings < (p_bet * 2) THEN
      v_winnings := p_bet * 2;
    END IF;
    
    RETURN TRUNC(v_winnings);
  
  -- No match
  ELSE
    RETURN 0;
  END IF;
END evaluate_win;

PROCEDURE spin_reels(p_bet NUMBER, p_balance IN OUT NUMBER, p_stats IN OUT game_stats_rec) IS
  r1 VARCHAR2(10);
  r2 VARCHAR2(10);
  r3 VARCHAR2(10);
  v_winnings NUMBER;
BEGIN
  -- Deduct bet from balance
  p_balance := p_balance - p_bet;
  p_stats.total_coins_bet := p_stats.total_coins_bet + p_bet;
  p_stats.total_spins := p_stats.total_spins + 1;
  
  -- Get random symbols
  r1 := get_random_symbol;
  r2 := get_random_symbol;
  r3 := get_random_symbol;
  
  -- Display slot machine
  print_slot_machine_gui(r1, r2, r3);

  -- Evaluate winnings
  v_winnings := evaluate_win(r1, r2, r3, p_bet);
  
  DBMS_OUTPUT.PUT_LINE('  ▶ ACTION: PLAY');
  DBMS_OUTPUT.PUT_LINE('  ▶ BET: ' || p_bet || ' coins');
  
  IF v_winnings > 0 THEN
    p_balance := p_balance + v_winnings;
    p_stats.total_coins_won := p_stats.total_coins_won + v_winnings;
    p_stats.total_wins := p_stats.total_wins + 1;
    
    IF v_winnings > p_stats.biggest_win THEN
      p_stats.biggest_win := v_winnings;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('  ▶ RESULT: 🎉 YOU WIN! +' || v_winnings || ' coins');
    DBMS_OUTPUT.PUT_LINE('  ▶ NEW BALANCE: ' || p_balance || ' coins');
  ELSE
    DBMS_OUTPUT.PUT_LINE('  ▶ RESULT: 💔 No win this time');
    DBMS_OUTPUT.PUT_LINE('  ▶ NEW BALANCE: ' || p_balance || ' coins');
  END IF;
END spin_reels;

END game_pkg;
/
