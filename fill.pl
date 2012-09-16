% vim: set filetype=prolog :

 % fps = focuspoint slice
 % ls = linear slice

fill_slice(_,_,_,_,_):- patternname(none).

fill_slice(SLICE,COLOUR,TYPE,LEADINGLINE,DEPTH):-
	patternname(PATTERNNAME),
	setname(SETNAME),


	fill(PATTERNNAME,SETNAME,SLICE,COLOUR,TYPE,LEADINGLINE,DEPTH).


% fills with single shape, always in topleft corner
fill(single_shape,SETNAME,[X,Y,W,H],COLOUR,_,_,_):-
	get_shapes(SETNAME,[COORDS1,BB1]),

	rescale_to_fit(BB1,W,H,FACTOR,_),
	BB2 = [FACTOR|BB1],					% scaling factor included to reverse stroke scaling
	is_type(SETNAME,TYPE),

	draw_transformations([TYPE,[COORDS1,BB2]],COLOUR,[[translation|[[X,Y]]],[scale,[FACTOR]]],1).


% fills with single shape, randomly aligns to one of four corners
fill(single_shape_randomalign,SETNAME,[X,Y,W,H],COLOUR,_,_,_):-
	get_shapes(SETNAME,[COORDS1,BB1]),

	rescale_to_fit(BB1,W,H,FACTOR,RESCALE_DIRECTION),
	transform_to_align(BB1,[X,Y,W,H],FACTOR,RESCALE_DIRECTION,TRANSLATION),

	% scaling factor included to reverse stroke scaling
	BB2 = [FACTOR|BB1],
	is_type(SETNAME,TYPE),

	draw_transformations([TYPE,[COORDS1,BB2]],COLOUR,[[translation|[TRANSLATION]],[scale,[FACTOR]]],1).


% fills with single shape, randomly aligns to one of four corners, rotates quarters
fill(single_shape_randomalign_rotate,SETNAME,[X,Y,W,H],COLOUR,_,_,_):-
	get_shapes(SETNAME,[COORDS1,BB1]),

	get_rotationvalues(BB1,[ROTATION,TRANSLATION1]),
	rescale_to_fit(BB1,W,H,FACTOR,RESCALE_DIRECTION),
	transform_to_align(BB1,[X,Y,W,H],FACTOR,RESCALE_DIRECTION,TRANSLATION2),

	% scaling factor included to reverse stroke scaling
	BB2 = [FACTOR|BB1],
	is_type(SETNAME,TYPE),

	draw_transformations([TYPE,[COORDS1,BB2]],COLOUR,[[translation|[TRANSLATION2]],[scale,[FACTOR]],[translation|[TRANSLATION1]],[rotation,[ROTATION]]],1).


% fill(multiple_shapes,SETNAME,[X,Y,W,H],COLOUR,fps,LL,N).

% fills linear slice with multiple shapes
% fill(multiple_shapes,SETNAME,SLICE,COLOUR,ls,LL,N):-
% 
	% get_shapes(SETNAME,[COORDS1,BB]),
% 
	% rescale_to_fit(BB,W,H,FACTOR1,_),
	% FACTOR2 is FACTOR1 / N,
% 
	% get_translationvalues(LL,BB,FACTOR,N,TRANSLATIONS),
% 
	% % scaling factor included to reverse stroke scaling
	% BB2 = [FACTOR1|BB],
	% is_type(SETNAME,TYPE),
% 
	% draw_transformations([TYPE,[COORDS1,BB2]],COLOUR,[[translation|[[X,Y]]],[scale,[FACTOR2]]],N).


% get_translationvalues(LL,[W1,H1],FACTOR,N,TRANSLATIONS):-
% 
	% get_leadingline_width(LL,W2,H2),
% 
	% HSS is (W2 - W1) / N, % horiz. stepsize
	% VSS is (H2 - H1) / N, % horiz. stepsize


% get_leadingline_width_and_height([[CP1X,CP1Y],[CP2X,CP2Y]],W,H):-
	% get_leadingline_width([CP1X,CP2X],W),
	% get_leadingline_height([CP1Y,CP2Y]],H).
% 
% 
% get_leadingline_width([CP1X,CP2X],W):-
	% CP1X =< CP2X,
	% W is CP2X - CP1X.
% 
% get_leadingline_width([CP1X,CP2X],W):-
	% CP1X > CP2X,
	% W is CP1X - CP2X.
% 
% get_leadingline_height([CP1Y,CP2Y],H):-
	% CP1Y =< CP2Y,
	% H is CP2Y - CP1Y.
% 
% get_leadingline_height([CP1Y,CP2Y],H):-
	% CP1Y > CP2Y,
	% H is CP1Y - CP2Y.


get_rotationvalues(BB,[ROTATION,TRANSLATION]):-
	LIST = [90, 180, 270, 360],
	random(R),
	mod(R,4,I1),
	I2 is I1 + 1,
	nth(I2,LIST,ROTATION),
	get_translationvalue(I2,BB,TRANSLATION).

