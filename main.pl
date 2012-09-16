% vim: set filetype=prolog :

:-[test].

:-[focuspointslice].
:-[linearslice].

:-[fill].
:-[shapes].

:-[colour].
:-[dec2hex].
:-[rgbtohsl].
:-[hsltorgb].

:-[util].
:-[draw].

which_prolog(Prolog) :-
        (delete(1,[1],[]) -> (
                % this is problable eclipse, I feel sure enough to 
                % call this rather eclipse specific get_flag/2 predicate
                get_flag(toplevel_module, eclipse), Prolog=eclipse
                );(
                % assume swi prolog if called with 'pl', fail otherwise
                current_prolog_flag(argv,[pl|_]), Prolog=swi
                )
        ).

init :-
         (which_prolog(eclipse) -> (
                set_flag(print_depth,2000),
                compile('compat-eclipse')
            );(
                compile('compat-swi')
            )
        ).

:- init.

% :-lib(fd).

main(PATTERNNAME,SETNAME,[CX,CY],LEADINGLINE,BGSCHEME,FGSCHEME,[RENDERINGPR,RENDERINGLL,RENDERINGBB],[STROKECOLOUR,STROKEWIDTH],DEPTH):-

	set_global_parameters(PATTERNNAME,SETNAME,BGSCHEME,FGSCHEME,[RENDERINGPR,RENDERINGLL,RENDERINGBB],[STROKECOLOUR,STROKEWIDTH],DEPTH),

	open('svggen.svg',write,FILE),
	asserta(svgfile(FILE)),

	header,
	draw_canvas([CX,CY],BGSCHEME),
	slice([0,0,CX,CY],LEADINGLINE,DEPTH),!,
	render_leadingline(LEADINGLINE),		%render LL afterwards to display on top
	footer,

	close(FILE).


set_global_parameters(PATTERNNAME,SETNAME,BGSCHEME,FGSCHEME,[RENDERINGPR,RENDERINGLL,RENDERINGBB],[STROKECOLOUR,STROKEWIDTH],DEPTH):-


	asserta(phi(1.618034)),
	asserta(is_type(polygons,basic)),
	asserta(is_type(isometric,basic)),
	asserta(is_type(userset1,path)),
	asserta(is_type(userset2,path)),
	asserta(patternname(PATTERNNAME)),
	asserta(setname(SETNAME)),
	asserta(depth(DEPTH)),
	asserta(rendering(RENDERINGPR,RENDERINGLL,RENDERINGBB)),
	asserta(bgscheme(BGSCHEME)),
	asserta(fgscheme(FGSCHEME)),
	asserta(stroke(STROKECOLOUR,STROKEWIDTH)),

	get_shapelist(SETNAME,SHAPELIST), asserta(shapelist(SETNAME,SHAPELIST)),
	generate_colourset1(BGSCHEME,FGSCHEME,DEPTH,COLOURLIST),!, asserta(colourlist(COLOURLIST)).

slice(_,_,0).

% focuspoint slice
slice(SLICE,LL,N):-
	length(LL,3),!,

	get_colour(N,COLOUR),

	fill_slice(SLICE,COLOUR,fps,LL,N),

	N1 is N - 1,
	focuspointslice(SLICE,LL,N1).


% linear slice
slice(SLICE,LL,N):-
 length(LL,2),!,

	get_colour(N,COLOUR),
	fill_slice(SLICE,COLOUR,ls,LL,N),

	N1 is N - 1,
	straightline_slice(SLICE,LL,N1).


	clear:-
		retract_all(phi(_)),
		retract_all(is_type(_,_)),
		retract_all(patternname(_)),
		retract_all(setname(_)),
		retract_all(depth(_)),
		retract_all(rendering(_,_,_)),
		retract_all(bgscheme(_)),
		retract_all(fgscheme(_)),
		retract_all(stroke(_,_)),
		retract_all(shapelist(_,_)),
		retract_all(colourlist(_)).
