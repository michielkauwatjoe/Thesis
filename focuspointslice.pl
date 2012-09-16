% vim: set filetype=prolog :

 % focuspointslice
 % chooses slice with largest area around focuspoint
 % written out for 4 different orientations, topleft, topright, bottomright & bottomleft
 % (clockwise order)
 % should be reimplemented eventually to unify cases in 1 algorithm

focuspointslice([X,Y,W,H],[[FPX,FPY],[CP1X,CP1Y],[CP2X,CP2Y]],N):-

	% topleft
	relative_position(FPX,X,W,closer), relative_position(FPY,Y,H,closer),!,

	goldenratiomax(W,W1), goldenratiomin(W,W2),
	goldenratiomax(H,H1), goldenratiomin(H,H2),

	draw_proportions([X,Y,W,H],W1,H1,N),

	X1 is X + W1, Y1 is Y + H1,

	% split LL into straight-line sections 
	calculate_newLL(X1,Y1,[[FPX,FPY],[CP1X,CP1Y]],NewIPs_left), % left side
	calculate_newLL(X1,Y1,[[FPX,FPY],[CP2X,CP2Y]],NewIPs_right), % right side
	draw_newIPs(NewIPs_left), draw_newIPs(NewIPs_right),

	focuspointslice2(topleft,[X,Y,X1,Y1],[W1,W2,H1,H2],[[FPX,FPY],[CP1X,CP1Y],[CP2X,CP2Y]],NewIPs_left,NewIPs_right,N).

focuspointslice([X,Y,W,H],[[FPX,FPY],[CP1X,CP1Y],[CP2X,CP2Y]],N):-

	% topright
	relative_position(FPX,X,W,further), relative_position(FPY,Y,H,closer),!, 

	goldenratiomin(W,W1), goldenratiomax(W,W2),
	goldenratiomax(H,H1), goldenratiomin(H,H2),

	draw_proportions([X,Y,W,H],W1,H1,N),

	X1 is X + W1, Y1 is Y + H1,

	% split LL into straight-line sections 
	calculate_newLL(X1,Y1,[[FPX,FPY],[CP1X,CP1Y]],NewIPs_left), % left side
	calculate_newLL(X1,Y1,[[FPX,FPY],[CP2X,CP2Y]],NewIPs_right), % right side
	draw_newIPs(NewIPs_left), draw_newIPs(NewIPs_right),

	focuspointslice2(topright,[X,Y,X1,Y1],[W1,W2,H1,H2],[[FPX,FPY],[CP1X,CP1Y],[CP2X,CP2Y]],NewIPs_left,NewIPs_right,N).

focuspointslice([X,Y,W,H],[[FPX,FPY],[CP1X,CP1Y],[CP2X,CP2Y]],N):-

	% bottomright
	relative_position(FPX,X,W,further), relative_position(FPY,Y,H,further),!,

	goldenratiomin(W,W1), goldenratiomax(W,W2),
	goldenratiomin(H,H1), goldenratiomax(H,H2),
	draw_proportions([X,Y,W,H],W1,H1,N),

	X1 is X + W1, Y1 is Y + H1,

	% split LL into straight-line sections 
	calculate_newLL(X1,Y1,[[FPX,FPY],[CP1X,CP1Y]],NewIPs_left), % left side
	calculate_newLL(X1,Y1,[[FPX,FPY],[CP2X,CP2Y]],NewIPs_right), % right side
	draw_newIPs(NewIPs_left), draw_newIPs(NewIPs_right),

	focuspointslice2(bottomright,[X,Y,X1,Y1],[W1,W2,H1,H2],[[FPX,FPY],[CP1X,CP1Y],[CP2X,CP2Y]],NewIPs_left,NewIPs_right,N).

