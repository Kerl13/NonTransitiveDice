:- module(misc, [combine/3]).

%% combine(Xs, Ys, Comb) <=> Comb = [[X,Y] for X in Xs, Y in Ys]

combine([], _Ys, []).
combine([X | Xs], Ys, Comb) :-
   combine(Xs, Ys, Comb_partial),
   combine_aux(X, Ys, Comb, Comb_partial).

% combine_aux(X, Ys, Tot, Partial) <=> Tot = [[X, Y] for Y in Ys] ++ Partial
combine_aux(_X, [], L, L).
combine_aux(X, [Y | Ys], [[X, Y] | Comb], Comb_partial) :-
   combine_aux(X, Ys, Comb, Comb_partial).
