-- View to display symbol win information
CREATE OR REPLACE VIEW v_symbol_payouts AS
SELECT 
    s.symbol_char AS "Symbol",
    s.symbol_name AS "Name",
    s.rarity AS "Rarity",
    s.base_value AS "Triple Value",
    TRUNC(s.base_value / 5) AS "Double Value",
    '(x' || s.base_value || ' bet)' AS "Triple Payout",
    '(x' || TRUNC(s.base_value / 5) || ' bet)' AS "Double Payout"
FROM symbols s
ORDER BY s.base_value DESC;

-- Script to display the payout table
SET LINESIZE 120
SET PAGESIZE 50
COLUMN "Symbol" FORMAT A10
COLUMN "Name" FORMAT A12
COLUMN "Rarity" FORMAT A12
COLUMN "Triple Value" FORMAT 999
COLUMN "Double Value" FORMAT 999
COLUMN "Triple Payout" FORMAT A15
COLUMN "Double Payout" FORMAT A15

SELECT * FROM v_symbol_payouts;

PROMPT
PROMPT ═══════════════════════════════════════════════════════
PROMPT   HOW TO WIN
PROMPT ═══════════════════════════════════════════════════════
PROMPT   • TRIPLE MATCH: Get 3 matching symbols for big wins!
PROMPT   • DOUBLE MATCH: Get 2 matching symbols for smaller wins
PROMPT   • Each symbol has a different value based on rarity
PROMPT   • Higher rarity = Higher payout!
PROMPT ═══════════════════════════════════════════════════════
PROMPT