focuspointslice([X,Y,W,H],[[FPX,FPY],[CP1X,CP1Y],[CP2X,CP2Y]],N):-

	% bottomleft
	relative_position(FPX,X,W,closer), relative_position(FPY,Y,H,further),

	goldenratiomax(W,W1), goldenratiomin(W,W2),
	goldenratiomin(H,H1), goldenratiomax(H,H2),
	draw_proportions([X,Y,W,H],W1,H1,N),

	X1 is X + W1, Y1 is Y + H1,

	% split LL into straight-line sections 
	calculate_newLL(X1,Y1,[[FPX,FPY],[CP1X,CP1Y]],NewIPs_left), % left side
	calculate_newLL(X1,Y1,[[FPX,FPY],[CP2X,CP2Y]],NewIPs_right), % right side
	draw_newIPs(NewIPs_left), draw_newIPs(NewIPs_right),

	focuspointslice2(bottomleft,[X,Y,X1,Y1],[W1,W2,H1,H2],[[FPX,FPY],[CP1X,CP1Y],[CP2X,CP2Y]],NewIPs_left,NewIPs_right,N).

 % focuspointslice2

focuspointslice2(_,_,_,_,[none],[none],_). 
	% write(Orientation), writeln(' none,none'). % this condition may occur sometimes

 % clockwise order like this:

 %	slice([X,Y,W1,H1],[],N),
 %	slice([X1,Y,W2,H1],[],N),
 %	slice([X1,Y1,W2,H2],[],N),
 %	slice([X,Y1,W1,H2],[],N).

 % topleft

focuspointslice2(topleft,[X,Y,X1,_],[W1,W2,H1,_],[FP,CP1,CP2],[none],[vert,IP1],N):-
	% writeln('topleft,none,vert'),
	slice([X,Y,W1,H1],[FP,CP1,IP1],N),
	slice([X1,Y,W2,H1],[IP1,CP2],N).

focuspointslice2(topleft,[X,Y,X1,Y1],[W1,W2,H1,H2],[FP,CP1,CP2],[none],[vert_first,IP1,IP2],N):-
	% writeln('topleft,none,vert_first'),
	slice([X,Y,W1,H1],[FP,CP1,IP1],N),
	slice([X1,Y,W2,H1],[IP1,IP2],N),
	slice([X1,Y1,W2,H2],[IP2,CP2],N).

focuspointslice2(topleft,[X,Y,X1,Y1],[W1,W2,H1,H2],[FP,CP1,CP2],[none],[horiz_first,IP1,IP2],N):-
	% writeln('topleft,none,horiz_first'),
	slice([X,Y,W1,H1],[FP,CP1,IP1],N),
	slice([X,Y1,W1,H2],[IP1,IP2],N),
	slice([X1,Y1,W2,H2],[IP2,CP2],N).

focuspointslice2(topleft,[X,Y,X1,Y1],[W1,W2,H1,H2],[FP,CP1,CP2],[horiz,IP1],[vert,IP2],N):-
	% writeln('topleft,horiz,vert'),
	slice([X,Y,W1,H1],[FP,IP1,IP2],N),
	slice([X1,Y,W2,H1],[IP2,CP2],N),
	slice([X,Y1,W1,H2],[CP1,IP1],N).

focuspointslice2(topleft,[X,Y,X1,Y1],[W1,W2,H1,H2],[FP,CP1,CP2],[horiz,IP1],[vert_first,IP2,IP3],N):-
	% writeln('topleft,horiz,vert_first'),
	slice([X,Y,W1,H1],[FP,IP1,IP2],N),
	slice([X1,Y,W2,H1],[IP2,IP3],N),
	slice([X1,Y1,W2,H2],[IP3,CP2],N),
	slice([X,Y1,W1,H2],[CP1,IP1],N).

focuspointslice2(topleft,[X,Y,X1,Y1],[W1,W2,H1,H2],[FP,CP1,CP2],[horiz,IP1],[horiz_first,IP2,IP3],N):-
	% writeln('topleft,horiz,horiz_first'),
	slice([X,Y,W1,H1],[FP,IP1,IP2],N),
	split([X1,Y,W2,H1],[CP1,IP1],[IP2,IP3],N),
	slice([X1,Y1,W2,H2],[IP3,CP2],N).

 % topright

focuspointslice2(topright,[X,Y,X1,_],[W1,W2,H1,_],[FP,CP1,CP2],[vert,IP1],[none],N):-
	% writeln('topright,vert,none'),
	slice([X,Y,W1,H1],[CP1,IP1],N),
	slice([X1,Y,W2,H1],[FP,IP1,CP2],N).

