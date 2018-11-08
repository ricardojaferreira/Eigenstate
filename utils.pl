%%%
%Remove elements from list
% List
% N: number of elements to discard
% Result: Resulting List
%%
discardElementsFromList(X,0,X).
discardElementsFromList([_|T],N,Result):-
    N1 is N-1,
    discardElementsFromList(T,N1,Result).

%%%
%Add N elements to the end of the List
% E: Element
% N: Number os elements to add (all equal)
% L: Original List
% R: Resulting List
%%
addNToList(_E,0,L,L).
addNToList(E,N,L,R):-
    N1 is N-1,
    addNToList(E,N1,[E|L],R).

%%%
% Add element to end of list
%%
addToListEnd(X,[],[X]).
addToListEnd(X,[Y|Tail1],[Y|Tail2]):-
    add(X,Tail1,Tail2).

%%%
% Join two lists
% Join List L1 to List L2
%%
joinLists(L,[],L):-
    !.
joinLists(L1,[HL2|TL2],[HL2|TL3]):-
    joinLists(L1,TL2,TL3).


%%
% Convert a list like this [[[a],[b]],[[c],[d]]] to something like this
% [[a],[b],[c],[d]]
%
convertToSimpleList(Pegs,Result):-
    convertToSimpleListAux(Pegs,_Aux,Result),!.

convertToSimpleListAux([],R,R):-
    !.
convertToSimpleListAux([H|T],R,RR):-
    joinLists(H,R,Result),
    convertToSimpleListAux(T,Result,RR).


%%%
% Check if Element belongs to list
%%
checkIfExists(_Element,[]):-
    fail.
checkIfExists(Element,[Element|_T]).
checkIfExists(Element,[_H|T]):-
    checkIfExists(Element,T).

%%%
% Duplicate a list to another variable
%%
duplicateList([H|T],[H|T]).

%%%
% Replace E with NE and returns a new list with the replacement.
%%
replaceElementInList(_E,_NE,[],[]).

replaceElementInList(E,NE,[E|T],[NE|R]):-
    replaceElementInList(E,NE,T,R).

replaceElementInList(E,NE,[H|T],[H|R]):-
    replaceElementInList(E,NE,T,R).

%%%
% Replace element at Position with the element E.
% The rest of the list remains the same.
%%
replaceElementAtPosition(_E,_P,[],[]).

replaceElementAtPosition(E,1,[_H|T],[E|T]).

replaceElementAtPosition(E,Position,[H|T],[H|R]):-
    P is Position-1,
    replaceElementAtPosition(E,P,T,R).

%%
% Remove empty elements from lists
%%
removeEmptyElementsFromList([],[]).

removeEmptyElementsFromList([[]|T1],List):-
    removeEmptyElementsFromList(T1,List).

removeEmptyElementsFromList([L1|T1],[L1|T2]):-
    removeEmptyElementsFromList(T1,T2).