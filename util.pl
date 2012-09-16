% vim: set filetype=prolog :


% get nth item out of list (already implemented in eclipse?)

nth(1,[HEAD|_],HEAD).


nth(N1,[_|TAIL],NTH):-
	N2 is N1 - 1,
	nth(N2,TAIL,NTH).


goldenratiomax(N,N1):-
	phi(Phi),
	N1 is N / Phi.

goldenratiomin(N,N1):-
	phi(Phi),
	N1 is N - (N / Phi).



 % relative_position determines if focuscoordinate is closer or further to the x-axis /
 % y-axis within an arbitrary slice

relative_position(Focuscoord, Startcoord, Length, Value):-
	(Focuscoord < Startcoord + (Length/2) -> Value = closer; Value = further).



 % no intersecting points, returns nothing

calculate_newLL(X,Y,[[FPX,FPY],[CPX,CPY]],[none]):-
	\+ crosses_line(FPX, CPX, X),
	\+ crosses_line(FPY, CPY, Y).

 % 1 intersecting point 

calculate_newLL(X,Y,[[FPX,FPY],[CPX,CPY]],[horiz,[IPX,Y]]):-
	\+ crosses_line(FPX, CPX, X),
	crosses_line(FPY, CPY, Y),!,

	get_IPX(Y,[FPX,FPY],[CPX,CPY],IPX).
	
% 1 intersecting point 

calculate_newLL(X,Y,[[FPX,FPY],[CPX,CPY]],[vert,[X,IPY]]):-
	crosses_line(FPX, CPX, X),
	\+ crosses_line(FPY, CPY, Y),!,

	get_IPY(X,[FPX,FPY],[CPX,CPY],IPY).

 % 2 intersecting points
 % the vertical line is closest,
 % returns these coordinates first

calculate_newLL(X,Y,[[FPX,FPY],[CPX,CPY]],[vert_first,[X,IPY],[IPX,Y]]):-
	crosses_line(FPX, CPX, X),
	crosses_line(FPY, CPY, Y),

	get_IPX(Y,[FPX,FPY],[CPX,CPY],IPX),
	get_IPY(X,[FPX,FPY],[CPX,CPY],IPY),

	distance([FPX,FPY],[IPX,Y],D1),
	distance([FPX,FPY],[X,IPY],D2),
	D2 < D1.

 % 2 intersection points
 % the horizontal line is closest
 % returns these coordinates first

calculate_newLL(X,Y,[[FPX,FPY],[CPX,CPY]], [horiz_first,[IPX,Y],[X,IPY]]):-
	crosses_line(FPX, CPX, X),
	crosses_line(FPY, CPY, Y),
	get_IPX(Y,[FPX,FPY],[CPX,CPY],IPX),
	get_IPY(X,[FPX,FPY],[CPX,CPY],IPY),
	distance([FPX,FPY],[IPX,Y],D1),
	distance([FPX,FPY],[X,IPY],D2),
	D1 < D2.



 % calculates length hypothenuse

distance([P1X,P1Y],[P2X,P2Y], Distance):-
	X is (P1X - P2X)^2,
	Y is (P1Y - P2Y)^2,
	Distance is sqrt(X + Y).



 % get intersection coordinate
 % calculates the point where the leadingline is intersected

get_IPX(_,[FPX,_],[CPX,_],FPX):-
	FPX = CPX.

 % part of leadingline to the left of focuspoint

get_IPX(Y,[FPX,FPY],[CPX,CPY],IPX):-
	FPX < CPX,!,

	X1 is abs(FPX - CPX),
	Y1 is abs(FPY - CPY),
	Y2 is abs(Y - CPY),
	X2 is ((X1/Y1) * Y2),
	IPX is CPX - X2.

 % part of leadingline to the right of focuspoint
	
get_IPX(Y,[FPX,FPY],[CPX,CPY],IPX):-
	FPX > CPX,!,

	X1 is abs(FPX - CPX),
	Y1 is abs(FPY - CPY),
	Y2 is abs(Y - CPY),
	X2 is ((X1/Y1) * Y2),
	IPX is CPX + X2.

get_IPY(_,[_,FPY],[_,CPY],FPY):-
	FPY = CPY.

 % part of leadingline above focuspoint

get_IPY(X,[FPX,FPY],[CPX,CPY],IPY):-
	FPY < CPY,!,

	X1 is abs(FPX - CPX),
	Y1 is abs(FPY - CPY),
	X2 is abs(X - CPX),
	Y2 is ((Y1/X1) * X2),

	IPY is CPY - Y2.
	
 % part of leadingline below focuspoint

get_IPY(X,[FPX,FPY],[CPX,CPY],IPY):-
	FPY > CPY,!,

	X1 is abs(FPX - CPX),
	Y1 is abs(FPY - CPY),
	X2 is abs(X - CPX),
	Y2 is ((Y1/X1) * X2),

	IPY is CPY + Y2.



 % focuspoint above / right of cornerpoint

crosses_line(FocuspointCoord, CornerpointCoord, LineCoord):-
	LineCoord =< FocuspointCoord, LineCoord > CornerpointCoord.

 % focuspoint under / left of cornerpoint

crosses_line(FocuspointCoord, CornerpointCoord, LineCoord):-
	LineCoord < CornerpointCoord, LineCoord >= FocuspointCoord.



 % between(+X1,+X2,-X3)
 % should also be used by focuspoint_slice

 %between(X1,X2,X3):-
 %	min(X1,X2,XMIN),
 %	max(X1,X2,XMAX),
 %	X3 >= XMIN,
 %	X3 =< XMAX.

 % hack to switch the coordinates so smallest one always comes first

minfirst(CP1,CP2,CP1,CP2):-
	CP1 =< CP2.

minfirst(CP1,CP2,CP2,CP1):-
	CP1 > CP2.