focuspointslice2(topright,[X,Y,X1,Y1],[W1,W2,H1,H2],[FP,CP1,CP2],[vert_first,IP1,IP2],[none],N):-
	% writeln('topright,vert_first,none'),
	slice([X,Y,W1,H1],[IP2,IP1],N),
	slice([X1,Y,W2,H1],[FP,IP2,CP2],N),
	slice([X,Y1,W1,H2],[CP1,IP2],N).

focuspointslice2(topright,[X,Y,X1,Y1],[W1,W2,H1,H2],[FP,CP1,CP2],[horiz_first,IP1,IP2],[none],N):-
	% writeln('topright,horiz_first,none'),
	slice([X1,Y,W2,H1],[FP,IP2,CP2],N),
	slice([X1,Y1,W2,H2],[IP1,IP2],N),
	slice([X,Y1,W1,H2],[CP1,IP1],N).
	
focuspointslice2(topright,[X,Y,X1,Y1],[W1,W2,H1,H2],[FP,CP1,CP2],[vert,IP1],[horiz,IP2],N):-
	% writeln('topright,vert,horiz'),
	slice([X,Y,W1,H1],[CP1,IP1],N),
	slice([X1,Y,W2,H1],[FP,IP1,IP2],N),
	slice([X1,Y1,W2,H2],[IP2,CP2],N).

focuspointslice2(topright,[X,Y,X1,Y1],[W1,W2,H1,H2],[FP,CP1,CP2],[vert_first,IP1,IP2],[horiz,IP3],N):-
	% writeln('topright,vert_first,horiz'),
	slice([X,Y,W1,H1],[IP1,IP2],N),
	slice([X1,Y,W2,H1],[FP,IP1,IP3],N),
	slice([X1,Y1,W2,H2],[IP3,CP2],N),
	slice([X,Y1,W1,H2],[CP1,IP1],N).

focuspointslice2(topright,[X,Y,X1,Y1],[W1,W2,H1,H2],[FP,CP1,CP2],[horiz_first,IP1,IP2],[horiz,IP3],N):-
	% writeln('topright,horiz_first,horiz'),
	slice([X1,Y,W2,H1],[FP,IP1,IP3],N),
	split([X1,Y1,W2,H2],[IP2,IP1],[IP3,CP2],N),
	slice([X,Y1,W1,H2],[CP1,IP2],N).

 % bottomright

focuspointslice2(bottomright,[X,_,X1,Y1],[W1,W2,_,H2],[FP,CP1,CP2],[vert,IP1],[none],N):-
	% writeln('bottomright,vert,none'),
	slice([X1,Y1,W2,H2],[FP,IP1,CP2],N),
	slice([X,Y1,W1,H2],[CP1,IP1],N).

focuspointslice2(bottomright,[X,Y,X1,Y1],[W1,W2,H1,H2],[FP,CP1,CP2],[vert_first,IP1,IP2],[none],N):-
	% writeln('bottomright,vert_first,none'),
	slice([X,Y,W1,H1],[CP1,IP2],N),
	slice([X1,Y1,W2,H2],[FP,IP1,CP2],N),
	slice([X,Y1,W1,H2],[IP1,IP2],N).

focuspointslice2(bottomright,[X,Y,X1,Y1],[W1,W2,H1,H2],[FP,CP1,CP2],[horiz_first,IP1,IP2],[none],N):-
	% writeln('bottomright,horiz_first,none'),
	slice([X,Y,W1,H1],[CP1,IP2],N),
	slice([X1,Y,W2,H1],[IP2,IP1],N),
	slice([X1,Y1,W2,H2],[FP,IP1,CP2],N).

focuspointslice2(bottomright,[X,Y,X1,Y1],[W1,W2,H1,H2],[FP,CP1,CP2],[vert,IP1],[horiz,IP2],N):-
	% writeln('bottomright,vert,horiz'),
	slice([X1,Y,W2,H1],[IP2,CP2],N),
	slice([X1,Y1,W2,H2],[FP,IP1,IP2],N),
	slice([X,Y1,W1,H1],[CP1,IP1],N).

