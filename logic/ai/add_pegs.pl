%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This part of the logic add Pegs to Pieces             %
% If the game is reduced to 2 pieces per player, the AI %
% will try to add Pegs on the piece with most Pegs to   %
% fill the piece with pegs and win.                     %
% On other game states, the AI will try to add pegs     %
% based on the biggest distance covered (because it     %
% gives more freedom to the piece) and on the           %
% possibility of eat an opponent piece.                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addPegToPieceComputerAI(Player,Board,ListOfPieces,NewListOfPieces):-
    getListOfPiecesForPlayer(Player,Board,ListAux),
    convertToSimpleList(ListAux,ListPlayer),
    getListLength(ListPlayer,PlayerPieces),!,
    nextPlayer(Player,Opponent),
    getListOfPiecesForPlayer(Opponent,Board,ListOpponentAux),
    convertToSimpleList(ListOpponentAux,ListOpponent),
    getListLength(ListOpponent,OpponentPieces),!,
    generateWeightBoard(ListPlayer,Board,WeightBoard),
    evaluatePiecesAround(ListPlayer,ListOfPieces,Board,1,WeightBoard,BalancedWeightBoard),
    runPegStrategy(PlayerPieces,OpponentPieces,ListPlayer,Board,ListOfPieces,BalancedWeightBoard,NewListOfPieces).


runPegStrategy(2,2,ListPlayer,Board,ListOfPieces,BalancedWeightBoard,NewListOfPieces):-
    strategyFillPegs(ListPlayer,Board,ListOfPieces,BalancedWeightBoard,NewListOfPieces).

runPegStrategy(_L1,_L2,ListPlayer,Board,ListOfPieces,BalancedWeightBoard,NewListOfPieces):-
    strategyGoFurther(ListPlayer,Board,ListOfPieces,BalancedWeightBoard,NewListOfPieces).

getWeightByMovement(PosX,_PosY,Mx,_My,Weight):-
    UpX is PosX-2,
    Mx =:= UpX,
    Weight = 1.

getWeightByMovement(PosX,_PosY,Mx,_My,Weight):-
    DownX is PosX+2,
    Mx =:= DownX,
    Weight = 1.

getWeightByMovement(_PosX,PosY,_Mx,My,Weight):-
    LeftY is PosY-2,
    My =:= LeftY,
    Weight = 1.

getWeightByMovement(_PosX,PosY,_Mx,My,Weight):-
    RightY is PosY+2,
    My =:= RightY,
    Weight = 1.

getWeightByMovement(_PosX,_PosY,_Mx,_My,0).

% PosX - Piece Position X
% PosY - Piece Position Y
% BoardX - Position X on the board after movement
% BoardY - Position Y on the board after movement
% Peg X - Position X to place Peg
% Peg Y - Position Y to place Peg
%
translateBoardPosToPegPos(PosX,PosY,BoardX,BoardY,PegX,PegY):-
    AuxX is BoardX-PosX,
    AuxY is BoardY-PosY,
    PegX is AuxX+3,
    PegY is AuxY+3.

%If the movement jumps over one cell adds 1 point to the score
%Otherwise the score is the original
getPegsScoresByPiece(_Piece,[],_PosX,_PosY,_BalancedWeightBoard,[]).

getPegsScoresByPiece(PieceNumber,[[My,Mx]|M],PosX,PosY,BalancedWeightBoard,[[Score,[PieceNumber,Mx,My]]|Spegs]):-
    getBoardCellValue(BalancedWeightBoard,Mx,My,WeightCell),
    getWeightByMovement(PosX,PosY,Mx,My,Weight),
    Score is WeightCell+Weight,
    getPegsScoresByPiece(PieceNumber,M,PosX,PosY,BalancedWeightBoard,Spegs).

getPegsPosition([[My,Mx]|_M],[],PieceNumber,PosX,PosY,_BalancedWeightBoard,[[0,[PieceNumber,Px,Py]]]):-
    Px is Mx + PosX,
    Py is My + PosY.

getPegsPosition(_Movements,ValidMoves,PieceNumber,PosX,PosY,BalancedWeightBoard,Scores):-
    getPegsScoresByPiece(PieceNumber,ValidMoves,PosX,PosY,BalancedWeightBoard,Scores).

