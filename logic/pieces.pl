:-['utils.pl'].

%Max Number of Pieces per Player
numberOfPiecesPerPlayer(6).

%Gives the position of the central cell (Column, Line)
centerLocation(3,3).

checkIfPieceBelongsToPlayer(1,PieceNumber,PieceNumber):-
    PieceNumber>=1,
    PieceNumber=<6.

checkIfPieceBelongsToPlayer(2,PieceNumber,PieceNumber):-
    PieceNumber>=7,
    PieceNumber=<12.

%%%
% The initial state of the pieces.
% 0: Empty space
% 1: Peg
% 8: Piece Position
%%
startPiecePlayer(1, [
                [0,0,0,0,0],
                [0,0,0,0,0],
                [0,0,8,0,0],
                [0,0,1,0,0],
                [0,0,0,0,0]
            ]
          ).

startPiecePlayer(2, [
                [0,0,0,0,0],
                [0,0,1,0,0],
                [0,0,8,0,0],
                [0,0,0,0,0],
                [0,0,0,0,0]
            ]
          ).

startPiecePlayer(3, [
              [1,0,0,0,1],
              [1,0,0,0,0],
              [0,0,8,0,0],
              [1,0,1,0,0],
              [1,0,0,0,1]
          ]
        ).

%indice of first piece
lastPiecePlayer(1,6).
lastPiecePlayer(2,12).

%%%
% Search a list of lists with index and pieces and gives the piece value (list)
% I: Index
%%
getPieceByIndex(I,[[I|[Piece]]|_T],Piece):-
    !.
getPieceByIndex(I,[_H|T],Piece):-
    getPieceByIndex(I,T,Piece).

%%%
% Generate pieces with an Index [[1,Piece1],[2,Piece2],...]
% I: Last Index (The list is created backwards)
% Piece: The List Representing the Piece
% X: Number of pieces to create
% OL: Old List
% NL: New List
% PP: Resulting list of Pieces
%
createPiecesWithIndex(_I,_Piece,0,L,L).

createPiecesWithIndex(I,Piece,X,OL,PP):-
    addNToList([I,Piece],1,OL,NL),
    X1 is X-1,
    I1 is I-1,
    createPiecesWithIndex(I1,Piece,X1,NL,PP).

createPieces(P,X,PP):-
    startPiecePlayer(P, Piece),
    lastPiecePlayer(P,I),
    createPiecesWithIndex(I,Piece,X,[],PP).

initPiecesPlayer(P,PP):-
    numberOfPiecesPerPlayer(X),
    createPieces(P,X,PP).

getPegsByLine(_X,_Y,[],[]):-
    !.

getPegsByLine(X,Y,[1|T],[[Y,X]|Pegs]):-
    Y1 is Y+1,
    getPegsByLine(X,Y1,T,Pegs).

getPegsByLine(X,Y,[_|T],Pegs):-
    Y1 is Y+1,
    getPegsByLine(X,Y1,T,Pegs).

%Returns an array with all the pegs position
%[[Column,Line],[Column,Line],...]
%To translate movement First Line is -2 First Column is -2
getPegsPositions(_X,[],P,[P]):-
    !.

getPegsPositions(X,[H|T],[],Pegs):-
    getPegsByLine(X,-2,H,NewPegLine),
    X1 is X+1,
    getPegsPositions(X1,T,NewPegLine,Pegs).

getPegsPositions(X,[H|T],PrevPegs,[PrevPegs|Pegs]):-
    getPegsByLine(X,-2,H,NewPegLine),
    X1 is X+1,
    getPegsPositions(X1,T,NewPegLine,Pegs).

%%%
% Remove pieces from the ListOfPieces based on a list that contains
% the pieces still present on the board.
%%
searchPieceOnList([],_X,[]).

searchPieceOnList([N|_X],[N|T],[N|T]).

searchPieceOnList([N|T],[L1|T1],H):-
    searchPieceOnList(T,[L1|T1],H).

removeExtraPieces(List,[],[]).

removeExtraPieces(List,[Piece|T1],[H|T2]):-
    searchPieceOnList(List,Piece,H),
    removeExtraPieces(List,T1,T2).

updatePieceList(Board,ListOfPieces,NewListOfPieces):-
    getListOfPiecesOnBoard(Board, ListAux),
    convertToSimpleList(ListAux,List),
    removeExtraPieces(List,ListOfPieces,LAux),
    removeEmptyElementsFromList(LAux,NewListOfPieces).


movePiece(Player,PieceToMove,ListOfPieces,Board,NewListOfPieces,NewBoard):-
    getBoardCellPosition(Board,PieceToMove,1,1,Line,Column),
    getPieceByIndex(PieceToMove,ListOfPieces,Piece),
    getPegsPositions(-2,Piece,[],Pegs),
    convertToSimpleList(Pegs,PegsPositions),
    getPositionToMove(Player,PegsPositions,Line,Column,PosX,PosY),!,
    movePieceOnBoard(Board,PieceToMove,PosX,PosY,NewBoard),
    updatePieceList(Board,ListOfPieces,NewListOfPieces).

getPositionToMove(Player,PegsPosition,Line,Column,PosX,PosY):-
    askPlayerToChooseACellToMove(Player,X,Y),
    checkIfIsAValidMovement(Player,PegsPosition,Line,Column,X,Y,PosX,PosY).

checkIfIsAValidMovement(_Player,PegsPositions,Line,Column,PosX,PosY,PosX,PosY):-
        MovementX is PosX-Line,
        MovementY is PosY-Column,
        checkIfExists([MovementY,MovementX],PegsPositions).

checkIfIsAValidMovement(Player,PegsPositions,Line,Column,_X,_Y,PosX,PosY):-
    showErrorPieceCannotBeMovedToThatLocation,
    getPositionToMove(Player,PegsPositions,Line,Column,PosX,PosY).

addPegToPiece(Player,Board,ListOfPieces,NewListOfPieces):-
    askPlayerToChooseAPieceToAddPeg(Player,PosX,PosY),
    checkBoardCellChoice(Player,Board,PosX,PosY,PieceToAddPeg),
    getPieceByIndex(PieceToAddPeg,ListOfPieces,Piece),
    printOnePiece(Player,Piece).
