:-['printutils.pl'].
playerType(0,human).
playerType(1,computer).


displayPlayerTypes:-
    write('0: Human'), nl,
    write('1: Computer'), nl.

checkType(Type,[Type|_T]):-
    Type >= 0,
    Type =< 1.

checkType(_Z,Result):-
    nl,
    write('Please choose 0 for Human or 1 for computer'),
    nl,
    read(NewType),
    checkType(NewType, Result).

setPlayer(Type, Player):-
    questionFontColor(QColor),
    nl,
    ansi_format([fg(QColor)],'~w~w~w',['Please choose Player ',Player,' :']),
    nl,
    displayPlayerTypes,
    read(X),
    checkType(X, [Type|_T]).

translateType(X,Y,Color):-
    playerType(X,Y),
    ansi_format([fg(Color)],'~w',[Y]).



