%
% Part 1: check wether a set of dice is nontransitive
%


%% Entrypoint

% Look for a cycle involving the two first dice
check_dice([A1 | [A2 | L]]) :- beats(A1, A2), look_for_cycle_with(A1, A2, L).
check_dice([A1 | [A2 | L]]) :- beats(A2, A1), look_for_cycle_with(A2, A1, L).

% Drop a dice and retry
check_dice([_A | L]) :- check_dice(L).



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



%% Assuming beats(A, B), look for a C in the third argument s.t. (A, B, C)
%  form a cycle.
look_for_cycle_with(A, B, [C | _L]) :- beats(B, C), beats(C, A).
look_for_cycle_with(A, B, [_H | L]) :- look_for_cycle_with(A, B, L).



%
% Helper functions
%

%% combine(Xs, Ys, Comb) <=> Comb = [[X,Y] for X in Xs, Y in Ys]

combine([], _Ys, []).
combine([X | Xs], Ys, Comb) :-
   combine(Xs, Ys, Comb_partial),
   combine_aux(X, Ys, Comb, Comb_partial).

% combine_aux(X, Ys, Tot, Partial) <=> Tot = [[X, Y] for Y in Ys] ++ Partial
combine_aux(_X, [], L, L).
combine_aux(X, [Y | Ys], [[X, Y] | Comb], Comb_partial) :-
   combine_aux(X, Ys, Comb, Comb_partial).
