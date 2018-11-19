:- multifile prolog:message/1.
:- multifile user:message_property/2.

%define color for message types
user:message_property(banner, color([fg(blue)])).
user:message_property(status, color([fg(green)])).
user:message_property(border, color([fg(magenta)])).

%Font colors for ansi
questionFontColor(blue).
factFontColor(green).
gameOverFontColor(blue).
errorFontColor(red).
borderColor(magenta).
playerColor(1,green).
playerColor(2,red).
inGameColor(white).


%for printing the same character over and over again
print_char(X, Y, 1) :-
    print_message(X, single_line(Y)).

print_char(X,Y,Z) :-
    Z > 1,
    Z1 is Z-1,
    sub_atom(Y,0,1,_A,S),
    atom_concat(Y,S,Y1),
    print_char(X,Y1,Z1).


%information messages
prolog:message(single_line(Message)) -->
    [
        '~w'-[Message]
    ].