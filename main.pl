%module imports
:-['loaders/load_cli.pl'].
:-['loaders/load_logic.pl'].

start:-
    print_disclaimer,
    setPlayer(P1,1),
    setPlayer(P2,2),
    showPlayers(P1,P2),
    startBoard(Board),
    initPiecesPlayer(1,PP1),
    initPiecesPlayer(2,PP2),
    joinLists(PP2,PP1,ListOfPieces),
    printBoard(Board,ListOfPieces),
    gameLoop(1,P1,P2,ListOfPieces,Board).


playerMove(Player,human,ListOfPieces,Board):-
    choosePieceToMove(Player,Board,PieceToMove),
    movePiece(Player,PieceToMove,ListOfPieces,Board,ListAux,NewBoard),
    printBoard(NewBoard,ListAux),
    addPegToPiece(Player,NewBoard,ListAux,NewListOfPieces).
%    printBoard(NewBoard,NewListOfPieces).

%playerMove(Player,computer,ListOfPieces,Board):-
%    !.

gameLoop(Player,P1Type,P2Type,ListOfPieces,Board):-
    getCurrentPlayerType(Player,P1Type,P2Type,Type),
    playerMove(Player,Type,ListOfPieces,Board).
%    checkVictory,
%    nextPlayer,
%    gameLooop

