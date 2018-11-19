%Get Next Game Loop after checking Victory
nextGameLoop(1,2).
nextGameLoop(2,3).
nextGameLoop(3,1).

game_over(Loop,Board,_ListOfPieces,NextLoop,Winner):-
    victoryByEatPieces(Board,Loop,NextLoop,Winner).

game_over(Loop,_Board,ListOfPieces,NextLoop,Winner):-
    victoryByPieceWithPegs(ListOfPieces,Loop,NextLoop,Winner).

countByLine([],_P,N,N).

countByLine([H|T],Player,Aux,N):-
    checkIfPieceBelongsToPlayer(Player,H),
    A1 is Aux+1,
    countByLine(T,Player,A1,N).

countByLine([_H|T],Player,Aux,N):-
    countByLine(T,Player,Aux,N).


countByColumn([],_P,[]).

countByColumn([H|T],Player,[N|T1]):-
    countByLine(H,Player,0,N),
    countByColumn(T,Player,T1).


countPiecesByPlayer(Board,Player,Pieces):-
    countByColumn(Board,Player,List),
    sumListElements(List,Pieces).

countPlayersPieces(Board,PiecesP1,PiecesP2):-
    countPiecesByPlayer(Board,1,PiecesP1),
    countPiecesByPlayer(Board,2,PiecesP2).

%%
% If both players have more than 2 pieces the game continues
% Player 1 wins if he has more than 1 piece and Player 2 has 1 or 0 pieces
% Player 2 wins if he has more than 1 piece and Player 1 has 1 or 0 pieces
% If both players
% If both players have 2 pieces we need to check the pegs
%
%%
playerVictoryByPieces(PiecesP1,PiecesP2,Loop,NextLoop,_Winner):-
        PiecesP1>2,
        PiecesP2>2,
        nextGameLoop(Loop,NextLoop).

playerVictoryByPieces(PiecesP1,PiecesP2,_Loop,NextLoop,1):-
        PiecesP1>1,
        PiecesP2=<1,
        NextLoop is 4.

playerVictoryByPieces(PiecesP1,PiecesP2,_Loop,NextLoop,2):-
        PiecesP1=<1,
        PiecesP2>1,
        NextLoop is 4.

playerVictoryByPieces(PiecesP1,PiecesP2,_Loop,_NextLoop,_Winner):-
        PiecesP1=2,
        PiecesP2=2,
        !,fail.

victoryByEatPieces(Board,Loop,NextLoop,Winner):-
    countPlayersPieces(Board,PiecesP1,PiecesP2),!,
    playerVictoryByPieces(PiecesP1,PiecesP2,Loop,NextLoop,Winner),!.


%%%
% Will check for each player how many pegs has each piece and save the results on a list
% Player Z - has 2 pieces and each piece has the following pegs [X,Y].
%%
checkPegsForPlayer(_Player,[],[]).

checkPegsForPlayer(Player,[[N|[P]]|T],[NP|R]):-
    checkIfPieceBelongsToPlayer(Player,N),
    countElementsOnMatrix(1,P,NP),
    checkPegsForPlayer(Player,T,R).

checkPegsForPlayer(Player,[_H|T],NP):-
    checkPegsForPlayer(Player,T,NP).

%%%
% Will check if any player has a piece with the maximum number of pegs
%%
playerVictoryByPegs(P1,P2,_Loop,NextLoop,Winner):-
    P1>=1,
    P2>=1,
    NextLoop is 4,
    Winner is 3.

playerVictoryByPegs(P1,P2,_Loop,NextLoop,Winner):-
    P1>=1,
    P2=0,
    NextLoop is 4,
    Winner is 1.

playerVictoryByPegs(P1,P2,_Loop,NextLoop,Winner):-
    P1=0,
    P2>=1,
    NextLoop is 4,
    Winner is 2.

playerVictoryByPegs(P1,P2,Loop,NextLoop,_Winner):-
    P1=0,
    P2=0,
    nextGameLoop(Loop,NextLoop).

playerHasMaxedPegs(PegsP1,PegsP2,Loop,NextLoop,Winner):-
    numberOfPegsPerPiece(N),
    countElementsOnList(N,PegsP1,P1),
    countElementsOnList(N,PegsP2,P2),
    playerVictoryByPegs(P1,P2,Loop,NextLoop,Winner).

%%%
% At this point there should be only 4 pieces on the list,
% 2 for player 1 and 2 for player 2
%%%
victoryByPieceWithPegs(ListOfPieces,Loop,NextLoop,Winner):-
    checkPegsForPlayer(1,ListOfPieces,PegsP1),
    checkPegsForPlayer(2,ListOfPieces,PegsP2),
    playerHasMaxedPegs(PegsP1,PegsP2,Loop,NextLoop,Winner).

% count the number of pegs per piece, per player Result->[10,20]
% Check how many elements on the list is equal to the size of max pegs, per player
% If player 1 has at least one and player 2 none -> player 1 wins
% If player 2 has at least one and player 1 none -> player 2 wins
% If both have at least one piece complete -> its a draw
% If no one has at least 1 piece completed, the game continues...



%%%%%%%%%% TEST %%%%%%%%%%%%

victoryBoardTest( [
                [1,2,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,10,12]
            ]
          ).

listOfPiecesVictory([
    [3,[[1,1,1,1,1],[1,1,1,1,1],[1,1,8,1,1],[1,1,1,1,1],[1,1,1,1,1]]],
    [6,[[1,1,1,0,1],[1,1,1,1,1],[0,1,8,1,0],[0,0,0,1,0],[1,1,1,1,1]]],
    [8,[[0,0,0,0,1],[1,0,1,0,1],[0,1,8,1,0],[0,0,0,1,0],[1,1,1,1,1]]],
    [9,[[1,1,1,1,0],[1,1,1,1,1],[1,1,8,1,1],[1,1,1,1,1],[1,1,1,1,1]]]
]).

testVictoryCountPiecesOfPlayers:-
    victoryBoardTest(X),
    game_over(X,_Y).


testCheckPegsForPlayer(Pegs):-
    listOfPiecesVictory(L),
    checkPegsForPlayer(1,L,Pegs).

testVictoryByPiecesWithPegs:-
    listOfPiecesVictory(L),
    victoryByPieceWithPegs(L).
