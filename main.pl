%module imports
:-['loaders/load_cli.pl'].
:-['loaders/load_logic.pl'].

nextPlayer(1,2).
nextPlayer(2,1).

play:-
    print_disclaimer,
    setPlayer(P1,1),
    setPlayer(P2,2),
    showPlayers(P1,P2),
    startBoard(Board),
    initPiecesPlayer(1,PP1),
    initPiecesPlayer(2,PP2),
    joinLists(PP2,PP1,ListOfPieces),
    display_game(Board,ListOfPieces),
    gameLoop(1,1,P1,P2,ListOfPieces,Board,_Winner).

playerAddPeg(Player,human,Board,ListOfPieces,NewListOfPieces):-
    addPegToPiece(Player,Board,ListOfPieces,NewListOfPieces),
    display_game(Board,NewListOfPieces).

playerAddPeg(Player,computerRandom,Board,ListOfPieces,NewListOfPieces):-
    waitForPlayerToAddPeg(Player),
    addPegToPieceComputer(Player,Board,ListOfPieces,NewListOfPieces),
    display_game(Board,NewListOfPieces).

playerAddPeg(Player,computerAI,Board,ListOfPieces,NewListOfPieces):-
    waitForPlayerToAddPeg(Player),
    addPegToPieceComputerAI(Player,Board,ListOfPieces,NewListOfPieces),
    display_game(Board,NewListOfPieces).

move(Player,human,ListOfPieces,Board,NewBoard,NewListOfPieces):-
    choosePieceToMove(Player,Board,PieceToMove),
    movePiece(Player,PieceToMove,ListOfPieces,Board,NewListOfPieces,NewBoard),
    display_game(NewBoard,NewListOfPieces).

move(Player,computerRandom,ListOfPieces,Board,NewBoard,NewListOfPieces):-
    waitForPlayerMove(Player),
    choosePieceToMoveComputer(Player,Board,PieceToMove),
    movePieceComputer(PieceToMove,ListOfPieces,Board,NewListOfPieces,NewBoard),
    display_game(NewBoard,NewListOfPieces).

move(Player,computerAI,ListOfPieces,Board,NewBoard,NewListOfPieces):-
    waitForPlayerMove(Player),
    choosePieceToMoveComputerAI(Player,Board,ListOfPieces,PieceToMove,PosX,PosY),
    movePieceOnBoard(Board,PieceToMove,PosX,PosY,NewBoard),
    updatePieceList(NewBoard,ListOfPieces,NewListOfPieces),
    display_game(NewBoard,NewListOfPieces).

%Loops:
% 1 - Choose Piece to Move
% 2 - Add Peg to Piece
% 3 - Add Peg to Piece
% 4 - Game Victory
gameLoop(1,Player,P1Type,P2Type,ListOfPieces,Board,_W):-
    getCurrentPlayerType(Player,P1Type,P2Type,Type),
    move(Player,Type,ListOfPieces,Board,BoardMove,ListOfPiecesMove),
    game_over(1,BoardMove,ListOfPiecesMove,NextLoop,Winner),
    gameLoop(NextLoop,Player,P1Type,P2Type,ListOfPiecesMove,BoardMove,Winner).

gameLoop(2,Player,P1Type,P2Type,ListOfPieces,Board,_W):-
    getCurrentPlayerType(Player,P1Type,P2Type,Type),
    playerAddPeg(Player,Type,Board,ListOfPieces,ListOfPiecesPeg),
    game_over(2,Board,ListOfPiecesPeg,NextLoop,Winner),
    gameLoop(NextLoop,Player,P1Type,P2Type,ListOfPiecesPeg,Board,Winner).

gameLoop(3,Player,P1Type,P2Type,ListOfPieces,Board,_W):-
    getCurrentPlayerType(Player,P1Type,P2Type,Type),
    playerAddPeg(Player,Type,Board,ListOfPieces,ListOfPiecesLastPeg),
    game_over(3,Board,ListOfPiecesLastPeg,NextLoop,Winner),
    nextPlayer(Player,NextPlayer),
    gameLoop(NextLoop,NextPlayer,P1Type,P2Type,ListOfPiecesLastPeg,Board,Winner).

gameLoop(4,_P,_T1,_T2,_LP,_B,Winner):-
    print_gameOver_message(Winner).
