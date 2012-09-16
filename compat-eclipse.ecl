% Eclipse specific prolog stuff

% is_list definition taken from SWI prolog
is_list(X) :- var(X), !, fail.
is_list([]).
is_list([_|T]) :- is_list(T).

% return last of list   
last([Last],Last) :- !.
last([_First|Rest], Last) :- last(Rest,Last),!.

flush_output(Stream) :- flush(Stream).

listdelete([],L2,L2).
listdelete([H|T],L1,L2) :- delete(H, L1, Temp), listdelete(T, Temp, L2).

% returns a random value in the domain <min,max>
chooseRandom(Min,Max,Val) :-
        NMin is Min + 1,
        Range is Max - NMin,
        random(R),
        mod(R,Range,RND),
        Val is RND + NMin.

dec2hex(In,Hex):-
  Base is 16,
  findamount(In,Base,0,Amount),
  createnumber(In,Amount,Base,[],Out),!,
  concat_string(Out,Hex).

% findamount(+In,+Base,+Acc,-Amount)
% Finds number of elements needed to create value
findamount(In,Base,Acc,Acc):-
  Pow is Acc + 1,
  ^(Base,Pow,Cond),
  In < Cond.
findamount(In,Base,Acc,Amount):-
  Acc1 is Acc+1,
  findamount(In,Base,Acc1,Amount).

createnumber(_In,-1,_Base,Out,Out).
createnumber(In,Amount,Base,Collector,Out):-

  ^(Base,Amount,Pow),
  mod(In,Pow,Rest),
  Factor is In - Rest,
  Factor1 is Factor/Pow,
  fix(Factor1,Factor2),
  letters(Factor2,Factor3),
  append(Collector,[Factor3],Collector1),
  Amount1 is Amount - 1,
  createnumber(Rest,Amount1,Base,Collector1,Out).

% letters(+In,-Letter)
% if > 10, then letter for hex.

letters(In,In):-
  integer(In),
  In < 10.

letters(10,"a").
letters(11,"b").
letters(12,"c").
letters(13,"d").
letters(14,"e").
letters(15,"f").

letters(Out,In):-
  number_string(Out,In).


value(In,Value):-
        substring(In,1,1,First),
        substring(In,2,1,Second),
        letters(FirstVal,First),
        letters(SecondVal,Second),
        Value is 16 * FirstVal + SecondVal,
        true.

