:-['logic/pieces.pl'].

checkVictory(Board,_ListOfPieces):-
    victoryByEatPieces(Board).

checkVictory(_Board, ListOfPieces):-
    victoryByPieceWithPegs(ListOfPieces).

%checkVictory(Board,ListOfPieces):-
%    victoryByPegs(Board,ListOfPieces).

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
playerVictoryByPieces(PiecesP1,PiecesP2):-
        PiecesP1>2,
        PiecesP2>2.

playerVictoryByPieces(PiecesP1,PiecesP2):-
        PiecesP1>1,
        PiecesP2=<1,
        write('Player 1 wins!'),
        halt.

playerVictoryByPieces(PiecesP1,PiecesP2):-
        PiecesP1=<1,
        PiecesP2>1,
        write('Player 2 wins!'),
        halt.

playerVictoryByPieces(PiecesP1,PiecesP2):-
        PiecesP1=2,
        PiecesP2=2,
        !,fail.

victoryByEatPieces(Board):-
    countPlayersPieces(Board,PiecesP1,PiecesP2),!,
    playerVictoryByPieces(PiecesP1,PiecesP2),!.


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
playerVictoryByPegs(P1,P2):-
    P1>=1,
    P2>=1,
    write("It's a draw"),
    halt.

playerVictoryByPegs(P1,P2):-
    P1>=1,
    P2=0,
    write("Player 1 Wins"),
    halt.

playerVictoryByPegs(P1,P2):-
    P1=0,
    P2>=1,
    write("Player 2 Wins"),
    halt.

playerVictoryByPegs(P1,P2):-
    P1=0,
    P2=0.

playerHasMaxedPegs(PegsP1,PegsP2):-
    numberOfPegsPerPiece(N),
    countElementsOnList(N,PegsP1,P1),
    countElementsOnList(N,PegsP2,P2),
    playerVictoryByPegs(P1,P2).

%%%
% At this point there should be only 4 pieces on the list,
% 2 for player 1 and 2 for player 2
%%%
victoryByPieceWithPegs(ListOfPieces):-
    checkPegsForPlayer(1,ListOfPieces,PegsP1),
    checkPegsForPlayer(2,ListOfPieces,PegsP2),
    playerHasMaxedPegs(PegsP1,PegsP2).

% count the number of pegs per piece, per player Result->[10,20]
% Check how many elements on the list is equal to the size of max pegs, per player
% If player 1 has at least one and player 2 none -> player 1 wins
% If player 2 has at least one and player 1 none -> player 2 wins
% If both have at least one piece complete -> its a draw
% If no one has at least 1 piece completed, the game continues...



%%%%%%%%%% TESTE %%%%%%%%%%%%

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
    checkVictory(X,_Y).


testCheckPegsForPlayer(Pegs):-
    listOfPiecesVictory(L),
    checkPegsForPlayer(1,L,Pegs).

testVictoryByPiecesWithPegs:-
    listOfPiecesVictory(L),
    victoryByPieceWithPegs(L).
