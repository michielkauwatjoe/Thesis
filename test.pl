% vim: set filetype=prolog :

run_guides_polygons(N):-
	main(single_shape_randomalign_rotate,polygons,[500,309],[[159,80],[0,200],[1000,340]],[200,250,250],[0,215,100],[guides,guides,guides],['blue',1],N),!.

run_guides_isometric(N):-
	main(single_shape_randomalign_rotate,isometric,[500,309],[[159,120],[0,300],[1000,240]],[200,250,250],[180,215,100],[guides,guides,guides],['blue',1],N),!.

run_guides_userset1(N):-
	main(single_shape_randomalign_rotate,userset1,[500,309],[[259,180],[0,380],[500,180]],[10,250,250],[130,215,100],[guides,guides,guides],['blue',1],N),!.

run_guides_userset2(N):-
	main(single_shape_randomalign_rotate,userset2,[500,309],[[259,180],[0,380],[500,180]],[0,250,250],[50,215,100],[guides,guides,guides],['blue',1],N),!.

run_noguides_polygons(N,W,H):-
	main(single_shape_randomalign_rotate,polygons,[W,H],[[259,180],[0,300],[W,H]],[200,250,250],[0,215,100],[none,none,none],['blue',1],N),!.

run_noguides_isometric(N):-
	main(single_shape_randomalign_rotate,isometric,[500,309],[[259,180],[0,300],[500,320]],[160,250,250],[130,215,100],[none,none,none],['blue',1],N),!.

run_noguides_userset1(N):-
	main(single_shape_randomalign_rotate,userset1,[500,309],[[259,280],[0,80],[500,80]],[250,250,250],[150,235,100],[none,none,none],['blue',1],N),!.

run_noguides_userset2(N):-
	main(single_shape_randomalign_rotate,userset2,[500,309],[[159,120],[0,180],[500,180]],[10,250,250],[50,215,100],[none,none,none],['blue',1],N),!.

run(testblue,N):-
	main(ssrar,isometric,[1000,618],[[459,180],[0,400],[1000,420]],[200,250,250],[150,215,100],[none,none,none],['blue',1],N),!.

run(test,N):-
	main(single_shape_randomalign_rotate,isometric,[1000,618],[[459,180],[0,400],[1000,420]],[80,250,250],[100,215,100],[guides,guides,guides],['blue',1],N),!.

run(ss,SETNAME,MODE,N):-
	run(single_shape,SETNAME,MODE,N),!.

run(ssra,SETNAME,MODE,N):-
	run(single_shape_randomalign,SETNAME,MODE,N),!.

run(ssrar,SETNAME,MODE,N):-
	run(single_shape_randomalign_rotate,SETNAME,MODE,N),!.

run(PATTERNNAME,SETNAME,noguides,N):-
	main(PATTERNNAME,SETNAME,[1000,618],[[559,180],[0,400],[1000,520]],[200,250,250],[0,215,100],[none,none,none],['blue',1],N),!.

run(PATTERNNAME,SETNAME,guides,N):-
	main(PATTERNNAME,SETNAME,[1000,618], [[459,80],[0,400],[1000,420]],[200,250,250],[0,215,100], [guides,guides,guides], ['blue',1],N),!.










% run(all_guides_8):-
	% main(singleshape, [1000,618], [[459,180],[0,400],[1000,420]],[200,250,250],[0,215,100], [guides,guides,guides], ['blue',1],9).
% 
% run(all_guides_9):-
	% main(singleshape, [1000,618], [[359,380],[0,400],[1000,220]],[200,250,250],[0,215,100], [guides,guides,guides], ['blue',1],9).
% 
% 
% run(no_guides_9):-
	% main(singleshape,[1000,618],[[359,380],[0,400],[1000,220]],[200,250,250],[0,215,100],[none,none,none],['blue',1],9).
% 
% run(newcolours):-
	% main(singleshape,[1000,618],[[359,380],[0,400],[1000,220]],[200,250,250],[150,215,100],[none,none,none],['blue',1],9).
% 
% 
% run(userset1):-
	% main(userset1, [1000,618], [[359,380],[0,400],[1000,220]],[200,250,250],[0,215,100], [guides,guides,guides], ['blue',1],5).
% 
% 
% run(scaling):-
	% main(singleshape, [1000,618], [[359,380],[0,400],[1000,220]],[200,250,250],[0,215,100], [guides,guides,none], ['blue',1],5).
