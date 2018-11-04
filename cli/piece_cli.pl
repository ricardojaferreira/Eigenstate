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
