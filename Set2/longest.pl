% calculate and return max index difference
calcMaxDiff([], _, Answer, MaxDiff, _, _) :- Answer is MaxDiff+1.
calcMaxDiff(_, [], Answer, MaxDiff, _, _) :- Answer is MaxDiff+1.
calcMaxDiff([LMin|LRest], [RMax|RRest], Answer, Prev, I, J) :-
    LMin < RMax,
    Diff is J - I,
    MaxDiff is max(Prev, Diff),
    Next is J+1,
    calcMaxDiff([LMin|LRest], RRest, Answer, MaxDiff, I, Next).
calcMaxDiff([_|LRest], [RMax|RRest], Answer, Prev, I, J) :-
    Next is I+1,
    calcMaxDiff(LRest, [RMax|RRest], Answer, Prev, Next, J).

% construct Rmax
beginRMax([Last], [Last], Last).
beginRMax([ArrFirst|Arr], [RMaxFirst|RMax], RMaxFirst) :-
    beginRMax(Arr, RMax, Prev),
    RMaxFirst is max(ArrFirst, Prev).

% construct Lmin
beginLMin([], []).
beginLMin([ArrFirst|Arr], [ArrFirst|LMin]) :- constrLMin(Arr, LMin, ArrFirst).
constrLMin([Last], [LastLMin], Prev) :- LastLMin is min(Last, Prev).
constrLMin([ArrFirst|Arr], [LMinFirst|LMin], Prev) :-
    LMinFirst is min(ArrFirst, Prev),
    constrLMin(Arr, LMin, LMinFirst).

% Step 3: find index with maximum difference
maxIndexDifference(PrefixArr, Answer) :-
    beginLMin(PrefixArr, LMin),
    beginRMax(PrefixArr, RMax, _),
    calcMaxDiff(LMin, RMax, Answer, -1, 0, 0).

% Step 2: calculate prefix array
calcprefix([Last], Sum, [LastSum]) :- LastSum is Sum + Last.
calcprefix([First|Rest], Sum, [NewSum|RestPrefix]) :-
    NewSum is Sum + First,
    calcprefix(Rest, NewSum, RestPrefix).

% Step 1: preprocess input array
preprocess([PreLast], [Last], N) :-
    Temp is PreLast + N,
    Last is Temp * (-1).
preprocess([PreFirst|PreRest], [First|Rest], N) :-
    Temp is PreFirst + N,
    First is Temp * (-1),
    preprocess(PreRest, Rest, N).

% 3 steps for calculating the solution
longestsubarray(PreArray, N, Answer) :-
    preprocess(PreArray, Array, N),
    calcprefix(Array, 0, PrefixArr),
    maxIndexDifference(PrefixArr, Answer).

% fixing result
fixer(Answer, Answer, M) :- Answer is M.
fixer(Return, Answer, _) :- Answer is Return-1.


% inputs one line
get_line(Stream, List) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Actual, Line),
    atomic_list_concat(Atoms, ' ', Actual),
    maplist(atom_number, Atoms, List).

% starts the party
longest(Input, Answer) :-
    open(Input, read, Stream),
    get_line(Stream, [M,N|[]]),
    get_line(Stream, PreArray),
    longestsubarray(PreArray, N, Return),
    fixer(Return, Answer, M), !.        