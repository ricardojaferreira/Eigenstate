f(X,Y):-Y is X*X.
duplica(X,Y):-Y is 2*X.

map([],_,[]).

map([H|T],Transfor,[R|M]):-
    aplica(Transfor,[H,R]),
    map(T,Transfor,M).

aplica(P,LArgs):- G=.. [P|LArgs], G.