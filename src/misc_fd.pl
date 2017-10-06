:- module(misc_fd, [len/2, all_ins_domain/3]).


%% Compute length using #= instead of `is`
len([], 0).
len([_X | Xs], N) :- N #= M + 1, len(Xs, M).


%% Ensures that L ins Inf..Sup for L in LL
all_ins_domain([], _Inf, _Sup).
all_ins_domain([L | LL], Inf, Sup) :-
   L ins Inf..Sup,
   all_ins_domain(LL, Inf, Sup).
