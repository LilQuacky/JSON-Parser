%%%% 885925 Yzeiri Flavio
%%%% 887525 Falbo Andrea

%%%% -*- Mode: Prolog -*-

%%%% jsonparse.pl
%% Make a prolog library that builds data structures representing JSON objects, 
%% starting from their representation as strings.

%%%call jparse
jsonparse(JSONString, Object):-
    jparse(JSONString, Object).

%%%parse an array
jparse(JSONString, Object) :-
    term_string(String, JSONString),
    nonvar(String),
    parsearray(String, Object),
    !.

%%%Output become jsonarray(Values)
parsearray(Input, Output) :-
    assess(Input, Values),
    Output =.. ['jsonarray', Values].

%%%evaluate for array
assess([], []).
assess([Value | MoreValues], [Output | MoreOutput]) :-
    nonvar(Value),
    atomic(Value, Output),
    assess(MoreValues, MoreOutput).

%%%parse an obj
jparse(JSONString, Object) :-
    term_string(String, JSONString),
    nonvar(String),
    parseobj(String, Object),
    !.

%%%Obj become jsonobj(Out)
parseobj({Pair}, Obj) :-
    pairs(Pair, Output),
    Obj =.. ['jsonobj', Output].

%%%Obj become jsonobj([])
parseobj({}, Obj):-
    Obj =.. ['jsonobj', []].

%%%split one pair from the others
pairs(Pair ',' Pairs, [Output | MoreOutputs]):-
    pair(Pair, Output),
    pairs(Pairs, MoreOutputs),
    !.

pairs(Pair, [Output]) :-
    pair(Pair, Output).

%%%split the pair
pair(Left : Right, Pair) :-
    string(Left),
    nonvar(Right),
    atomic(Right, Output),
    Pair =.. [',' , Left, Output].

atomic(true, true).
atomic(false, false).
atomic(null, null).
atomic(Value, Obj) :-
    parseobj(Value, Obj).
atomic(Value, Array) :-
    parsearray(Value, Array).
atomic(String, String) :-
    string(String).
atomic(Number, Number) :-
    number(Number).

jsonaccess(Jsonobj, Field, Result):-
    accessto(Jsonobj, Field, Result).

%%%access with []
accessto(X, [], X) :-
    not(arraycontrol(X)),
    !.

%%%access an array
accessto(jsonarray(Values), [Field | MoreFields], Output) :-
    integer(Field),
    arrayextract(Values, Field, Result),
    accessto(Result, MoreFields, Output),
    !.

%%%manage extract of array
arrayextract([Value | _], 0, Value) :-!.
arrayextract([_ | Values], Field, Output) :-
    NewField is Field -1,
    arrayextract(Values, NewField, Output).

arraycontrol(jsonarray(_Values)).

%%%access an Obj with only 1 field
accessto(jsonobj(Values), Field, Output) :-
    member((Field, Output), Values),
    !.

%%%access an Obj
accessto(jsonobj(Values), [Field | MoreFields], Output) :-
    member((Field, Member), Values),
    accessto(Member, MoreFields, Output),
    !.

%%%translate the file into string and parse it
jsonread(FileName, JSON) :-
    read_file_to_string(FileName, Input, []),
    jsonparse(Input, JSON).

%%%dump for array
jsondump(JSON, FileName) :-
    open(FileName, write, Scanner),
    writeArray(JSON, Scanner, 0),
    close(Scanner),
    !.

%%%dump for Obj
jsondump(JSON, FileName) :-
    open(FileName, write, Scanner),
    writeObj(JSON, Scanner, 0),
    close(Scanner),
    !.

%%%write array with a single value
writeArray([Value], Scanner, Tab) :-
    writeValue(Value, Scanner, Tab).

%%%write array with multiple values
writeArray([Value | MoreValues], Scanner, Tab) :-
    writeValue(Value, Scanner, Tab),
    write(Scanner, ', '),
    writeArray(MoreValues, Scanner, Tab).
    
%%%write for jsonarray(Values) case
writeArray(jsonarray(Values), Scanner, Tab) :-
    NewTab is Tab + 1,
    write(Scanner, '['),
    writeArray(Values, Scanner, NewTab),
    write(Scanner, ']').

%%%write an Obj
writeObj(jsonobj(Pairs), Scanner, Tab) :-
    NewTab is Tab + 1,
    write(Scanner, '{'),
    writePairs(Pairs, Scanner, NewTab),
    counter(Tab, Scanner),
    write(Scanner, '}').

%%%write a single Pair
writePairs([Pair], Scanner, Tab) :-
    write(Scanner, '\n'),
    counter(Tab, Scanner),
    writePair(Pair, Scanner, Tab),
    write(Scanner, '\n').

%%%write multiple pairs
writePairs([Pair | MorePairs], Scanner, Tab) :-
    write(Scanner, '\n'),
    counter(Tab, Scanner),
    writePair(Pair, Scanner, Tab),
    write(Scanner, ', '),
    writePairs(MorePairs, Scanner, Tab).

%%%reassembles a pair
writePair((Left, Right), Scanner, Tab) :-
    writeq(Scanner, Left),
    write(Scanner, ': '),
    writeValue(Right, Scanner, Tab).

%%%write an object
writeValue(Obj, Scanner, Tab) :-
    writeObj(Obj, Scanner, Tab),
    !.

%%%write an array
writeValue(Array, Scanner, Tab):-
    writeArray(Array, Scanner, Tab),
    !.

%%%write a string
writeValue(Value, Scanner, _) :-
    string(Value),
    writeq(Scanner, Value),
    !.

%%%write a value
writeValue(Value, Scanner, _):-
    write(Scanner, Value).

%%%do a tab
counter(0, _) :- !.
counter(Tab, Scanner) :-
    NewTab is Tab - 1,
    write(Scanner, '\t'),
    counter(NewTab, Scanner).

%%%%    end of file -- jsonparse.pl --














