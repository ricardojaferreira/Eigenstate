:-['../cli/board_cli.pl'].
:-['pieces.pl'].

boardLines(6).
boardColumns(6).
boardSquareSize(6).

%boardCell(1,'0',': : : : : : :').
%boardCell(0,'0','             ').

%%%
% An empty Board without any pice
%%
emptyBoard( [
                [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0]
            ]
          ).

%%%
% The starting board.
% 0: Empty cell
% 1-6: Player 1 pieces
% 7-12: Player 2 pieces
%%
startBoard( [
                [1,2,3,4,5,6],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [7,8,9,10,11,12]
            ]
          ).

getBoardCellValue(Board,PosX,PosY,Value):-
    X1 is PosX-1,
    discardElementsFromList(Board,X1,[Line|_]),
    Y1 is PosY-1,
    discardElementsFromList(Line,Y1,[Value|_]).

searchPieceByLine([],_,_,_,_,_).
searchPieceByLine([H|_T],H,X,Y,X,Y).
searchPieceByLine([_H|T],Piece,X,Y,Line,Column):-
    Y1 is Y+1,
    searchPieceByLine(T,Piece,X,Y1,Line,Column).

incrementLine(StartX,Line,Column,StartX):-
    nonvar(Line),
    nonvar(Column).

incrementLine(StartX,_Line,_Column,NewX):-
    NewX is StartX+1.

getBoardCellPosition(_B,_P,_X,_Y,Column,Line):-
    nonvar(Column),
    nonvar(Line).

getBoardCellPosition([BoardLine|T],PieceToMove,StartX,StartY,Line,Column):-
    searchPieceByLine(BoardLine,PieceToMove,StartX,StartY,Line,Column),
    incrementLine(StartX,Line,Column,NewX),
    getBoardCellPosition(T,PieceToMove,NewX,StartY,Line,Column).


%%%
% The CLI must ensure that PosX and PosY are within the boundaries.
%%
checkBoardCellChoice(Player,Board,PosX,PosY,PieceToMove):-
    getBoardCellValue(Board,PosX,PosY,PieceNumber),
    checkIfPieceBelongsToPlayer(Player,PieceNumber),
    PieceNumber=PieceToMove.

checkBoardCellChoice(Player,Board,_PosX,_PosY,PieceToMove):-
    showErrorPieceDoesNotBelongToPlayer,
    choosePieceToMove(Player,Board,PieceToMove).

movePieceOnBoard([],_P,_X,_Y,[]).

movePieceOnBoard([BoardLine|Rest],PieceToMove,1,PosY,[NewBoardH|Rest]):-
    replaceElementInList(PieceToMove,0,BoardLine,NewLine),
    replaceElementAtPosition(PieceToMove,PosY,NewLine,NewBoardH).

movePieceOnBoard([BoardLine|Rest],PieceToMove,PosX,PosY,[NewLine|T]):-
    replaceElementInList(PieceToMove,0,BoardLine,NewLine),
    Px is PosX-1,
    movePieceOnBoard(Rest,PieceToMove,Px,PosY,T).


searchPiecesOnLine([],[]).

searchPiecesOnLine([0|T],List):-
    searchPiecesOnLine(T,List).

searchPiecesOnLine([Pnumber|T],[Pnumber|X]):-
    searchPiecesOnLine(T,X).

getListOfPiecesOnBoard([],[]).

getListOfPiecesOnBoard([BoardLine|T],[HList|TList]):-
    searchPiecesOnLine(BoardLine,HList),
    getListOfPiecesOnBoard(T,TList).