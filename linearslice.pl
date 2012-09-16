% vim: set filetype=prolog :


straightline_slice([X,Y,W,H],[[CP1X,CP1Y],[CP2X,CP2Y]],N):-
	goldenratiomin(W,WMIN),	goldenratiomax(W,WMAX),
	goldenratiomin(H,HMIN),	goldenratiomax(H,HMAX),

	minfirst(CP1X,CP2X,CP1Xmin,CP2Xmax),	% temporarily switch coordinates
	minfirst(CP1Y,CP2Y,CP1Ymin,CP2Ymax),

	getminimalslice([X,Y],[[CP1Xmin,CP1Ymin],[CP2Xmax,CP2Ymax]],[WMIN,WMAX,HMIN,HMAX],Result),
	straightline_slice2([X,Y,W,H],[[CP1X,CP1Y],[CP2X,CP2Y]],[WMIN,WMAX,HMIN,HMAX],Result,N).

getminimalslice([X,Y],[[CP1X,CP1Y],[CP2X,CP2Y]],[WMIN,WMAX,HMIN,HMAX],no):-
	getminimalslice_vertical(X,CP1X,CP2X,WMIN,WMAX,no),
	getminimalslice_horizontal(Y,CP1Y,CP2Y,HMIN,HMAX,no).

getminimalslice([X,Y],[[CP1X,CP1Y],[CP2X,CP2Y]],[WMIN,WMAX,HMIN,HMAX],Orientation):-
	getminimalslice_vertical(X,CP1X,CP2X,WMIN,WMAX,no),
	getminimalslice_horizontal(Y,CP1Y,CP2Y,HMIN,HMAX, [Orientation,_]).

getminimalslice([X,Y],[[CP1X,CP1Y],[CP2X,CP2Y]],[WMIN,WMAX,HMIN,HMAX],Orientation):-
	getminimalslice_vertical(X,CP1X,CP2X,WMIN,WMAX, [Orientation,_]),
	getminimalslice_horizontal(Y,CP1Y,CP2Y,HMIN,HMAX,no).

getminimalslice([X,Y],[[CP1X,CP1Y],[CP2X,CP2Y]],[WMIN,WMAX,HMIN,HMAX],Orientation1):-
	getminimalslice_vertical(X,CP1X,CP2X,WMIN,WMAX, [Orientation1,Diff1]),
	getminimalslice_horizontal(Y,CP1Y,CP2Y,HMIN,HMAX, [_,Diff2]),
	Diff1 < Diff2.

getminimalslice([X,Y],[[CP1X,CP1Y],[CP2X,CP2Y]],[WMIN,WMAX,HMIN,HMAX],Orientation2):-
	getminimalslice_vertical(X,CP1X,CP2X,WMIN,WMAX, [_,Diff1]),
	getminimalslice_horizontal(Y,CP1Y,CP2Y,HMIN,HMAX, [Orientation2,Diff2]),
	Diff1 >= Diff2.


getminimalslice_vertical(X,CP1X,CP2X,WMIN,WMAX,no):-
	CP1X < X + WMIN,
	CP2X > X + WMAX,!.

getminimalslice_vertical(X,CP1X,CP2X,WMIN,_,[leftofWMIN,Diff]):-
	CP1X =< X + WMIN,
	CP2X =< X + WMIN,!,
	Diff1 is X + WMIN - CP1X,
	Diff2 is X + WMIN - CP2X,
	Diff is min(Diff1,Diff2).
	
getminimalslice_vertical(X,CP1X,CP2X,_,WMAX,[leftofWMAX,Diff]):-
	CP1X =< X + WMAX,
	CP2X =< X + WMAX,!,
	Diff1 is X + WMAX - CP1X,
	Diff2 is X + WMAX - CP2X,
	Diff is min(Diff1,Diff2).
	
getminimalslice_vertical(X,CP1X,CP2X,WMIN,_,[rightofWMIN,Diff]):-
	CP1X >= X + WMIN,
	CP2X >= X + WMIN,!,
	Diff1 is CP1X - X - WMIN,
	Diff2 is CP2X - X - WMIN,
	Diff is min(Diff1,Diff2).
	
