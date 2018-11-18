%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This part of the logic generates a new board were     %
% the cells are weights to help decide the best move.   %
% At the end the best piece to move will be chosen.     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%The weights are based on the number of surrounding cells
%Each cell can have a maximum of 24 cells around it.
weightOfOpponentCells(72).
weightOfEmptyCells(48).
weightOfPlayerCells(0).

%If more than one movement have the max score a random movement
%is choosed to avoid the same starting point on different games.
choosePieceToMoveComputerAI(Player,Board,ListOfPieces,Piece,PosX,PosY):-
    getListOfPiecesForPlayer(Player,Board,ListAux),
    convertToSimpleList(ListAux,List),
    generateWeightBoard(List,Board,WeightBoard),
    evaluatePiecesAround(List,ListOfPieces,Board,1,WeightBoard,BalancedWeightBoard),
    getListOfPiecesAndMovesByScore(List,ListOfPieces,Board,BalancedWeightBoard,PiecesAndMovesAux),
    convertToSimpleList(PiecesAndMovesAux,PiecesAndMoves),
    getBestChoiceByScore(PiecesAndMoves,Piece,PosX,PosY).
%    getIndexOfListMap(PiecesAndMoves,Indexes),
%    getMaxNumber(Indexes,MaxScore),
%    getAllElementsFromMapById(MaxScore,PiecesAndMoves,ListOfPiecesToMove),
%    chooseRandomElement(ListOfPiecesToMove,Element),
%    getListValueByIndex(ListOfPiecesToMove,Element,[Piece,PosX,PosY]).


%%%
generateWeightBoardLine(_List,[],[]).

generateWeightBoardLine(List,[0|Bl],[Wbe|Wbl]):-
    weightOfEmptyCells(Wbe),
    generateWeightBoardLine(List,Bl,Wbl).

generateWeightBoardLine(List,[Be|Bl],[Wbe|Wbl]):-
    checkIfExists(Be,List),
    weightOfPlayerCells(Wbe),
    generateWeightBoardLine(List,Bl,Wbl).

generateWeightBoardLine(List,[_Be|Bl],[Wbe|Wbl]):-
    weightOfOpponentCells(Wbe),
    generateWeightBoardLine(List,Bl,Wbl).

generateWeightBoard(_List,[],[]).

generateWeightBoard(List,[Bl|B],[Wbl|Wb]):-
    generateWeightBoardLine(List,Bl,Wbl),
    generateWeightBoard(List,B,Wb).

%%%%

%getEvaluator(E,Args):- F=.. [E|Args], F.

checkIfPieceCanGoToPosition([],_IndexX,_IndexY,_PosX,_PosY,0).

checkIfPieceCanGoToPosition([[Y,X]|_P],IndexX,IndexY,PosX,PosY,Aux):-
    EvalX is X+IndexX,
    EvalY is Y+IndexY,
    PosX = EvalX,
    PosY = EvalY,
    Aux is 1.

checkIfPieceCanGoToPosition([_Pd|P],IndexX,IndexY,PosX,PosY,Aux):-
    checkIfPieceCanGoToPosition(P,IndexX,IndexY,PosX,PosY,Aux).

getListOfBalancesByLine(_List,_ListOfPieces,[],_IndexX,_IndexY,_PosX,_PosY,[]).

getListOfBalancesByLine(List,ListOfPieces,[0|Bl],IndexX,IndexY,PosX,PosY,[0|B]):-
    IndexYAux is IndexY+1,
    getListOfBalancesByLine(List,ListOfPieces,Bl,IndexX,IndexYAux,PosX,PosY,B).

getListOfBalancesByLine(List,ListOfPieces,[E|Bl],IndexX,IndexY,PosX,PosY,[B1|B]):-
    checkIfExists(E,List),
    B1 is 0,
    IndexYAux is IndexY+1,
    getListOfBalancesByLine(List,ListOfPieces,Bl,IndexX,IndexYAux,PosX,PosY,B).

getListOfBalancesByLine(List,ListOfPieces,[E|Bl],IndexX,IndexY,PosX,PosY,[B1|B]):-
    getPieceByIndex(E,ListOfPieces,Piece),
    getPieceElementsPositions(getPegsByLine,-2,Piece,[],Pegs),
    convertToSimpleList(Pegs,PegsPositions),
    checkIfPieceCanGoToPosition(PegsPositions,IndexX,IndexY,PosX,PosY,B1),
    IndexYAux is IndexY+1,
    getListOfBalancesByLine(List,ListOfPieces,Bl,IndexX,IndexYAux,PosX,PosY,B).


getListOfBalances(_List,_ListOfPieces,_Board,_PosX,_PosY,IndexXAux,[]):-
    boardLines(L),
    IndexXAux > L.

