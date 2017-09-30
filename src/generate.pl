:- use_module(library(clpfd)).
:- use_module(misc).

dice(A, B, C) :-
   set_range(A, 1, 10),
   set_range(A, 1, 10),
   set_range(C, 1, 10),
   beats(A, B),
   beats(B, C),
   beats(C, A).

set_range([], Min, Max).
set_range([X | Xs], Min, Max) :- X #>= Min, X #< Max, set_range(Xs, Min, Max).

% FIXME: code duplication (higher order can fix it?)
beats(A, B) :-
   combine(A, B, Comb),
   a_wins_b_wins(Comb, Awins, Bwins),
   Awins #> Bwins.

% FIXME: code duplication (higher order can fix it?)
a_wins_b_wins([], 0, 0).
a_wins_b_wins([[X, Y] | Comb], Awins, Bwins) :-
   X #> Y,
   a_wins_b_wins(Comb, Awins_minus_1, Bwins),
   Awins #= 1 + Awins_minus_1.
a_wins_b_wins([[X, Y] | Comb], Awins, Bwins) :-
   X #< Y,
   a_wins_b_wins(Comb, Awins, Bwins_minus_1),
   Bwins #= 1 + Bwins_minus_1.
