
%Remove elements from list
discardElementsFromList(X,0,X).

discardElementsFromList([_|T],N,Result):-
    N1 is N-1,
    discardElementsFromList(T,N1,Result).