getListOfBalances(List,ListOfPieces,Board,PosX,PosY,IndexX,[Wl|Wm]):-
    getListValueByIndex(Board,IndexX,BoardLine),
    getListOfBalancesByLine(List,ListOfPieces,BoardLine,IndexX,1,PosX,PosY,Aux),
    sumListElements(Aux,Wl),
    IndexXAux is IndexX+1,
    getListOfBalances(List,ListOfPieces,Board,PosX,PosY,IndexXAux,Wm).

getBalancedWeightByElement(List,ListOfPieces,Board,PosX,PosY,IndexX,Wbe,Bwbe):-
    getBoardCellValue(Board,PosX,PosY,PieceNumber),
    checkIfExists(PieceNumber,List),
    getListOfBalances(List,ListOfPieces,Board,PosX,PosY,IndexX,Aux),
    sumListElements(Aux,Balance),
    Bwbe is Wbe+Balance.

getBalancedWeightByElement(List,ListOfPieces,Board,PosX,PosY,IndexX,Wbe,Bwbe):-
    getListOfBalances(List,ListOfPieces,Board,PosX,PosY,IndexX,Aux),
    sumListElements(Aux,Balance),
    Bwbe is Wbe-Balance.


evaluatePiecesAroundByLine(_List,_ListOfPieces,_Board,_PosX,_PosY,[],[]).

evaluatePiecesAroundByLine(List,ListOfPieces,Board,PosX,PosY,[Wbe|Wbl],[Bwbe|Bwbl]):-
    IndexX is PosX-2,
    boardLines(L),
    between(1,L,IndexX),
    getBalancedWeightByElement(List,ListOfPieces,Board,PosX,PosY,IndexX,Wbe,Bwbe),!,
    PosYAux is PosY+1,
%    write('call1'),
    evaluatePiecesAroundByLine(List,ListOfPieces,Board,PosX,PosYAux,Wbl,Bwbl).

evaluatePiecesAroundByLine(List,ListOfPieces,Board,PosX,PosY,[Wbe|Wbl],[Bwbe|Bwbl]):-
    IndexX is PosX-1,
    boardLines(L),
    between(1,L,IndexX),
    getBalancedWeightByElement(List,ListOfPieces,Board,PosX,PosY,IndexX,Wbe,Bwbe),!,
    PosYAux is PosY+1,
%    write('call2'),
    evaluatePiecesAroundByLine(List,ListOfPieces,Board,PosX,PosYAux,Wbl,Bwbl).

evaluatePiecesAroundByLine(List,ListOfPieces,Board,PosX,PosY,[Wbe|Wbl],[Bwbe|Bwbl]):-
    getBalancedWeightByElement(List,ListOfPieces,Board,PosX,PosY,PosX,Wbe,Bwbe),!,
    PosYAux is PosY+1,
%    write('call3'),
    evaluatePiecesAroundByLine(List,ListOfPieces,Board,PosX,PosYAux,Wbl,Bwbl).

%%Arguments:
%List-> List of players pieces
%ListOfPieces -> List with all the pieces actual state
%Board-> the actual board
%WeightBoard -> The board with the original weights
%BlancedWeightBoard -> The resulting balanced Weight Board
evaluatePiecesAround(_List,_ListOfPieces,_Board,_PosX,[],[]).

evaluatePiecesAround(List,ListOfPieces,Board,PosX,[Wbl|Wb],[Bwbl|Bwb]):-
    evaluatePiecesAroundByLine(List,ListOfPieces,Board,PosX,1,Wbl,Bwbl),
    PosX1 is PosX+1,
    evaluatePiecesAround(List,ListOfPieces,Board,PosX1,Wb,Bwb).


%%%%%

getScoreAndMovesByPiece(_P,_W,[],_Bw,[]).

getScoreAndMovesByPiece(P,Weight,[[Y,X]|Vmoves],BalancedWeightBoard,[[Score,[P,X,Y]]|Smp]):-
    getBoardCellValue(BalancedWeightBoard,X,Y,WeightCell),
    Score is Weight + WeightCell,
    getScoreAndMovesByPiece(P,Weight,Vmoves,BalancedWeightBoard,Smp).

getListOfPiecesAndMovesByScore([],_ListOfPieces,_Board,_BalancedWeightBoard,[]).

getListOfPiecesAndMovesByScore([P|L],ListOfPieces,Board,BalancedWeightBoard,[Smp|Sm]):-
    getMatrixElementPosition(P,Board,PosX,PosY),
    getBoardCellValue(BalancedWeightBoard,PosX,PosY,Weight),
    getPieceByIndex(P,ListOfPieces,Piece),
    getPieceElementsPositions(getPegsByLine,-2,Piece,[],Pegs),
    convertToSimpleList(Pegs,PegsPositions),
    valid_moves(Board,P,PegsPositions,ValidMoves),
    getScoreAndMovesByPiece(P,Weight,ValidMoves,BalancedWeightBoard,Smp),
    getListOfPiecesAndMovesByScore(L,ListOfPieces,Board,BalancedWeightBoard,Sm).



