% vim: set filetype=prolog :

draw_canvas([X,Y],COLOUR):-
	hsl2hex(COLOUR,COLOURHEX),
	svgfile(SVGfile),
	write(SVGfile,'<rect x="0" y="0" width="'), write(SVGfile,X),
	write(SVGfile,'" height="'), write(SVGfile,Y),
	write(SVGfile,'" fill="'), write(SVGfile,COLOURHEX),
	write(SVGfile,'" stroke="none" stroke-width="0"></rect>'),nl(SVGfile).

header:-
	svgfile(SVGfile),
	write(SVGfile,'<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>'),nl(SVGfile),
	write(SVGfile,'<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.0//EN" "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd">'),nl(SVGfile),
	write(SVGfile,'<svg '),
	write(SVGfile,' xmlns="http://www.w3.org/2000/svg"'),
	write(SVGfile,'>'),nl(SVGfile).

footer:-
	svgfile(SVGfile),
	write(SVGfile,'</svg>').


% FRAMEWORK RENDERING PREDICATES
%
%

% render proportional lines

draw_proportions(_,_,_,_):- rendering(none,_,_).

draw_proportions(Slice,Xoffset,Yoffset,_):-

	rendering(guides,_,_),
	stroke(Colour,Width),
	draw_proportions2(Slice,Xoffset,Yoffset,Colour,Width).


draw_proportions2([X,Y,W,_],none,Yoffset,Colour,Width):-

	X1 is X, Y1 is Y + Yoffset,
	X2 is X + W,

	draw_polyline([[X1,Y1],[X2,Y1]], 'none', Colour, Width).

draw_proportions2([X,Y,_,H],Xoffset,none,Colour,Width):-

	X1 is X + Xoffset, Y1 is Y,
	Y2 is Y + H,

	draw_polyline([[X1,Y1],[X1,Y2]], 'none', Colour, Width).

draw_proportions2([X,Y,W,H], Xoffset, Yoffset,Colour,Width):-

	X1 is X + Xoffset, Y1 is Y + H,
	Y2 is Y + Yoffset, X2 is X + W,

	draw_polyline([[X1,Y],[X1,Y1]],'none',Colour,Width),
	draw_polyline([[X,Y2],[X2,Y2]],'none',Colour,Width).


% render initial leadingline

render_leadingline(_):- rendering(_,none,_).

render_leadingline([[FX,FY],[CP1X,CP1Y],[CP2X,CP2Y]]):-
	rendering(_,guides,_),
	draw_IP([FX,FY]), draw_IP([CP1X,CP1Y]), draw_IP([CP2X,CP2Y]),
	draw_leadingline([[FX, FY],[CP1X,CP1Y],[CP2X,CP2Y]]).


draw_leadingline([A,B,C]):-
	stroke(COLOUR,WIDTH),
	draw_polyline([A,B],'none',COLOUR,WIDTH),
	draw_polyline([A,C],'none',COLOUR,WIDTH).


% render new intersection points on leading line

draw_newIPs(_):- rendering(_,none,_).

draw_newIPs([none]):-
	rendering(_,guides,_).

draw_newIPs([_,[X1,Y1],[X2,Y2]]):-
	rendering(_,guides,_),
	draw_IP([X1,Y1]),draw_IP([X2,Y2]).

draw_newIPs([_,[X,Y]]):-
	rendering(_,guides,_),
	draw_IP([X,Y]).


draw_IP([X,Y]):-
	svgfile(SVGfile),
	stroke(COLOUR,WIDTH),
	write(SVGfile,'<g transform="translate('), write(SVGfile,X), write(SVGfile,','), write(SVGfile,Y), write(SVGfile,')">'),
	write(SVGfile,'<ellipse cx="0" cy="0" rx="2" ry="2" fill="white" stroke="'), write(SVGfile,COLOUR), write(SVGfile,'" stroke-width="'), write(SVGfile,WIDTH),
	write(SVGfile,'"></ellipse>'),
	% write(SVGfile,'<text id="title" x="0" y="0" dx="5">focus point</text>'),
	write(SVGfile,'</g>'),nl(SVGfile).

% draws bounding box around shape/pattern

draw_boundingbox(_):-
	rendering(_,_,none).

draw_boundingbox([SCALEFACTOR|[WIDTH,HEIGHT]]):-
	rendering(_,_,guides),
	stroke(COLOUR,STROKE_WIDTH1),

	% quick hack to keep stroke width of bounding box the same after scaling
	STROKE_WIDTH2 is STROKE_WIDTH1 / SCALEFACTOR,

	draw_polyline([[0,0],[WIDTH,0],[WIDTH,HEIGHT],[0,HEIGHT],[0,0]],'none',COLOUR,STROKE_WIDTH2).

% draw_boundingbox([WIDTH,HEIGHT]):-
	% rendering(_,_,guides),
	% stroke(COLOUR,STROKE_WIDTH),
	% draw_polyline([[0,0],[WIDTH,0]],'none',COLOUR,STROKE_WIDTH),
	% draw_polyline([[WIDTH,0],[WIDTH,HEIGHT]],'none',COLOUR,STROKE_WIDTH),
	% draw_polyline([[WIDTH,HEIGHT],[0,HEIGHT]],'none',COLOUR,STROKE_WIDTH),
	% draw_polyline([[0,HEIGHT],[0,0]],'none',COLOUR,STROKE_WIDTH).

