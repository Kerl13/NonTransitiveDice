:- module(misc, [head/2, combine/3]).


%% Head of a list
% TODO: isn't this a builtin?
head(H, [H | _L]).


%% combine(Xs, Ys, Comb) <=> Comb = [[X,Y] for X in Xs, Y in Ys]
combine([], _Ys, []).
combine([X | Xs], Ys, Comb) :-
   combine(Xs, Ys, Comb_partial),
   combine_aux(X, Ys, Comb, Comb_partial).

% combine_aux(X, Ys, Tot, Partial) <=> Tot = [[X, Y] for Y in Ys] ++ Partial
combine_aux(_X, [], L, L).
combine_aux(X, [Y | Ys], [[X, Y] | Comb], Comb_partial) :-
   combine_aux(X, Ys, Comb, Comb_partial).
