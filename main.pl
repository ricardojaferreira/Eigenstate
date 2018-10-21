%module imports
:-['helpers/printutils.pl'].
:-['helpers/disclaimer.pl'].
:-['helpers/players.pl'].
:-['helpers/board.pl'].

start:-
    print_disclaimer,
    nl,
    setPlayer(X,1),
    nl,
    setPlayer(Y,2),
    factFontColor(FactColor),
    ansi_format([fg(FactColor)],'~w',['Player 1 is ']),
    translateType(X,_Z1,FactColor),
    ansi_format([fg(FactColor)],'~w',['.']),
    nl,
    ansi_format([fg(FactColor)],'~w',['Player 2 is ']),
    translateType(Y,_Z2,FactColor),
    ansi_format([fg(FactColor)],'~w',['.']),
    printBoard.