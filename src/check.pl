%
% Part 1: check whether a list of dice is nontransitive
%

%% Entrypoint

% Remember the first dice
check_dice([D | Ds]) :- check_dice_aux(D, [D | Ds]).

% First argument is the first dice of the cycle
check_dice_aux(First, [Last]) :- beats(Last, First).
check_dice_aux(First, [A1 | [A2 | L]]) :-
   beats(A1, A2),
   check_dice_aux(First, [A2 | L]).


%% P[A > B] > 1/2

% Victs = Card { (a, b) | a in A, b in B, a > b }
% Victs > len(A)/2
beats(A, B) :-
   victories_of_A(A, B, Victs),
   length(A, S),
   Victs > (S * S) // 2.


%% Card { (a, b) | a in A, b in B, a > b }
victories_of_A([], _, 0).
victories_of_A([A0 | A], B, Victs) :-
   victories_of_A(A, B, VictsPartial),
   victories_of_A_aux(B, A0, Victs, VictsPartial).

victories_of_A_aux([], _, V, V).
victories_of_A_aux([B0 | B], A0, Victs, VictsPartial) :-
   victories_of_A_aux(B, A0, VictsMinus1, VictsPartial),
   (
      A0 > B0
   ->
      Victs is VictsMinus1 + 1
   ;
      Victs = VictsMinus1
   ).