getminimalslice_vertical(X,CP1X,CP2X,_,WMAX,[rightofWMAX,Diff]):-
	CP1X >= X + WMAX,
	CP2X >= X + WMAX,!,
	Diff1 is CP1X - X - WMAX,
	Diff2 is CP2X - X - WMAX,
	Diff is min(Diff1,Diff2).


getminimalslice_horizontal(Y,CP1Y,CP2Y,HMIN,HMAX,no):-
	CP1Y < Y + HMIN,
	CP2Y > Y + HMAX,!.

getminimalslice_horizontal(Y,CP1Y,CP2Y,HMIN,_,[aboveHMIN,Diff]):-
	CP1Y =< Y + HMIN,
	CP2Y =< Y + HMIN,!,
	Diff1 is Y + HMIN - CP1Y,
	Diff2 is Y + HMIN - CP2Y,
	Diff is min(Diff1,Diff2).

getminimalslice_horizontal(Y,CP1Y,CP2Y,_,HMAX,[aboveHMAX,Diff]):-
	CP1Y =< Y + HMAX,
	CP2Y =< Y + HMAX,!,
	Diff1 is Y + HMAX - CP1Y,
	Diff2 is Y + HMAX - CP2Y,
	Diff is min(Diff1,Diff2).

getminimalslice_horizontal(Y,CP1Y,CP2Y,HMIN,_,[underHMIN,Diff]):-
	CP1Y >= Y + HMIN,
	CP2Y >= Y + HMIN,!,
	Diff1 is CP1Y - Y - HMIN,
	Diff2 is CP2Y - Y - HMIN,
	Diff is min(Diff1,Diff2).

getminimalslice_horizontal(Y,CP1Y,CP2Y,_,HMAX,[underHMAX,Diff]):-
	CP1Y >= Y + HMAX,
	CP2Y >= Y + HMAX,!,
	Diff1 is CP1Y - Y - HMAX,
	Diff2 is CP2Y - Y - HMAX,
	Diff is min(Diff1,Diff2).


straightline_slice2(_,_,_,no,_).

straightline_slice2([X,Y,W,H],LL,[WMIN,_,_,_],leftofWMIN,N):-
	draw_proportions([X,Y,W,H],WMIN,none,N),
	slice([X,Y,WMIN,H],LL,N).

straightline_slice2([X,Y,W,H],LL,[_,WMAX,_,_],leftofWMAX,N):-
	draw_proportions([X,Y,W,H],WMAX,none,N),
	slice([X,Y,WMAX,H],LL,N).

straightline_slice2([X,Y,W,H],LL,[WMIN,WMAX,_,_],rightofWMIN,N):-
	draw_proportions([X,Y,W,H],WMIN,none,N),
	X1 is X + WMIN,
	slice([X1,Y,WMAX,H],LL,N).

straightline_slice2([X,Y,W,H],LL,[WMIN,WMAX,_,_],rightofWMAX,N):-
	draw_proportions([X,Y,W,H],WMAX,none,N),
	X1 is X + WMAX,
	slice([X1,Y,WMIN,H],LL,N).

straightline_slice2([X,Y,W,H],LL,[_,_,HMIN,_],aboveHMIN,N):-
	draw_proportions([X,Y,W,H],none,HMIN,N),
	slice([X,Y,W,HMIN],LL,N).

straightline_slice2([X,Y,W,H],LL,[_,_,_,HMAX],aboveHMAX,N):-
	draw_proportions([X,Y,W,H],none,HMAX,N),
	slice([X,Y,W,HMAX],LL,N).

straightline_slice2([X,Y,W,H],LL,[_,_,HMIN,HMAX],underHMIN,N):-
	draw_proportions([X,Y,W,H],none,HMIN,N),
	Y1 is Y + HMIN,
	slice([X,Y1,W,HMAX],LL,N).

straightline_slice2([X,Y,W,H],LL,[_,_,HMIN,HMAX],underHMAX,N):-
	draw_proportions([X,Y,W,H],none,HMAX,N),
	Y1 is Y + HMAX,
	slice([X,Y1,W,HMIN],LL,N).


split(_,_,_,_).