addPegToPieceWithAI(PieceNumber,Piece,Board,ListOfPieces,BalancedWeightBoard,NewListOfPieces):-
    getPieceElementsPositions(getFutureMovementByLine,-2,Piece,[],MovementsAux),
    convertToSimpleList(MovementsAux,Movements),
    valid_moves(Board,PieceNumber,Movements,ValidMoves),
    getMatrixElementPosition(PieceNumber,Board,PosX,PosY),
    getPegsPosition(Movements,ValidMoves,PieceNumber,PosX,PosY,BalancedWeightBoard,Scores),
    getBestChoiceByScore(Scores,_,MovX,MovY),
    translateBoardPosToPegPos(PosX,PosY,MovX,MovY,PegX,PegY),
    updatePieceWithPeg(Piece,PegX,PegY,NewPiece),
    updateListOfPieces(ListOfPieces,PieceNumber,NewPiece,NewListOfPieces).

% No need to test for pieces with full pegs, because the game will end before asking more pegs.
% If the pieces have the same number of Pegs this will fail and the normal strategy will be called
strategyFillPegs([P1,P2],Board,ListOfPieces,BalancedWeightBoard,NewListOfPieces):-
    getPieceByIndex(P1,ListOfPieces,Piece1),
    getPieceByIndex(P2,ListOfPieces,Piece2),
    piecePegSymbol(Ps),
    countElementsOnMatrix(Ps,Piece1,C1),
    countElementsOnMatrix(Ps,Piece2,C2),
    C1>C2,
    addPegToPieceWithAI(P2,Piece2,Board,ListOfPieces,BalancedWeightBoard,NewListOfPieces).

strategyFillPegs([P1,P2],Board,ListOfPieces,BalancedWeightBoard,NewListOfPieces):-
    getPieceByIndex(P1,ListOfPieces,Piece1),
    getPieceByIndex(P2,ListOfPieces,Piece2),
    piecePegSymbol(Ps),
    countElementsOnMatrix(Ps,Piece1,C1),
    countElementsOnMatrix(Ps,Piece2,C2),
    C2>C1,
    addPegToPieceWithAI(P1,Piece1,Board,ListOfPieces,BalancedWeightBoard,NewListOfPieces).


getBestScoreForPiece(PieceNumber,Board,Piece,BalancedWeightBoard,[MaxScore,[PieceNumber,PegX,PegY]]):-
    getPieceElementsPositions(getFutureMovementByLine,-2,Piece,[],MovementsAux),
    convertToSimpleList(MovementsAux,Movements),
    valid_moves(Board,PieceNumber,Movements,ValidMoves),
    getMatrixElementPosition(PieceNumber,Board,PosX,PosY),
    getPegsPosition(Movements,ValidMoves,PieceNumber,PosX,PosY,BalancedWeightBoard,Scores),
    getIndexOfListMap(Scores,Indexes),
    getMaxNumber(Indexes,MaxScore),
    getBestChoiceByScore(Scores,_,MovX,MovY),
    translateBoardPosToPegPos(PosX,PosY,MovX,MovY,PegX,PegY).

getBestPegPosByPiece([],_Board,_ListOfPieces,_BalancedWeightBoard,[]).

getBestPegPosByPiece([P|Pieces],Board,ListOfPieces,BalancedWeightBoard,[ScoreAndMove|Sm]):-
    getPieceByIndex(P,ListOfPieces,Piece),
    getBestScoreForPiece(P,Board,Piece,BalancedWeightBoard,ScoreAndMove),
    getBestPegPosByPiece(Pieces,Board,ListOfPieces,BalancedWeightBoard,Sm).

% This strategy will try to add more distance moves to the pegs, taking into account the biggest
% score in a future move.
strategyGoFurther(Pieces,Board,ListOfPieces,BalancedWeightBoard,NewListOfPieces):-
    getBestPegPosByPiece(Pieces,Board,ListOfPieces,BalancedWeightBoard,ScoreAndMoves),
    getBestChoiceByScore(ScoreAndMoves,PieceNumber,PegX,PegY),
    getPieceByIndex(PieceNumber,ListOfPieces,Piece),
    updatePieceWithPeg(Piece,PegX,PegY,NewPiece),
    updateListOfPieces(ListOfPieces,PieceNumber,NewPiece,NewListOfPieces).



