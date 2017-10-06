:- use_module(library(clpfd)).
:- use_module(misc).
:- use_module(misc_fd).

dice(N, S, L) :-
   length(L, N), all_of_length(L, S),
   Inf #= 1, Sup #= N + S, all_ins_domain(L, Inf, Sup),
   cycle(L),
   flatten(L, FL), label(FL).

all_of_length([], _S).
all_of_length([X | Xs], S) :- len(X, S), all_of_length(Xs, S).

cycle([Fst | L]) :- cycle_aux(Fst, [Fst | L]).

cycle_aux(Fst, [Last]) :- beats(Last, Fst).
cycle_aux(Fst, [A | [B | L]]) :- beats(A, B), cycle_aux(Fst, [B | L]).

beats(A, B) :-
   combine(A, B, Comb),
   a_wins_b_wins(Comb, Awins, Bwins),
   Awins #> Bwins.

a_wins_b_wins([], 0, 0).
a_wins_b_wins([[X, Y] | Comb], Awins, Bwins) :-
   X #> Y,
   a_wins_b_wins(Comb, Awins_minus_1, Bwins),
   Awins #= 1 + Awins_minus_1.
a_wins_b_wins([[X, Y] | Comb], Awins, Bwins) :-
   X #< Y,
   a_wins_b_wins(Comb, Awins, Bwins_minus_1),
   Bwins #= 1 + Bwins_minus_1.
