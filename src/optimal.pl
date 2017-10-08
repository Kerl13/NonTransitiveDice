%
% Part 3: find an optimal solution
%

:- use_module(library(clpfd)).


%% Entrypoint

optimal(N, S, L) :-
   optimal_constraints(N, S, L, Pmin),
   flatten(L, FlatL),
   labeling([max(Pmin), ff], FlatL).

% 1. Breaking one symmetry: dice are ordered
% 2. One can look for solutions with values in {1, 2, …, NS}
%    and each value is taken exactly once.
% 3. One can assume the die with the 1 is in first position
optimal_constraints(N, S, L, Pmin) :-
   length(L, N),
   set_len_and_order(L, S),
   flatten(L, FlatL),
   Sup is N * S, FlatL ins 1..Sup,
   nth0(0, FlatL, 1),
   non_transitive(L, S, Probas),
   fd_list_min(Probas, Pmin),
   all_distinct(FlatL).


% All dice have length S and are ordered
set_len_and_order([], _).
set_len_and_order([D | Ds], Size) :-
   length(D, Size),
   chain(D, #<),
   set_len_and_order(Ds, Size).


%% Non-transitive dice problem constraints

non_transitive([First | L], Size, Probas) :-
   non_transitive_aux(L, First, First, Size, Probas).

% non_transitive_aux(L, A, First, Size) means:
%
% Two consecutive dice d1, d1 in `[A | L] ++ [First]` must satisfy
% beats(d1, d2)
%
% Size is the number of sides of a die
non_transitive_aux([], Last, First, Size, [Proba]) :-
   beats(Last, First, Size, Proba).
non_transitive_aux([B | L], A, First, Size, [P | Ps]) :-
   beats(A, B, Size, P),
   non_transitive_aux(L, B, First, Size, Ps).

%% The relation P[A > B] > 1/2

% First generate the list of all possible (a #> b) for a in A, b in B
% Then count the victories of A and remember that count
beats(A, B, Size, Sum) :-
   victories_of_A(A, B, Comb),
   Th is (Size * Size) // 2,
   sum(Comb, #=, Sum),
   Sum #> Th.


%% Build the list : [ (a #> b) for a in A, b in B ]

victories_of_A([], _Ys, []).
victories_of_A([X | Xs], Ys, Comb) :-
   victories_of_A_aux(Ys, X, Comb, Comb_partial),
   victories_of_A(Xs, Ys, Comb_partial).

victories_of_A_aux([], _, L, L).
victories_of_A_aux([Y | Ys], X, [B | Comb], Comb_partial) :-
   B #<==> X #> Y,
   victories_of_A_aux(Ys, X, Comb, Comb_partial).


%% Some helper functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


fd_list_min([H | T], Min) :- foldl(fd_min, [H | T], H, Min).
fd_min(A, B, Min) :- A #< B, Min #= A.
fd_min(A, B, Min) :- A #>= B, Min #= B.