get_translationvalue(1,[WIDTH,_],[WIDTH,0]).
get_translationvalue(2,BB,BB).
get_translationvalue(3,[_,HEIGHT],[0,HEIGHT]).
get_translationvalue(4,_,[0,0]).

% switch width & height of BB
% reset_boundingbox([W,H],90,[H,W]).
% reset_boundingbox(BB1,180,BB1).
% reset_boundingbox([W,H],270,[H,W]).
% reset_boundingbox(BB1,360,BB1).


transform_to_align([WIDTH,_],[X,Y,W,_],FACTOR,vertically,[X2,Y]):-
	X1 is X + W - (WIDTH * FACTOR),
	LIST = [X,X1],
	random(R),
	mod(R,2,I1),
	I2 is I1 + 1,
	nth(I2,LIST,X2).

transform_to_align([_,HEIGHT],[X,Y,_,H],FACTOR,horizontally,[X,Y2]):-
	Y1 is Y + H - (HEIGHT * FACTOR),
	LIST = [Y,Y1],
	random(R),
	mod(R,2,I1),
	I2 is I1 + 1,
	nth(I2,LIST,Y2).


rescale_to_fit([WIDTH_SHAPE,HEIGHT_SHAPE],WIDTH_SLICE,HEIGHT_SLICE,FACTOR,vertically):-

	RATIO_SHAPE is HEIGHT_SHAPE / WIDTH_SHAPE,
	RATIO_SLICE is HEIGHT_SLICE / WIDTH_SLICE,

	RATIO_SLICE =< RATIO_SHAPE,

	FACTOR is HEIGHT_SLICE / HEIGHT_SHAPE.


rescale_to_fit([WIDTH_SHAPE,HEIGHT_SHAPE],WIDTH_SLICE,HEIGHT_SLICE,FACTOR,horizontally):-

	RATIO_SHAPE is HEIGHT_SHAPE / WIDTH_SHAPE,
	RATIO_SLICE is HEIGHT_SLICE / WIDTH_SLICE,

	RATIO_SLICE >= RATIO_SHAPE,

	FACTOR is WIDTH_SLICE / WIDTH_SHAPE.





% shape_pattern(sl,singleshape_pattern,[X,Y,_,_],COLOUR,_,N):-
	% get_shapes(SHAPE1),
% 
	% % some arbitrary rescaling
	% rescale_points(25,SHAPE1,SHAPE2),
% 
% 
	% get_translations(X,Y,0,0,1,TRANSLATIONS),
	% get_skews(1,SKEWSX),
	% get_skews(1,SKEWSY),
% 
	% draw_transformations(SHAPE2,COLOUR,[[skewX|SKEWSX],[skewY|SKEWSY],[translation|TRANSLATIONS]],1).


% shape_pattern(circularpattern,[X,Y,_,_],COLOUR,[[_,_],[CP1X,CP1Y],[CP2X,CP2Y]],N).
	% get_shapes(SHAPE1),
	% rescale_points(20,SHAPE1,SHAPE2), ln(N,LN), rescale_points(LN,SHAPE2,SHAPE3),
% 
	% H_STEPSIZE is (CP2X - CP1X)/N, % can also be negative?
	% V_STEPSIZE is (CP2Y - CP1Y)/N,
% 
	% R_STEPSIZE is 360/N,
% 
	% get_translations(X,Y,H_STEPSIZE,V_STEPSIZE,N,TRANSLATIONS),
	% get_rotations(R_STEPSIZE,N,ROTATIONS),
% 
	% draw_transformations(SHAPE3,COLOUR,[[rotation|ROTATIONS],[translation|TRANSLATIONS]],N).



% shape_pattern(linearpattern,[X,Y,_,_],COLOUR,[[CP1X,CP1Y],[CP2X,CP2Y]],N):-
	% get_shapes(SHAPE1),
% 
	% % some arbitrary rescaling
	% rescale_points(25,SHAPE1,SHAPE2), ln(N,LN), rescale_points(LN,SHAPE2,SHAPE3),
% 
% 
	% H_STEPSIZE is (CP2X - CP1X)/N, % can also be negative?
	% V_STEPSIZE is (CP2Y - CP1Y)/N,
% 
	% R_STEPSIZE is 180/N,
% 
	% get_translations(X,Y,H_STEPSIZE,V_STEPSIZE,N,TRANSLATIONS),
	% get_rotations(R_STEPSIZE,N,ROTATIONS),
% 	
	% get_skews(N,SKEWSX),
	% get_skews(N,SKEWSY),
% 
	% draw_transformations(SHAPE3,COLOUR,[[skewX|SKEWSX],[skewY|SKEWSY],[translation|TRANSLATIONS],[rotation|ROTATIONS]],N).


