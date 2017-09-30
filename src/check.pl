%
% Part 1: check wether a set of dice is nontransitive
%

:- use_module(misc).

%% Entrypoint

% Remember the first dice
check_dice([A | L]) :- check_dice_aux(A, [A | L]).

% First argument is the first dice of the cycle
check_dice_aux(Fst, [Last]) :- beats(Last, Fst).
check_dice_aux(Fst, [A1 | [A2 | L]]) :-
   beats(A1, A2),
   check_dice_aux(Fst, [A2 | L]).



%% A beats B with probability > 1/2

% Generate all scenarios (pairs of faces) and see if A wins more often than B
beats(A, B) :-
   combine(A, B, Comb),
   a_wins_b_wins(Comb, Awins, Bwins),
   Awins > Bwins.

% Counts the number of pairs [a, b] in Comb s.t. a > b (resp. b > a)
a_wins_b_wins([], 0, 0).
a_wins_b_wins([[X, Y] | Comb], Awins, Bwins) :-
   X > Y,
   a_wins_b_wins(Comb, Awins_minus_1, Bwins),
   Awins is 1 + Awins_minus_1.
a_wins_b_wins([[X, Y] | Comb], Awins, Bwins) :-
   X < Y,
   a_wins_b_wins(Comb, Awins, Bwins_minus_1),
   Bwins is 1 + Bwins_minus_1.
