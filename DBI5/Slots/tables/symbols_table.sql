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
