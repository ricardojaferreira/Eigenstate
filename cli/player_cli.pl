:-['printutils.pl'].

% This translation is a bit hardcoded, should the cli know about the logic states?
printChoice(0, '0: Human').
printChoice(1, '1: Computer').

%%%
% Print a list of values.
% In this case is the players type
% Maybe this function should pass to printutils
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
    read(Choice).

askPlayerToChooseAgain(Types, Choice):-
    nl,
    errorFontColor(EColor),
    ansi_format([fg(EColor)],'~w',['Please choose one of the available options:']),
    nl,
    displayPlayerTypes(Types),
    nl,
    read(Choice).


showPlayerTypes(Type1, Type2):-
    factFontColor(FactColor),
    ansi_format([fg(FactColor)],'~w~w~w',['Player 1 is ',Type1,'.']),
    nl,
    ansi_format([fg(FactColor)],'~w~w~w',['Player 2 is ',Type2,'.']).