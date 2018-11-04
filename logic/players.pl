:-['../cli/player_cli.pl'].

playerTypesAvailable([0,1]).

playerType(0,human).
playerType(1,computer).

%%%
% Checks if the player is one of the availables
%%
isPlayerTypeAvailable(Type,[Type|_T]).

isPlayerTypeAvailable(Type,[_X|T]):-
    isPlayerTypeAvailable(Type,T).

%%%
% Checks the type chosen by the user
%%
checkType(Type,[Type|_T]):-
    playerTypesAvailable(Types),
    isPlayerTypeAvailable(Type, Types).

checkType(_Z,Result):-
    playerTypesAvailable(Types),
    askPlayerToChooseAgain(Types, Choice),
    checkType(Choice,Result).

%%%
% Sets the player type if it is valid.
% If not valid this will run in cycle until a valid option is chosen.
%%
setPlayer(Type, Player):-
    playerTypesAvailable(Types),
    askPlayerToChoose(Player,Types,X),
    checkType(X,[Type|_T]).

%%%
% Shows the type of each player
showPlayers(P1,P2):-
    playerType(P1, Type1),
    playerType(P2, Type2),
    showPlayerTypes(Type1, Type2).

%
%playerChoosePieceToMove(Player, LocationX, LocationY):-
%    inGameColor(IgColor),
%    nl,
%    ansi_format([fg(IgColor)],'~w~w~w',['Player ',Player,' choose a piece to move (Letter, Number)']),
%    nl,
%    ansi_format([fg(IgColor)],'~w',['Letter: ']),
%    read(LocationY),
%    ansi_format([fg(IgColor)],'~w',['Number: ']),
%    read(LocationX).
