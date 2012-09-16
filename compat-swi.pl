concat_string([S1,S2],S3) :- !,
	string_concat(S1,S2,S3).
concat_string([S1|Tail],S3) :-
	concat_string(Tail,S2), string_concat(S1,S2,S3).

string_list(S,L) :- string_to_list(S,L).

listdelete([],L3,L3).
listdelete([H|T],L2,L3) :-
	delete(L2,H,Temp),
	listdelete(T,Temp,L3).

chooseRandom(Min,Max,Val) :-
	NMin is Min + 1,
	Range is Max - NMin,
	R is random(Range),
	Val is R + NMin,
	true.

printf(Stream,Format,Args) :-
	swritef(String, Format, Args),
	write(Stream, String),
	true.

date(String) :- get_time(T), convert_time(T,String).

get_flag(cwd, CWD)          :- working_directory(CWD, CWD).
get_flag(hostname, Hostname):- getenv('HOSTNAME', Hostname).
get_flag(version, Version)  :-
	current_prolog_flag(version, V),
	string_concat("SWI-Prolog ",V, Version).

% dec2hex(+Dec,-Hex)
% Converts single decimal value to hex based-value
dec2hex(In,Hex):- sformat(Hex,"~16r", In).

fix(X,Y) :- round(X,Z), Y is integer(Z).
ln(X,Y)  :- log(X,Y).

