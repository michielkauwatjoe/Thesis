% vim: set filetype=prolog :


% uses hsltorgb and rgbtohex by Amit Maniessing


generate_colourset1([BGH,BGS,BGL],[FGH,FGS,FGL],N,COLOURLIST):-
	get_HSLstepsize(BGH,FGH,N,SSH),
	get_HSLstepsize(BGS,FGS,N,SSS),
	get_HSLstepsize(BGL,FGL,N,SSL),

	generate_colourset2([BGH,BGS,BGL],[FGH,FGS,FGL],[SSH,SSS,SSL],N,COLOURLIST).


generate_colourset2(_,_,_,0,[]).

generate_colourset2([BGH,BGS,BGL],[FGH,FGS,FGL],[SSH,SSS,SSL],N1,[COLOUR|TAIL]):-

	HUE is BGH + N1*SSH,
	SAT is BGS + N1*SSS,
	LI is BGL + N1*SSL,

	hsl2hex([HUE,SAT,LI],COLOUR),!,
	N2 is N1 - 1,

	generate_colourset2([BGH,BGS,BGL],[FGH,FGS,FGL],[SSH,SSS,SSL],N2,TAIL).


get_HSLstepsize(VALUE1,VALUE2,N,STEPSIZE):-
	DIFF is VALUE2-VALUE1,
	STEPSIZE is DIFF / N.


get_colour(_,COLOUR):-

	colourlist(COLOURLIST),
	length(COLOURLIST,L1),
	random(R),
	L2 is L1 + 1,
	mod(R,L2,I),
	nth(I,COLOURLIST,COLOUR).


hsl2hex([H,S,L],Hex):-
	hsltorgb([H,S,L],RGB),
	rgb2hex(RGB,Hex).