%%%%%%%%%%% TEST %%%%%%%%%%%%%%%%%%%%%%%%%%%%

aiPegsBoardTest( [
                [0,2,3,0,0,0],
                [0,1,9,0,0,0],
                [0,8,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0]
            ]
          ).

aiPegsListOfPiecesMovements([
       [1,[[0,1,0,1,0],[0,0,0,1,0],[0,0,8,1,0],[0,1,0,1,0],[1,0,0,0,1]]],
       [2,[[0,0,0,0,0],[0,0,1,0,0],[0,0,8,0,0],[1,0,0,0,0],[0,0,0,0,0]]],
       [3,[[0,0,0,0,0],[0,0,1,0,0],[0,0,8,0,0],[0,0,1,0,0],[0,0,0,1,0]]],
       [7,[[0,0,0,0,0],[0,0,1,0,0],[0,0,8,0,0],[0,0,0,1,0],[1,1,0,0,0]]],
       [8,[[0,1,0,1,0],[0,0,1,1,0],[0,1,8,1,0],[0,1,0,1,0],[0,1,0,1,0]]],
       [9,[[0,1,0,1,0],[0,1,1,1,0],[0,1,8,0,0],[0,1,0,1,0],[0,1,0,1,0]]]
       ]).

aiPegsBalancedBoardWeight([
                        [71,1,2,47,48,48],
                        [48,3,71,48,48,48],
                        [47,47,47,47,48,48],
                        [47,47,47,47,48,48],
                        [47,48,47,48,48,48],
                        [48,48,48,48,48,48]
                    ]
).

aiGetValidMovesForEmpty([[2,2],[3,2],[1,1],[3,3]]).

aiPieceToAddPeg([
                    [1,1,0,1,0],
                    [0,0,0,1,0],
                    [0,0,8,1,0],
                    [0,1,1,1,0],
                    [1,0,0,0,1]
                ]
            ).

aiPegListPiecesPlayer1([1,2]).
aiPegListPiecesPlayer2([1,2,3]).

%expected 1
testGetWeightByMovement1(Weight):-
    getWeightByMovement(4,3,2,3,Weight).

%expected 0
testGetWeightByMovement2(Weight):-
    getWeightByMovement(4,3,3,3,Weight).

%expected PegX:2 PegY:5
testTranslateBoardPosToPegPos1(PegX,PegY):-
    translateBoardPosToPegPos(4,2,3,4,PegX,PegY).

%expected PegX:2 PegY:3
testTranslateBoardPosToPegPos2(PegX,PegY):-
    translateBoardPosToPegPos(5,4,4,4,PegX,PegY).


testGetPegsScoresByPiece(Scores):-
    aiGetValidMovesForEmpty(Vm),
    aiPegsBalancedBoardWeight(Bw),
    getPegsScoresByPiece(1,Vm,1,2,Bw,Scores).

testAddPegToPieceWithAI:-
    aiPieceToAddPeg(Piece1),
    aiPegsBoardTest(B),
    aiPegsListOfPiecesMovements(Lp),
    aiPegsBalancedBoardWeight(Bw),
    addPegToPieceWithAI(1,Piece1,B,Lp,Bw,NewListOfPieces),
    write(NewListOfPieces).

testStrategyFillPegs:-
    aiPegListPiecesPlayer1(Pp),
    aiPegsBoardTest(B),
    aiPegsListOfPiecesMovements(Lp),
    aiPegsBalancedBoardWeight(Bw),
    strategyFillPegs(Pp,B,Lp,Bw,NewListOfPieces),
    write(NewListOfPieces).

testStrategyGoFurther:-
    aiPegListPiecesPlayer2(Pp),
    aiPegsBoardTest(B),
    aiPegsListOfPiecesMovements(Lp),
    aiPegsBalancedBoardWeight(Bw),
    strategyGoFurther(Pp,B,Lp,Bw,NewListOfPieces),
    write(NewListOfPieces).

