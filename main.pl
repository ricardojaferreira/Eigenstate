%module imports
:-['loaders/load_cli.pl'].
:-['loaders/load_logic.pl'].

start:-
%    print_disclaimer,
%    setPlayer(P1,1),
%    setPlayer(P2,2),
%    showPlayers(P1,P2),
    startBoard(Board),
    initPiecesPlayer(1,PP1),
    initPiecesPlayer(2,PP2),
    joinLists(PP2,PP1,ListOfPieces),
    printBoard(Board,ListOfPieces).

%start:-
%    print_disclaimer,
%    nl,
%    setPlayer(P1,1),
%    nl,
%    setPlayer(P2,2),
%    factFontColor(FactColor),
%    ansi_format([fg(FactColor)],'~w',['Player 1 is ']),
%    translateType(P1,_Z1,FactColor),
%    ansi_format([fg(FactColor)],'~w',['.']),
%    nl,
%    ansi_format([fg(FactColor)],'~w',['Player 2 is ']),
%    translateType(P2,_Z2,FactColor),
%    ansi_format([fg(FactColor)],'~w',['.']),



%    startBoard(Board),
%    printBoard(Board),
%    write(Board),
%    playerChoosePieceToMove(P1, LocX, LocY),
%    ansi_format([fg(FactColor)],'~w~w~w~w',['LocX: ', LocX, ' LocY: ', LocY]).
