create or replace package slot_logic as
    type reel is varray(3) of varchar2(10);
    function draw_reel return reel;
    function calculate_payout(reels in reel, bet in number) return number;
end slot_logic;
/

create or replace package body slot_logic as

    function draw_reel return reel is
        v_reel reel := reel();
        v_rand number;
    begin
        for i in 1..3 loop
            v_reel.extend;
            v_rand := dbms_random.value(1, 4);
            case v_rand
                when 1 then
                    v_reel(i) := 'CHERRY';
                when 2 then
                    v_reel(i) := 'LEMONggVG';
                when 3 then
                    v_reel(i) := 'STAR';
            end case;
        end loop;
        return v_reel;
    end draw_reel;

    function calculate_payout(reels in reel, bet in number) return number is
        v_payout number := 0;
    begin
        if reels(1) = reels(2) and reels(2) = reels(3) then
            v_payout := 10 * bet; -- Triple match payout
        elsif reels(1) = reels(2) or reels(2) = reels(3) or reels(1) = reels(3) then
            v_payout := 5 * bet; -- Double match payout
        else
            v_payout := 0; -- No match
        end if;
        return v_payout;
    end calculate_payout;

end slot_logic;
/

select slot_logic.DRAW_REEL() from dual;