:-['printutils.pl'].
:-['../logic/pieces.pl'].

translatePieceCell(0,'O').
translatePieceCell(1,'*').
translatePieceCell(8,'@').

getPlayerByIndex(I,P1,_P2,1):-
    I=<P1.

getPlayerByIndex(I,_P1,P2,2):-
        I=<P2.

getPlayerColor(I,Color):-
    lastPiecePlayer(1,P1),
    lastPiecePlayer(2,P2),
    getPlayerByIndex(I,P1,P2,P),
    playerColor(P,Color).

getPieceValue(I,ListOfPieces,Result,Color):-
    getPieceByIndex(I,ListOfPieces,Result),
    getPlayerColor(I,Color).

printPieceLine([],_Color).

printPieceLine([H|T],Color):-
    translatePieceCell(H,P),
    ansi_format([fg(Color)],'~w',[P]),
    write(' '),
    printPieceLine(T,Color).

printPiece(0,_X,Color):-
    ansi_format([fg(Color)],'~w',['+-----------+ ']).

printPiece(6,_X,Color):-
    ansi_format([fg(Color)],'~w',['+-----------+ ']).

printPiece(L,Piece,Color):-
    ansi_format([fg(Color)],'~w',['| ']),
    L1 is L-1,
    discardElementsFromList(Piece,L1,[Line|_T]),
    printPieceLine(Line,Color),
    ansi_format([fg(Color)],'~w',['| ']).

showErrorPieceDoesNotBelongToPlayer:-
    errorFontColor(Color),
    ansi_format([fg(Color)],'~w',['This cell does not have one of your pieces.']),
    nl.

showErrorPieceCannotBeMovedToThatLocation:-
    errorFontColor(Color),
    ansi_format([fg(Color)],'~w',['This piece cannot to go that position.']),
    nl.

%     A B C D E
%   +-----------+
% 1 | 0 0 0 0 0 |
% 2 | 0 0 0 0 0 |
% 3 | 0 0 @ 0 0 |
% 4 | 0 0 1 0 0 |
% 5 | 0 0 0 0 0 |
%   +-----------+

printPieceByLine(0,Piece,Color):-
    write('  '),
    printPiece(0,Piece,Color),
    nl,
    printPieceByLine(1,Piece,Color).

printPieceByLine(6,Piece,Color):-
    write('  '),
    printPiece(6,Piece,Color),
    nl.

printPieceByLine(L,Piece,Color):-
    ansi_format([bold,fg(white)],'~w~w',[L,' ']),
    printPiece(L,Piece,Color),
    nl,
    L1 is L+1,
    printPieceByLine(L1,Piece,Color).

printOnePiece(Player,Piece):-
    nl,
    playerColor(Player,Color),
    ansi_format([bold,fg(white)],'~w',['    A B C D E ']),
    nl,
    printPieceByLine(L,Piece,Color).