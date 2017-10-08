%
% Part 2: generate lists of nontransitive dice
%

:- use_module(library(clpfd)).


%% Entrypoint

dice(N, S, L) :-
   dice_constraints(N, S, L),
   flatten(L, FlatL),
   labeling([ff], FlatL).

% - L has length N
% - for each die in L, length(die) = S
% - the dice are non_transitive
%
% Restrict the search space:
% - order every die in ascending order
% - one can assume that the first side of the first die is 1
% - there exists solutions with sides in 1..N+3
dice_constraints(N, S, L) :-
   length(L, N),
   set_len_and_order(L, S),
   flatten(L, FlatL),
   nth0(0, FlatL, 1),
   Sup is N + 3, FlatL ins 1..Sup,
   non_transitive(L, S).

% All dice have length S and are ordered
set_len_and_order([], _).
set_len_and_order([D | Ds], Size) :-
   length(D, Size),
   chain(D, #=<),
   set_len_and_order(Ds, Size).


%% Non-transitive dice problem constraints

non_transitive([First | L], Size) :-
   non_transitive_aux(L, First, First, Size).

% non_transitive_aux(L, A, First, Size) means:
%
% Two consecutive dice d1, d1 in `[A | L] ++ [First]` must satisfy
% beats(d1, d2)
%
% Size is the number of sides of a die
non_transitive_aux([], Last, First, Size) :- beats(Last, First, Size).
non_transitive_aux([B | L], A, First, Size) :-
   beats(A, B, Size),
   non_transitive_aux(L, B, First, Size).

%% The relation P[A > B] > 1/2

% First generate the list of all possible (a #> b) for a in A, b in B
beats(A, B, Size) :-
   victories_of_A(A, B, Comb),
   Th is (Size * Size) // 2,
   sum(Comb, #>, Th).


%% Build the list : [ (a #> b) for a in A, b in B ]

victories_of_A([], _Ys, []).
victories_of_A([A0 | A], B, Comb) :-
   victories_of_A_aux(B, A0, Comb, Comb_partial),
   victories_of_A(A, B, Comb_partial).

victories_of_A_aux([], _, Comb, Comb).
victories_of_A_aux([B0 | B], A0, [A0vsB0 | Comb], CombPartial) :-
   A0vsB0 #<==> A0 #> B0,
   victories_of_A_aux(B, A0, Comb, CombPartial).
