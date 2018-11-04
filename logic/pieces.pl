:-['utils.pl'].

%Max Number of Pieces per Player
numberOfPiecesPerPlayer(6).

%%%
% The initial state of the pieces.
% 0: Empty space
% 1: Peg
% 8: Piece Position
%%
startPiecePlayer(1, [
                [0,0,0,0,0],
                [0,0,0,0,0],
                [0,0,8,0,0],
                [0,0,1,0,0],
                [0,0,0,0,0]
            ]
          ).

startPiecePlayer(2, [
                [0,0,0,0,0],
                [0,0,1,0,0],
                [0,0,8,0,0],
                [0,0,0,0,0],
                [0,0,0,0,0]
            ]
          ).

%indice of first piece
lastPiecePlayer(1,6).
lastPiecePlayer(2,12).

%%%
% Search a list of lists with index and pieces and gives the piece value (list)
% I: Index
%%
getPieceByIndex(I,[[I|[Piece]]|_T],Piece).
getPieceByIndex(I,[_H|T],Piece):-
    getPieceByIndex(I,T,Piece).

%%%
% Generate pieces with an Index [[1,Piece1],[2,Piece2],...]
% I: Last Indice (The list is created backwards)
% Piece: The List Representing the Piece
% X: Number of pieces to create
% OL: Old List
% NL: New List
% PP: Resulting list of Pieces
%
createPiecesWithIndex(_I,_Piece,0,L,L).

createPiecesWithIndex(I,Piece,X,OL,PP):-
    addNToList([I,Piece],1,OL,NL),
    X1 is X-1,
    I1 is I-1,
    createPiecesWithIndex(I1,Piece,X1,NL,PP).

createPieces(P,X,PP):-
    startPiecePlayer(P, Piece),
    lastPiecePlayer(P,I),
    createPiecesWithIndex(I,Piece,X,[],PP).

initPiecesPlayer(P,PP):-
    numberOfPiecesPerPlayer(X),
    createPieces(P,X,PP).
