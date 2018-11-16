:-['../cli/player_cli.pl'].
:-['pieces.pl'].


playerTypesAvailable([0,1]).

playerType(0,human).
playerType(1,computer).

%%%
% Checks if the player is one of the availables
%%
isPlayerTypeAvailable(Type,[Type|_T]).

isPlayerTypeAvailable(Type,[_X|T]):-
    isPlayerTypeAvailable(Type,T).

%%%
% Checks the type chosen by the user
%%
checkType(Type,[Type|_T]):-
    playerTypesAvailable(Types),
    isPlayerTypeAvailable(Type, Types).

checkType(_Z,Result):-
    playerTypesAvailable(Types),
    askPlayerToChooseAgain(Types, Choice),
    checkType(Choice,Result).

%%%
% Sets the player type if it is valid.
% If not valid this will run in cycle until a valid option is chosen.
%%
setPlayer(Type,Player):-
    playerTypesAvailable(Types),
    askPlayerToChoose(Player,Types,X),
    checkType(X,[Type|_T]).

%%%
% Shows the type of each player
showPlayers(P1,P2):-
    playerType(P1, Type1),
    playerType(P2, Type2),
    showPlayerTypes(Type1, Type2).

%%%
% This is just a way to know the current Player type in loop mode.
getCurrentPlayerType(1,P1Type,_P2Type,Type):-
    playerType(P1Type,Type).
getCurrentPlayerType(2,_P1Type,P2Type,Type):-
    playerType(P2Type,Type).


choosePieceToMove(Player,Board,PieceToMove):-
    boardSquareSize(S),
    askPlayerToChoosePieceToMove(Player,S,PosX,PosY),
    checkBoardCellChoice(Player,Board,PosX,PosY,PieceToMove),!.

getListOfPiecesForPlayerAux(_Player,[],[]).

getListOfPiecesForPlayerAux(Player,[H|T],[H|L]):-
    checkIfPieceBelongsToPlayer(Player,H),
    getListOfPiecesForPlayerAux(Player,T,L).

getListOfPiecesForPlayerAux(Player,[_H|T],L):-
    getListOfPiecesForPlayerAux(Player,T,L).

getListOfPiecesForPlayer(_Player,[],[]).

getListOfPiecesForPlayer(Player,[BL|R],[C|L]):-
    getListOfPiecesForPlayerAux(Player,BL,C),
    getListOfPiecesForPlayer(Player,R,L).


choosePieceToMoveComputer(Player,Board,PieceToMove):-
    getListOfPiecesForPlayer(Player,Board,ListAux),
    convertToSimpleList(ListAux,List),
    chooseRandomElement(List,RandomElement),
    getListValueByIndex(List,RandomElement,PieceToMove).


%%%%%%%%%%%%%%%% TESTE %%%%%%%%%%%%%%%%%%%%%%%%

playersBoardTest( [
                [1,2,3,4,5,6],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [7,8,9,10,11,12]
            ]
          ).

testChoosePieceToMoveComputer(Piece):-
    playersBoardTest(B),
    choosePieceToMoveComputer(1,B,Piece).