focuspointslice2(bottomright,[X,Y,X1,Y1],[W1,W2,H1,H2],[FP,CP1,CP2],[vert_first,IP1,IP2],[horiz,IP3],N):-
	% writeln('bottomright,vert_first,horiz'),
	slice([X,Y,W1,H1],[CP1,IP2],N),
	slice([X1,Y,W2,H1],[IP3,CP2],N),
	slice([X1,Y1,W2,H2],[FP,IP1,IP3],N),
	slice([X,Y1,W1,H1],[IP2,IP1],N).

focuspointslice2(bottomright,[X,Y,X1,Y1],[W1,W2,H1,H2],[FP,CP1,CP2],[horiz_first,IP1,IP2],[horiz,IP3],N):-
	% writeln('bottomright,horiz_first,horiz'),
	slice([X,Y,W1,H1],[CP1,IP2],N),
	split([X1,Y,W2,H1],[IP2,IP1],[IP3,CP2],N),
	slice([X1,Y1,W2,H2],[FP,IP1,IP3],N).

 % bottomleft

focuspointslice2(bottomleft,[X,Y,_,Y1],[W1,_,H1,H2],[FP,CP1,CP2],[horiz,IP1],[none],N):- % more cases like this?
	slice([X,Y,W1,H1],[CP1,IP1],N),
	slice([X,Y1,W1,H2],[FP,IP1,CP2],N).

focuspointslice2(bottomleft,[X,_,X1,Y1],[W1,W2,_,H2],[FP,CP1,CP2],[none],[vert,IP1],N):-
	% writeln('bottomleft,none,vert'),
	slice([X1,Y1,W2,H2],[IP1,CP2],N),
	slice([X,Y1,W1,H2],[FP,CP1,IP1],N).

focuspointslice2(bottomleft,[X,Y,X1,Y1],[W1,W2,H1,H2],[FP,CP1,CP2],[none],[vert_first,IP1,IP2],N):-
	% writeln('bottomleft,none,vert_first'),
	slice([X1,Y,W2,H1],[IP2,CP2],N),
	slice([X1,Y1,W2,H2],[IP1,IP2],N),
	slice([X,Y1,W1,H2],[FP,CP1,IP1],N).

focuspointslice2(bottomleft,[X,Y,X1,Y1],[W1,W2,H1,H2],[FP,CP1,CP2],[none],[horiz_first,IP1,IP2],N):-
	% writeln('bottomleft,none,horiz_first'),
	slice([X,Y,W1,H1],[IP1,IP2],N),
	slice([X1,Y,W2,H1],[IP2,CP2],N),
	slice([X,Y1,W1,H2],[FP,CP1,IP1],N).

focuspointslice2(bottomleft,[X,Y,X1,Y1],[W1,W2,H1,H2],[FP,CP1,CP2],[horiz,IP1],[vert,IP2],N):-
	% writeln('bottomleft,horiz,vert'),
	slice([X,Y,W1,H1],[CP1,IP1],N),
	slice([X1,Y1,W2,H2],[IP2,CP2],N),
	slice([X,Y1,W1,H2],[FP,IP1,IP2],N).

focuspointslice2(bottomleft,[X,Y,X1,Y1],[W1,W2,H1,H2],[FP,CP1,CP2],[horiz,IP1],[vert_first,IP2,IP3],N):-
	% writeln('bottomleft,horiz,vert_first'),
	slice([X,Y,W1,H1],[CP1,IP1],N),
	slice([X1,Y,W2,H1],[IP3,CP2],N),
	slice([X1,Y1,W2,H2],[IP2,IP3],N),
	slice([X,Y1,W1,H2],[FP,IP1,IP2],N).

focuspointslice2(bottomleft,[X,Y,X1,Y1],[W1,W2,H1,H2],[FP,CP1,CP2],[horiz,IP1],[horiz_first,IP2,IP3],N):-
	% writeln('bottomleft,horiz,horiz_first'),
	split([X,Y,W1,H1],[CP1,IP1],[IP2,IP3],N),
	slice([X1,Y,W2,H1],[IP3,CP2],N),
	slice([X,Y1,W1,H2],[FP,IP1,IP2],N).

focuspointslice2(_,_,_,_,_,_,_).
	% writeln('error, no case matched in focuspointslice2').
