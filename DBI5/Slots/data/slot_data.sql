create table player (
    player_id number primary key,
    player_name varchar2(100) not null,
    default_bet number default 1,
    balance number default 0
);