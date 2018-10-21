:-['printutils.pl'].
:-['utils.pl'].

emptyBoard( [
                ['e','e','e','e','e','e'],
                ['e','e','e','e','e','e'],
                ['e','e','e','e','e','e'],
                ['e','e','e','e','e','e'],
                ['e','e','e','e','e','e'],
                ['e','e','e','e','e','e']
            ]
          ).

startBoard( [
                ['b1','b2','b3','b4','b5','b6'],
                ['e','e','e','e','e','e'],
                ['e','e','e','e','e','e'],
                ['e','e','e','e','e','e'],
                ['e','e','e','e','e','e'],
                ['a1','a2','a3','a4','a5','a6']
            ]
          ).

startPiecePlayer1( [
                ['o','o','o','o','o'],
                ['o','o','*','o','o'],
                ['o','o','@','o','o'],
                ['o','o','o','o','o'],
                ['o','o','o','o','o']
            ]
          ).

startPiecePlayer2( [
                ['o','o','o','o','o'],
                ['o','o','o','o','o'],
                ['o','o','@','o','o'],
                ['o','o','*','o','o'],
                ['o','o','o','o','o']
            ]
          ).


boardCell(1,'e',': : : : : : :').
boardCell(0,'e','             ').


a1(X):-
    startPiecePlayer1(X).
a2(X):-
    startPiecePlayer1(X).
a3(X):-
    startPiecePlayer1(X).
a4(X):-
    startPiecePlayer1(X).
a5(X):-
    startPiecePlayer1(X).
a6(X):-
    startPiecePlayer1(X).

b1(X):-
    startPiecePlayer2(X).
b2(X):-
    startPiecePlayer2(X).
b3(X):-
    startPiecePlayer2(X).
b4(X):-
    startPiecePlayer2(X).
b5(X):-
    startPiecePlayer2(X).
b6(X):-
    startPiecePlayer2(X).


getPieceValue('a1',Result,Color):-
    a1(Result),
    player1Color(Color).

getPieceValue('a2',Result,Color):-
    a2(Result),
    player1Color(Color).

getPieceValue('a3',Result,Color):-
    a3(Result),
    player1Color(Color).

getPieceValue('a4',Result,Color):-
    a4(Result),
    player1Color(Color).

getPieceValue('a5',Result,Color):-
    a5(Result),
    player1Color(Color).

getPieceValue('a6',Result,Color):-
    a6(Result),
    player1Color(Color).

getPieceValue('b1',Result,Color):-
    b1(Result),
    player2Color(Color).

getPieceValue('b2',Result,Color):-
    b2(Result),
    player2Color(Color).

getPieceValue('b3',Result,Color):-
    b3(Result),
    player2Color(Color).

getPieceValue('b4',Result,Color):-
    b4(Result),
    player2Color(Color).

getPieceValue('b5',Result,Color):-
    b5(Result),
    player2Color(Color).

getPieceValue('b6',Result,Color):-
    b6(Result),
    player2Color(Color).

printPieceLine([],_Color).

printPieceLine([H|T],Color):-
    ansi_format([fg(Color)],'~w',[H]),
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


getCellType([H|_T],H).

%%% LINES EMPTY
boardColumn(_C,_L,[]).

boardColumn(N,L,['e'|T]):-
    OE is mod(N,2),
    boardCell(OE,'e',Print),
    write(Print),
    write(' '),
    N1 is 1+N,
    boardColumn(N1,L,T).

boardColumn(N,L,[H|T]):-
    getPieceValue(H,Result,Color),
    printPiece(L,Result,Color),
    N1 is 1+N,
    boardColumn(N1,L,T).

%%%%%% Columns
boardLine(_Z,[]).

boardLine(C,[H|T]):-
    Column is 1+C,
    borderColor(BColor),

    ansi_format([fg(BColor)],'~w',['  :']),
    boardColumn(Column,0,H),
    ansi_format([fg(BColor)],'~w',[':']),
    nl,

    ansi_format([fg(BColor)],'~w',['  :']),
    boardColumn(Column,1,H),
    ansi_format([fg(BColor)],'~w',[':']),
    nl,

    ansi_format([fg(BColor)],'~w',['  :']),
    boardColumn(Column,2,H),
    ansi_format([fg(BColor)],'~w',[':']),
    nl,

    ansi_format([bold,fg(white)],'~w',[Column]),
    ansi_format([fg(BColor)],'~w',[' :']),
    boardColumn(Column,3,H),
    ansi_format([fg(BColor)],'~w',[':']),
    nl,

    ansi_format([fg(BColor)],'~w',['  :']),
    boardColumn(Column,4,H),
    ansi_format([fg(BColor)],'~w',[':']),
    nl,

    ansi_format([fg(BColor)],'~w',['  :']),
    boardColumn(Column,5,H),
    ansi_format([fg(BColor)],'~w',[':']),
    nl,

    ansi_format([fg(BColor)],'~w',['  :']),
    boardColumn(Column,6,H),
    ansi_format([fg(BColor)],'~w',[':']),
    nl,

    boardLine(Column,T).

printBoard:-
    nl,
    ansi_format([bold,fg(white)],'~w',['         A             B             C             D             E             F        ']),
    print_char(border,':',88),
    startBoard(X),
    boardLine(0,X),
    print_char(border,':',88).