-- Create symbols table with values for win calculation
CREATE TABLE symbols (
    symbol_id NUMBER PRIMARY KEY,
    symbol_char VARCHAR2(10) NOT NULL UNIQUE,
    symbol_name VARCHAR2(50) NOT NULL,
    base_value NUMBER NOT NULL,
    rarity VARCHAR2(20),
    CONSTRAINT symbols_value_check CHECK (base_value >= 0)
);

-- Create win combinations table
CREATE TABLE win_combinations (
    combo_id NUMBER PRIMARY KEY,
    combo_type VARCHAR2(20) NOT NULL,
    multiplier NUMBER NOT NULL,
    description VARCHAR2(100)
);

COMMIT;

-- Insert symbol data with different base values
-- Higher value = more valuable symbol

-- Jackpot symbols (extremely rare and valuable)
INSERT INTO symbols VALUES (1, '💎', 'Diamond', 100, 'LEGENDARY');

-- Premium symbols (very valuable)
INSERT INTO symbols VALUES (2, '🍀', 'Clover', 50, 'EPIC');

-- High-value symbols (valuable)
INSERT INTO symbols VALUES (3, '🍉', 'Watermelon', 20, 'RARE');
INSERT INTO symbols VALUES (4, '🍇', 'Grapes', 15, 'RARE');

-- Medium-value symbols
INSERT INTO symbols VALUES (5, '🍊', 'Orange', 10, 'UNCOMMON');
INSERT INTO symbols VALUES (6, '🍌', 'Banana', 8, 'UNCOMMON');

-- Low-value symbols (common)
INSERT INTO symbols VALUES (7, '🍋', 'Lemon', 5, 'COMMON');
INSERT INTO symbols VALUES (8, '🍒', 'Cherry', 3, 'COMMON');

-- Special symbols
INSERT INTO symbols VALUES (9, '⛔', 'Stop', 0, 'SPECIAL');

-- Insert win combination types
INSERT INTO win_combinations VALUES (1, 'TRIPLE', 10, 'All three symbols match');
INSERT INTO win_combinations VALUES (2, 'DOUBLE', 2, 'Two symbols match');
INSERT INTO win_combinations VALUES (3, 'NONE', 0, 'No symbols match');

COMMIT;
