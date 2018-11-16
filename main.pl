%module imports
:-['loaders/load_cli.pl'].
:-['loaders/load_logic.pl'].

nextPlayer(1,2).
nextPlayer(2,1).

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


playerAddPeg(Player,human,Board,ListOfPieces,NewListOfPieces):-
    addPegToPiece(Player,Board,ListOfPieces,NewListOfPieces),
    printBoard(Board,NewListOfPieces).

playerAddPeg(Player,computer,Board,ListOfPieces,NewListOfPieces):-
    addPegToPieceComputer(Player,Board,ListOfPieces,NewListOfPieces),
    printBoard(Board,NewListOfPieces).


playerMove(Player,human,ListOfPieces,Board,NewBoard,NewListOfPieces):-
    choosePieceToMove(Player,Board,PieceToMove),
    movePiece(Player,PieceToMove,ListOfPieces,Board,NewListOfPieces,NewBoard),
    printBoard(NewBoard,NewListOfPieces).

playerMove(Player,computer,ListOfPieces,Board,NewBoard,NewListOfPieces):-
    choosePieceToMoveComputer(Player,Board,PieceToMove),
    movePieceComputer(PieceToMove,ListOfPieces,Board,NewListOfPieces,NewBoard),
    printBoard(NewBoard,NewListOfPieces).

gameLoop(Player,P1Type,P2Type,ListOfPieces,Board):-
    getCurrentPlayerType(Player,P1Type,P2Type,Type),
    playerMove(Player,Type,ListOfPieces,Board,BoardMove,ListOfPiecesMove),
    checkVictory(BoardMove,ListOfPiecesMove),
    playerAddPeg(Player,Type,BoardMove,ListOfPiecesMove,ListOfPiecesPeg),
    checkVictory(BoardMove,ListOfPiecesPeg),
    playerAddPeg(Player,Type,BoardMove,ListOfPiecesPeg,ListOfPiecesLastPeg),
    checkVictory(BoardMove,ListOfPiecesLastPeg),
    nextPlayer(Player,NextPlayer),
    gameLoop(NextPlayer,P1Type,P2Type,ListOfPiecesLastPeg,BoardMove).







%
%[
%    [1,[[0,0,0,0,0],[0,0,0,0,0],[0,0,8,0,0],[0,0,1,0,0],[0,0,0,0,0]]],
%    [2,[[0,0,0,0,0],[0,0,0,0,0],[0,0,8,0,0],[0,0,1,0,0],[0,0,0,0,0]]],
%    [3,[[0,0,0,0,0],[0,0,0,0,0],[0,0,8,0,0],[0,0,1,0,0],[0,0,0,0,0]]],
%    [4,[[0,0,0,0,0],[0,0,0,0,0],[0,0,8,0,0],[0,0,1,0,0],[0,0,0,0,0]]],
%    [5,[[0,0,0,0,0],[0,0,0,0,0],[0,0,8,0,0],[0,0,1,0,0],[0,0,0,0,0]]],
%    [6,[[0,0,0,0,0],[0,0,0,0,0],[0,0,8,0,0],[0,0,1,0,0],[0,0,0,0,0]]],
%    [7,[[0,0,0,0,0],[0,0,1,0,0],[0,0,8,0,0],[0,0,0,0,0],[0,0,0,0,0]]],
%    [8,[[0,0,0,0,0],[0,0,1,0,0],[0,0,8,0,0],[0,0,0,0,0],[0,0,0,0,0]]],
%    [9,[[0,0,0,0,0],[0,0,1,0,0],[0,0,8,0,0],[0,0,0,0,0],[0,0,0,0,0]]],
%    [10,[[0,0,0,0,0],[0,0,1,0,0],[0,0,8,0,0],[0,0,0,0,0],[0,0,0,0,0]]],
%    [11,[[0,0,0,0,0],[0,0,1,0,0],[0,0,8,0,0],[0,0,0,0,0],[0,0,0,0,0]]],
%    [12,[[0,0,0,0,0],[0,0,1,0,0],[0,0,8,0,0],[0,0,0,0,0],[0,0,0,0,0]]]
%]
%
%[
%    [1,[[0,0,0,0,0],[0,0,0,0,0],[0,0,8,0,0],[0,0,1,0,0],[0,0,0,0,0]]],
%    [2,[[0,0,0,0,0],[0,0,0,0,0],[0,0,8,0,0],[0,0,1,0,0],[0,0,0,0,0]]],
%    [3,[0,1,0,0,0],[0,0,0,0,0],[0,0,8,0,0],[0,0,1,0,0],[0,0,0,0,0]],
%    [4,[[0,0,0,0,0],[0,0,0,0,0],[0,0,8,0,0],[0,0,1,0,0],[0,0,0,0,0]]],
%    [5,[[0,0,0,0,0],[0,0,0,0,0],[0,0,8,0,0],[0,0,1,0,0],[0,0,0,0,0]]],
%    [6,[[0,0,0,0,0],[0,0,0,0,0],[0,0,8,0,0],[0,0,1,0,0],[0,0,0,0,0]]],
%    [7,[[0,0,0,0,0],[0,0,1,0,0],[0,0,8,0,0],[0,0,0,0,0],[0,0,0,0,0]]],
%    [8,[[0,0,0,0,0],[0,0,1,0,0],[0,0,8,0,0],[0,0,0,0,0],[0,0,0,0,0]]],
%    [9,[[0,0,0,0,0],[0,0,1,0,0],[0,0,8,0,0],[0,0,0,0,0],[0,0,0,0,0]]],
%    [10,[[0,0,0,0,0],[0,0,1,0,0],[0,0,8,0,0],[0,0,0,0,0],[0,0,0,0,0]]],
%    [11,[[0,0,0,0,0],[0,0,1,0,0],[0,0,8,0,0],[0,0,0,0,0],[0,0,0,0,0]]],
%    [12,[[0,0,0,0,0],[0,0,1,0,0],[0,0,8,0,0],[0,0,0,0,0],[0,0,0,0,0]]]
%]










