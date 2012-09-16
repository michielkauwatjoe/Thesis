/*********************************************************************************
Name	: rgbtohsl
Date	: 30-07-03
Creator	: Amit Manniesing
Version	: 0.1
Use	: rgbtohsl([R,G,B],[H,S,L])

Description:
Converts a RGB color value to a HSL color value. This is an almost exact conversion,
during testing there were no rounding errors found. 
***********************************************************************************/

% hsltorgb([+H,+S,+L],[-R,-G,-B])
% first calculate to relative values and then apply algorithm
rgbtohsl([R,G,B],[H,S,L]):-
        Rr is R/255,
        Gr is G/255,
        Br is B/255,
        rgbhandler([Rr,Gr,Br],[Hr,Sr,Lr]),
        normalizehsl([Hr,Sr,Lr],[H,S,L]),
        true.

normalizehsl([Hr,Sr,Lr],[H,S,L]):-
        Htemp is Hr * 60,
        checkH(Htemp,H1),
        S1 is Sr * 255,
        L1 is Lr * 255,
        fix(H1,H),fix(S1,S),fix(L1,L),
        true.

checkH(H,H):-
        H >=0.
checkH(H,Hnew):-
        H < 0,
        Hnew is H + 360,
        true.

% if min=max we have grey and H is undefined (0), S is 0 and Lightness
% becomes any value of R,G or B
rgbhandler([Rr,Gr,Br],[0,0,Rr]):-
        minmax(Rr,Gr,Br,Min,Max),
        (Min=Max),
        true.

rgbhandler([Rr,Gr,Br],[Hr,Sr,Lr]):-
        minmax(Rr,Gr,Br,Min,Max),
        Lr is (Max + Min)/2,
        makeS(Min,Max,Lr,Sr),
        makeH(Rr,Gr,Br,Max,Min,Hr),
        true.

makeH(R,G,B,R,Min,Hr):-
        Hr is (G-B)/(R-Min),
        true.

makeH(R,G,B,G,Min,Hr):-
        Hr is 2.0 + (B-R)/(G-Min),
        true.

makeH(R,G,B,B,Min,Hr):-
        Hr is 4.0 + (R-G)/(B-Min),
        true.

makeS(Min,Max,Lr,Sr):-
        Lr < 0.5,
        Sr is (Max-Min)/(Max+Min),
        true.

makeS(Min,Max,Lr,Sr):-
        Lr >= 0.5,
        Sr is (Max-Min)/(2.0-Max-Min),
        true.

/**************************************************************/
minmax(X1,X2,X3,Min,Max):-
        min3(X1,X2,X3,Min),
        max3(X1,X2,X3,Max),
        true.

min3(X1,X2,X3,Min):-
        min(X1,X2,Xmin),
        min(Xmin,X3,Min).
max3(X1,X2,X3,Max):-
        max(X1,X2,Xmax),
        max(Xmax,X3,Max).


        
