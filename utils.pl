%%%
%Remove elements from list
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
joinLists(L,[],L).
joinLists(L1,[HL2|TL2],[HL2|TL3]):-
    joinLists(L1,TL2,TL3).