%%%%%%%%%%%% TESTE %%%%%%%%%%%%%%%%%%%%%

aiBoardTest( [
                [7,2,3,0,0,0],
                [0,1,9,0,0,0],
                [0,8,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0]
            ]
          ).

aiBoardWeight( [
                [72,0,0,48,48,48],
                [48,0,72,48,48,48],
                [48,72,48,48,48,48],
                [48,48,48,48,48,48],
                [48,48,48,48,48,48],
                [48,48,48,48,48,48]
            ]

          ).

aiBalancedBoardWeight([
                        [71,1,2,47,48,48],
                        [48,3,71,48,48,48],
                        [47,71,47,47,48,48],
                        [47,47,47,47,48,48],
                        [47,48,47,48,48,48],
                        [48,48,48,48,48,48]
                    ]
).

aiWeightLine([72,0,0,48,48,48]).

aiBoardLine([1,3,8,7,0,0]).

aiPiecesPlayer1([1,2,3]).
aiPiecesPlayer2([7,8,9]).

aiListOfPiecesMovements([
         [1,[[0,1,0,1,0],[0,0,0,1,0],[0,0,8,1,0],[0,1,0,1,0],[1,0,0,0,1]]],
         [2,[[0,0,0,0,0],[0,0,1,0,0],[0,0,8,0,0],[1,0,0,0,0],[0,0,0,0,0]]],
         [3,[[0,0,0,0,0],[0,0,1,0,0],[0,0,8,0,0],[0,0,1,0,0],[0,0,0,1,0]]],
         [7,[[0,0,0,0,0],[0,0,1,0,0],[0,0,8,0,0],[0,0,0,1,0],[1,1,0,0,0]]],
         [8,[[0,1,0,1,0],[0,0,1,1,0],[0,1,8,1,0],[0,1,0,1,0],[0,1,0,1,0]]],
         [9,[[0,1,0,1,0],[0,1,1,1,0],[0,1,8,0,0],[0,1,0,1,0],[0,1,0,1,0]]]
         ]).


aiPegsPositions([[2,1],[-1,0],[-1,2],[1,1]]).

testWeightBoard:-
    aiBoardTest(B),
    aiPiecesPlayer1(L),
    generateWeightBoard(L,B,WB),
    write(WB).

testCheckIfPieceCanGoToPosition(B1):-
    aiPegsPositions(Pegs),
    checkIfPieceCanGoToPosition(Pegs,1,2,2,2,B1).

testGetListOfBalancesByLine(Aux):-
    aiPiecesPlayer1(L),
    aiListOfPiecesMovements(Lm),
    aiBoardLine(Bl),
    getListOfBalancesByLine(L,Lm,Bl,2,1,4,2,Aux).

testGetListOfBalances(Aux):-
    aiPiecesPlayer1(L),
    aiListOfPiecesMovements(Lm),
    aiBoardTest(Bl),
    getListOfBalances(L,Lm,Bl,2,2,1,Aux).

testGetBalancedWeightByElement(W):-
    aiPiecesPlayer1(L),
    aiListOfPiecesMovements(Lm),
    aiBoardTest(Bl),
    getBalancedWeightByElement(L,Lm,Bl,2,2,1,48,W).

testEvaluatePiecesAroundByLine(Bwl):-
    aiPiecesPlayer1(L),
    aiListOfPiecesMovements(Lm),
    aiBoardTest(Bl),
    aiWeightLine(Wl),
    evaluatePiecesAroundByLine(L,Lm,Bl,1,1,Wl,Bwl).

testEvaluatePiecesAround:-
    aiPiecesPlayer1(L),
    aiListOfPiecesMovements(Lm),
    aiBoardTest(Bl),
    aiBoardWeight(Wb),
    evaluatePiecesAround(L,Lm,Bl,1,Wb,Bw),
    write(Bw).

testGetListOfPiecesAndMovesByScore:-
    aiPiecesPlayer1(L),
    aiListOfPiecesMovements(Lm),
    aiBoardTest(Bl),
    aiBalancedBoardWeight(Bbw),
    getListOfPiecesAndMovesByScore(L,Lm,Bl,Bbw,PiecesAndMoves),
    convertToSimpleList(PiecesAndMoves,Simple),
    write(PiecesAndMoves),nl,
    write(Simple),nl.

testChoosePieceToMoveComputerAI(Piece,X,Y):-
    aiBoardTest(B),
    aiListOfPiecesMovements(Pm),
    choosePieceToMoveComputerAI(1,B,Pm,Piece,X,Y).