printChoice(0, '0: Human').
printChoice(1, '1: Computer Random').
printChoice(2, '2: Computer AI').

%%%
% Print a list of values.
% In this case is the players type
%%
displayPlayerTypes([]).

displayPlayerTypes([Type|Types]):-
    printChoice(Type,C),
    write(C),
    nl,
    displayPlayerTypes(Types).

%%%
% Asks the player to choose a player type and reads the response
%%
askPlayerToChoose(Player, Types, Choice):-
    questionFontColor(QColor),
    nl,
    ansi_format([fg(QColor)],'~w~w~w',['Please choose Player ',Player,' :']),
    nl,
    displayPlayerTypes(Types),
    nl,
    readln(Choice).

askPlayerToChooseAgain(Types, Choice):-
    nl,
    errorFontColor(EColor),
    ansi_format([fg(EColor)],'~w',['Please choose one of the available options:']),
    nl,
    displayPlayerTypes(Types),
    nl,
    readln(Choice).

askPlayerToChooseNewLetter(Size,NewLetter):-
    nl,
    inGameColor(IgColor),
    ansi_format([fg(IgColor)],'~w',['Invalid Option, please choose another.']),
    nl,
    ansi_format([fg(IgColor)],'~w',['Letter: ']),
    readln(Letter),
    checkLetter(Letter,Size,NewLetter).

askPlayerToChooseNewNumber(Size,NewNumber):-
    nl,
    inGameColor(IgColor),
    ansi_format([fg(IgColor)],'~w',['Invalid Option, please choose another.']),
    nl,
    ansi_format([fg(IgColor)],'~w',['Number: ']),
    readln(Number),
    checkNumber(Number,Size,NewNumber).

%%%
% This function checks the validity of the choices. It is a very simple logic,
% and performed here to avoid complexity on other parts of the code.
% That said, the CLI must ensure that the choice respects the boundaries of the board.
%%

askPlayerToChoosePieceToMove(Player,Size,PosX,PosY):-
    askPlayerToChooseCell(Player,Size,'piece to move',PosX,PosY),
    !.

askPlayerToChooseACellToMove(Player,Size,PosX,PosY):-
    askPlayerToChooseCell(Player,Size,'cell to move the piece',PosX,PosY),
    !.

askPlayerToChooseAPieceToAddPeg(Player,Size,PosX,PosY):-
    askPlayerToChooseCell(Player,Size,'piece to add a peg',PosX,PosY),
    !.

askPlayerToChooseAPegPosition(Player,Size,PosX,PosY):-
    askPlayerToChooseCell(Player,Size,'position for the new peg',PosX,PosY),
        !.

askPlayerToChooseCell(Player,Size,Select,PosX,PosY):-
    inGameColor(IgColor),
    nl,
    ansi_format([fg(IgColor)],'~w~w~w~w~w',['Player ',Player,' select a ',Select,'.']),
    nl,
    ansi_format([fg(IgColor)],'~w',['Letter: ']),
    readln(Letter),
    checkLetter(Letter,Size,PosY),
    ansi_format([fg(IgColor)],'~w',['Number: ']),
    readln(Number),
    checkNumber(Number,Size,PosX).

showPlayerTypes(Type1, Type2):-
    factFontColor(FactColor),
    ansi_format([fg(FactColor)],'~w~w~w',['Player 1 is ',Type1,'.']),
    nl,
    ansi_format([fg(FactColor)],'~w~w~w',['Player 2 is ',Type2,'.']).

waitForPlayerMove(Player):-
    inGameColor(C),
    ansi_format([fg(C)],'~w~w~w',['Player ',Player,' - Press enter to Move.']),
    readln(_).

waitForPlayerToAddPeg(Player):-
    inGameColor(C),
    ansi_format([fg(C)],'~w~w~w',['Player ',Player,' - Press enter to add peg.']),
    readln(_).