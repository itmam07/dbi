create or replace package slot_cli as
    procedure print_main_menu(player_name in varchar2, balance in number, last_result in varchar2);
    procedure main_menu;

    procedure register_player(p_name in varchar2);
    procedure change_bet(p_player_id in number, p_new_bet in number);
end slot_cli;

create or replace package body slot_cli as

    procedure print_main_menu (
        player_name in varchar2, 
        balance in number, 
        last_result in varchar2,
        reel in slot_logic.reel
    ) is
    begin
        dbms_output.put_line('====================================');
        dbms_output.put_line('PL/SQL SLOT MACHINE');
        dbms_output.put_line('====================================');

        dbms_output.put_line('');
        dbms_output.put_line('Player: ' || nvl(player_name, 'Anonymous'));
        dbms_output.put_line('Balance: ' || balance || ' Coins');
        dbms_output.put_line('');

        dbms_output.put_line('------------------------------------');
        dbms_output.put_line('  |  ' || reel(1) || '  |  ' || reel(2) || '  |  ' || reel(3) || '  |');
        dbms_output.put_line('------------------------------------');

        dbms_output.put_line('');
        dbms_output.put_line('Last Result: ' || nvl(last_result, 'No Win'));
        dbms_output.put_line('');

        dbms_output.put_line('[1] Spin');
        dbms_output.put_line('[2] Change Bet');
        dbms_output.put_line('[3] Register');
        -- dbms_output.put_line('[3] Show Statistics');
        dbms_output.put_line('[4] Exit');

        dbms_output.put_line('');
        dbms_output.put_line('------------------------------------');
        dbms_output.put_line('');

        dbms_output.put_line('Selection:');
    end;

    procedure main_menu is
        player_name varchar2(100) := null;
        balance number := 100;
        last_result varchar2(100) := null;
        current_bet number := 10;
        v_reel slot_logic.reel := slot_logic.reel(NULL, NULL, NULL);
    begin
        while true loop
            print_main_menu(player_name, balance, last_result, v_reel);
            declare
                v_choice number := &choice;
                v_player_name varchar2(100);
                v_player_id number;
            begin
                if v_choice = 1 then
                    v_reel := slot_logic.draw_reel;
                    declare
                        v_payout number;
                    begin
                        v_payout := slot_logic.calculate_payout(v_reel, current_bet);
                        if v_payout > 0 then
                            last_result := 'You Win ' || v_payout || ' Coins!';
                            balance := balance + v_payout;
                        else
                            last_result := 'No Win. Try Again!';
                            balance := balance - current_bet;
                        end if;
                        print_main_menu(player_name, balance, last_result, v_reel);
                    end;
                elsif v_choice = 2 then
                    declare
                        v_new_bet number := &new_bet;
                    begin
                        if v_new_bet > 0 and v_new_bet <= balance then
                            current_bet := v_new_bet;
                            change_bet(v_player_id, current_bet);
                            dbms_output.put_line('Bet changed to ' || current_bet || ' Coins.');
                        else
                            dbms_output.put_line('Invalid bet amount. Please try again.');
                        end if;
                        DBMS_SESSION.SLEEP(2);
                        print_main_menu(player_name, balance, last_result, v_reel);
                    end;
                elsif v_choice = 3 then
                    v_player_name := '&player_name';
                    player_name := v_player_name;
                    dbms_output.put_line('Player registered as ' || player_name || '.');
                    DBMS_SESSION.SLEEP(2);
                    print_main_menu(player_name, balance, last_result, v_reel);
                elsif v_choice = 4 then
                    dbms_output.put_line('Thank you for playing! Goodbye!');
                    exit;
                else
                    dbms_output.put_line('Invalid choice. Please try again.');
                end if;
            end;
        end loop;
    end;

    procedure change_bet(p_player_id in number, p_new_bet in number) is
    begin
        -- check player exists
        if not exists (select 1 from player where player_id = p_player_id) then
            return;
        end if;

        if p_new_bet > 0 then
            update player
            set default_bet = p_new_bet
            where player_id = p_player_id;
            dbms_output.put_line('Bet changed to ' || p_new_bet || ' Coins.');
        else
            dbms_output.put_line('Invalid bet amount. Please try again.');
        end if;
    end;

end slot_cli;



select slot_logic.DRAW_REEL() from dual;