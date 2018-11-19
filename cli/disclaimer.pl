%%%%%%%%%%%%%%%%%%
%%% DISCLAIMER %%%
%%%%%%%%%%%%%%%%%%

prolog:message(game_info(Programmer,Student,Major,Minor,Rev)) -->
    [
        'Game Programmed By ~w (~w)'-[Programmer,Student], nl,
        'Version: ~d.~d.~d'-[Major,Minor,Rev], nl
    ].


print_disclaimer :-
    print_message(banner, single_line('Welcome to Eigenstate')),
    print_char(banner,'-',50),
    print_message(banner, game_info('Ricardo Ferreira', 'up200305418', 1,0,1)),
    nl.


print_gameOver_message(3):-
    gameOverFontColor(C),
    nl,
    ansi_format([fg(C)],'~w',['The game ended in a draw.']),
    print_message(banner, single_line('Thanks for Playing. Goodbye.')).

print_gameOver_message(Winner):-
    gameOverFontColor(C),
    nl,
    ansi_format([fg(C)],'~w~w~w',['Winner is Player ',Winner,'.']),
    print_message(banner, single_line('Thanks for Playing. Goodbye.')).
