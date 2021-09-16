          
% convert initial array to city_array
convert([], _).
convert([E|Rest], City_array):-
    Arg is E + 1,
    arg(Arg, City_array, Value),
    nonvar(Value),
    New_value is Value + 1,
    nb_setarg(Arg, City_array, New_value),
    convert(Rest, City_array).
convert([E|Rest], City_array):-
    Arg is E + 1,
    arg(Arg, City_array, Value),
    var(Value),
    nb_setarg(Arg, City_array, 1),
    convert(Rest, City_array).

% fill with zeros
fill(0, _).
fill(Arg, City_array):-
    arg(Arg, City_array, Value),
    New_arg is Arg - 1,
    (var(Value) -> nb_setarg(Arg, City_array, 0); nonvar(Value)),
    fill(New_arg, City_array).

% find sum and max
find_sum_max(_, [], Sum, Max, Sum, Max).
find_sum_max(N, [E|Rest], Temp_sum, Temp_max, Sum, Max):-
    Temp is N-E,
    Distance is Temp mod N,
    New_sum is Temp_sum + Distance,
    (Temp_max < Distance -> New_max is Distance; New_max is Temp_max),
    find_sum_max(N, Rest, New_sum, New_max, Sum, Max).

% fix Max index
fix_MaxI(MaxI, MaxI, MainI, _, City_array):-
    MainI =\= MaxI,
    arg(MaxI, City_array, Value),
    Value =\= 0.
fix_MaxI(Unfixed_MaxI, MaxI, MainI, N, City_array):-
    New is Unfixed_MaxI + 1,
    (New > N -> Arg is 1; Arg is New),
    arg(Arg, City_array, Value),
    (
        Value =\= 0 -> MaxI is Arg;
        fix_MaxI(Arg, MaxI, MainI, N, City_array)
    ).

% calculate max distance
get_max_distance(MainI, MaxI, N, Max_distance):-
    MaxI < MainI ->
        Max_distance is MainI - MaxI;
        Max_distance is N - (MaxI-MainI).

% solution to our problem
solution(MainI, _,    N, _, _,          _,   _,   M, C, M, C):- MainI is N+1.
solution(MainI, MaxI, N, K, City_array, Sum, Max, M, C, Prev_min, Prev_minPos):-
    %write(Sum), write(' '), write(Max), write(' '),
    (
        (2*Max - Sum < 2, Sum < Prev_min) ->
            (Min is Sum,      Min_pos is MainI);
            (Min is Prev_min, Min_pos is Prev_minPos)
    ),
    %write(Min), write(' '), write(Min_pos), write('\n'),
    New_MainI is MainI + 1,
    (
        New_MainI < N+1 ->
            (
                fix_MaxI(MaxI, New_MaxI, New_MainI, N, City_array),
                arg(New_MainI, City_array, Array_element),
                New_sum is Sum + K - N * Array_element,
                get_max_distance(New_MainI, New_MaxI, N, New_Max),
                solution(New_MainI, New_MaxI, N, K, City_array, New_sum, New_Max, M, C, Min, Min_pos)
            );
            (solution(New_MainI, _, N, _, _, _, _, M, C, Min, Min_pos))
    ).

% main algorithm
algorithm(N, K, Given_list, M, C):-
    functor(City_array, array, N),
    convert(Given_list, City_array),
    fill(N, City_array),
    find_sum_max(N, Given_list, 0, 0, Sum, Max),
    fix_MaxI(1, MaxI, 1, N, City_array),
    solution(1, MaxI, N, K, City_array, Sum, Max, M, C_plus1, Sum, 1),
    C is C_plus1 - 1.
    
% inputs a line
get_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

% program
round(Input, M, C) :-
    open(Input, read, Stream),
    get_line(Stream, [N, K]),
    get_line(Stream, L),
    algorithm(N, K, L, M, C), !,
    close(Stream).