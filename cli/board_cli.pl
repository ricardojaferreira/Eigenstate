:-['printutils.pl'].
:-['piece_cli.pl'].

boardCell(1,0,': : : : : : :').
boardCell(0,0,'             ').

%%%
% Print each cell of the board
% 0 means empty cell
%%
boardColumn(_C,_L,[],_List).

boardColumn(N,L,[0|T],ListOfPieces):-
    OE is mod(N,2),
    boardCell(OE,0,Print),
    write(Print),
    write(' '),
    N1 is 1+N,
    boardColumn(N1,L,T,ListOfPieces).

boardColumn(N,L,[H|T],ListOfPieces):-
    getPieceValue(H,ListOfPieces,Result,Color),
    printPiece(L,Result,Color),
    N1 is 1+N,
    boardColumn(N1,L,T,ListOfPieces).

%%%
% Print each line of the board. [0,0,0,0,0,0]
%
%%
boardLine(_Z,[],_List).

boardLine(C,[H|T],ListOfPieces):-
    Column is 1+C,
    borderColor(BColor),

    ansi_format([fg(BColor)],'~w',['  :']),
    boardColumn(Column,0,H,ListOfPieces),
    ansi_format([fg(BColor)],'~w',[':']),
    nl,

    ansi_format([fg(BColor)],'~w',['  :']),
    boardColumn(Column,1,H,ListOfPieces),
    ansi_format([fg(BColor)],'~w',[':']),
    nl,

    ansi_format([fg(BColor)],'~w',['  :']),
    boardColumn(Column,2,H,ListOfPieces),
    ansi_format([fg(BColor)],'~w',[':']),
    nl,

    ansi_format([bold,fg(white)],'~w',[Column]),
    ansi_format([fg(BColor)],'~w',[' :']),
    boardColumn(Column,3,H,ListOfPieces),
    ansi_format([fg(BColor)],'~w',[':']),
    nl,

    ansi_format([fg(BColor)],'~w',['  :']),
    boardColumn(Column,4,H,ListOfPieces),
    ansi_format([fg(BColor)],'~w',[':']),
    nl,

    ansi_format([fg(BColor)],'~w',['  :']),
    boardColumn(Column,5,H,ListOfPieces),
    ansi_format([fg(BColor)],'~w',[':']),
    nl,

    ansi_format([fg(BColor)],'~w',['  :']),
    boardColumn(Column,6,H,ListOfPieces),
    ansi_format([fg(BColor)],'~w',[':']),
    nl,

    boardLine(Column,T,ListOfPieces).


printBoard(Board,ListOfPieces):-
    nl,
    ansi_format([bold,fg(white)],'~w',['         A             B             C             D             E             F        ']),
    print_char(border,':',88),
    boardLine(0,Board,ListOfPieces),
    print_char(border,':',88).
