:-['../cli/board_cli.pl'].
:-['pieces.pl'].

boardLines(6).
boardColumns(6).

%boardCell(1,'0',': : : : : : :').
%boardCell(0,'0','             ').

%%%
% An empty Board without any pice
%%
emptyBoard( [
                [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0]
            ]
          ).

%%%
% The starting board.
% 0: Empty cell
% 1-6: Player 1 pieces
% 7-12: Player 2 pieces
%%
startBoard( [
                [1,2,3,4,5,6],
                [0,0,0,0,0,0],
                [0,0,0,6,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [7,8,9,10,11,12]
            ]
          ).