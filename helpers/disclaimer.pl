%%%%%%%%%%%%%%%%%%
%%% DISCLAIMER %%%
%%%%%%%%%%%%%%%%%%

:-['printutils.pl'].

prolog:message(game_info(Programmer,Student,Major,Minor,Rev)) -->
    [
        'Game Programmed By ~w (~w)'-[Programmer,Student], nl,
        'Version: ~d.~d.~d'-[Major,Minor,Rev], nl
    ].


print_disclaimer :-
    print_message(banner, single_line('Welcome to Eigenstate')),
    print_char(banner,'-',50),
    print_message(banner, game_info('Ricardo Ferreira', 'up200305418', 0,0,0)).