% PREDICATES FOR WRITING SHAPES AND TRANSFORMATIONS
%
%

% empty translation value list
draw_transformations(_,_,_,0).

draw_transformations([TYPE,[COORDS,BB]],COLOUR,LIST1,N):-
	svgfile(SVGfile),
	write(SVGfile,'<g transform="'),
	draw_transformations2(LIST1,LIST2),
	write(SVGfile,'">'),
	draw_shape([TYPE,[COORDS,BB]],COLOUR),
	write(SVGfile,'</g>'),nl(SVGfile),
	N1 is N - 1,
	draw_transformations([TYPE,[COORDS,BB]],COLOUR,LIST2,N1).

draw_transformations2([],[]).

draw_transformations2([[MODE|[VALUE|VALUES]]|[]],[[MODE|VALUES]|[]]):-
	draw_transformation(MODE,VALUE).

draw_transformations2([[MODE|[VALUE|VALUES]]|TAIL],[[MODE|VALUES]|RETURNEDLIST]):-
	draw_transformation(MODE,VALUE),
	draw_transformations2(TAIL,RETURNEDLIST).

draw_transformation(translation,[X,Y]):-
	svgfile(SVGfile),
	write(SVGfile,'translate('), write(SVGfile,X), write(SVGfile,','), write(SVGfile,Y), write(SVGfile,') ').

draw_transformation(scale,[S]):-
	svgfile(SVGfile),
	write(SVGfile,'scale('), write(SVGfile,S), write(SVGfile,') ').

draw_transformation(rotation,[R]):-
	svgfile(SVGfile),
	write(SVGfile,'rotate('), write(SVGfile,R), write(SVGfile,') ').

draw_transformation(skewX,[X]):-
	svgfile(SVGfile),
	write(SVGfile,'skewX('), write(SVGfile,X), write(SVGfile,') ').

draw_transformation(skewY,[Y]):-
	svgfile(SVGfile),
	write(SVGfile,'skewY('), write(SVGfile,Y), write(SVGfile,') ').



draw_shape([basic,[COORDS,BB]],COLOUR):-
	draw_boundingbox(BB),
	draw_polyline(COORDS,COLOUR,'none',0).

draw_shape([path,[COORDS,BB]],COLOUR):-
	draw_boundingbox(BB),
	draw_path1(COORDS,COLOUR,'none',0).

draw_polyline([],_,_,_).

draw_polyline(Points, Fill, Stroke, Stroke_width):-
	svgfile(SVGfile),
	write(SVGfile,'<polyline '),
	write(SVGfile,'points="'), draw_pointlist(Points), write(SVGfile,'" '),
	write(SVGfile,'fill="'), write(SVGfile,Fill), write(SVGfile,'" '),
	write(SVGfile,'stroke="'), write(SVGfile,Stroke), write(SVGfile,'" '),
	write(SVGfile,'stroke-width="'), write(SVGfile,Stroke_width), write(SVGfile,'"'),
	write(SVGfile,'></polyline>'),nl(SVGfile).


draw_polygon([],_,_,_).

draw_polygon(Points, Fill, Stroke, Stroke_width):-
	svgfile(SVGfile),
	write(SVGfile,'<polygon '),
	write(SVGfile,'points="'), draw_pointlist(Points), write(SVGfile,'" '),
	write(SVGfile,'fill="'), write(SVGfile,Fill), write(SVGfile,'" '),
	write(SVGfile,'stroke="'), write(SVGfile,Stroke), write(SVGfile,'" '),
	write(SVGfile,'stroke-width="'), write(SVGfile,Stroke_width), write(SVGfile,'"'),
	write(SVGfile,'></polygon>'),nl(SVGfile).

draw_pointlist([]).

draw_pointlist([[X,Y]|Tail]):-
	svgfile(SVGfile),
	write(SVGfile,X), write(SVGfile,','), write(SVGfile,Y), write(SVGfile,' '),
	draw_pointlist(Tail).


draw_path1([],_,_,_).

draw_path1([HEAD|TAIL],COLOUR,STROKE,STROKEWIDTH):-
	draw_path2(HEAD,COLOUR,STROKE,STROKEWIDTH),
	draw_path1(TAIL,COLOUR,STROKE,STROKEWIDTH).


draw_path2(PATH, Fill, Stroke, Stroke_width):-
	svgfile(SVGfile),
	write(SVGfile,'<path '),
	write(SVGfile,'fill="'), write(SVGfile,Fill), write(SVGfile,'" '),
	write(SVGfile,'stroke="'), write(SVGfile,Stroke), write(SVGfile,'" '),
	write(SVGfile,'stroke-width="'), write(SVGfile,Stroke_width), write(SVGfile,'" '),
	write(SVGfile,'d="'), write(SVGfile,PATH), write(SVGfile,'"'),
	write(SVGfile,'/>'),nl(SVGfile).
