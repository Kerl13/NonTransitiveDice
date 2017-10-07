:- use_module(library(clpfd)).


%% Entrypoint

% Problem constrains:
% - L has length N
% - for each die in L, length(die) = S
% - non_transitive
%
% Helping prolog to solve the problem:
% - order every die
% - one might assume that the first side of the first die is 1
% - There exists solution with faces in 1..N+3
dice(N, S, L) :-
   flatten(L, FlatL),

   length(L, N),
   set_len_and_order(L, S),
   nth0(0, FlatL, 1),
   Sup is N + 3, FlatL ins 1..Sup,

   non_transitive(L, S),
   labeling([ff], FlatL).


% All dice have length S and are ordered
set_len_and_order([], _).
set_len_and_order([D | Ds], Size) :-
   length(D, Size),
   chain(D, #=<),
   set_len_and_order(Ds, Size).


%% Non-transitive dice problem constraints

non_transitive([First | L], Size) :- non_transitive_aux(L, First, First, Size).

non_transitive_aux([], Last, First, Size) :- beats(Last, First, Size).
non_transitive_aux([B | L], A, First, Size) :-
   beats(A, B, Size),
   non_transitive_aux(L, B, First, Size).

beats(A, B, Size) :-
   victories_of_A(A, B, Comb),
   Th is (Size * Size) // 2,
   sum(Comb, #>, Th).


%% Build the list : [ (a #> b) for a in A, b in B ]

victories_of_A([], _Ys, []).
victories_of_A([X | Xs], Ys, Comb) :-
   victories_of_A_aux(Ys, X, Comb, Comb_partial),
   victories_of_A(Xs, Ys, Comb_partial).

victories_of_A_aux([], _, L, L).
victories_of_A_aux([Y | Ys], X, [B | Comb], Comb_partial) :-
   B #<==> X #> Y,
   victories_of_A_aux(Ys, X, Comb, Comb_partial).
