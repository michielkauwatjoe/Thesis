/*********************************************************************************
Name	: hsltorgb
Date	: 17-02-03
Creator	: Amit Manniesing
Version	: 0.3
Use	: convert([H,S,L],X). 
 	  eg. convert([12,34,78],X).
Description:
Converts a HSL color value to a RGB color value. This is an almost exact conversion,
during testing there were no rounding errors found. 

Based on:

  HOW TO RETURN hsl.to.rgb(h, s, l):
       SELECT:
  l<=0.5: PUT l*(s+1) IN temp2
  ELSE: PUT l+s-l*s IN temp2
       PUT l*2-temp2 IN Temp1
       PUT colorval(temp1, temp2, h+1/3) IN r
       PUT colorval(temp1, temp2, h    ) IN g
       PUT colorval(temp1, temp2, h-1/3) IN b
       RETURN (r, g, b)

    HOW TO RETURN colorval(temp1, temp2, h):
       IF h<0: PUT h+1 IN h
       IF h>1: PUT h-1 IN h
       IF h*6<1: RETURN temp1+(temp2-temp1)*h*6
       IF h*2<1: RETURN temp2
       IF h*3<2: RETURN temp1+(temp2-temp1)*(2/3-h)*6
       RETURN m1

17-02-03: Error found with Magenta, is now removed, was probably located in 
rounding temp3, or calculating temp2. Also removed the rounds in normalize 
to get more precize values.
27-02-03: Changed convert to hsltorgb, because of the use of cshsltorgb
07-03-03: Added extra comment
***********************************************************************************/

%:- module(hsltorgb).
%:- export hsltorgb/2.

% hsltorgb([+H,+S,+L],[-R,-G,-B])
% first calculate to relative values and then apply algorithm
hsltorgb([H,S,L],[R,G,B]):-
        Hr is H/360,
        Sr is S/255,
        Lr is L/255,
        handler([Hr,Sr,Lr],[Rr,Gr,Br]),
        normalize([Rr,Gr,Br],[R,G,B]).


% normalize([+Rr,+Gr,+Br],[-R,-G,-B])
normalize([Rr,Gr,Br],[R,G,B]):-
        R1 is Rr*255,
        G1 is Gr*255,
        B1 is Br*255,
        fix(R1,R),
        fix(G1,G),
        fix(B1,B).

handler([_Hr,0.0,Lr],[Lr,Lr,Lr]).            % is grey
handler([Hr,Sr,Lr],[R,G,B]):-
        calculatetemp2(Lr,Sr,Temp2),
        calculatetemp1(Temp2,Lr,Temp1),
        rtemp3(Hr,Rtemp3),
        Gtemp3 is Hr,
        btemp3(Hr,Btemp3),
        colorval(Temp1,Temp2,Rtemp3,R),
        colorval(Temp1,Temp2,Gtemp3,G),
        colorval(Temp1,Temp2,Btemp3,B).

colorval(Temp1,Temp2,Temp3,Color):-
        Check is Temp3*6,
        Check < 1.0,
        Color is Temp1 + (Temp2 - Temp1)*6.0*Temp3.
colorval(_,Temp2,Temp3,Temp2):-
        Check is Temp3*2,
        Check < 1.0.
colorval(Temp1,Temp2,Temp3,Color):-
        Check is Temp3 * 3.0,
        Check < 2.0,
        Color is Temp1 + (Temp2-Temp1)*((2.0/3.0)-Temp3)*6.0.
colorval(Temp1,_,_,Temp1).

/*************** temp 3 ***************
        These values are actually the h +/- 1/3 in the above
        comment, with the normalizing included
        ******************************************************/
rtemp3(Hr,Rtemp3):-
        Hr =< 2/3,
        Rtemp3 is Hr + 1/3.
rtemp3(Hr,Rtemp3):-
        Hr > 2/3,
        Rtemp3 is Hr - 2/3.  % is +1/3 - 1
btemp3(Hr,Btemp3):-
        Hr >= 1/3,
        Btemp3 is Hr - 1/3.
btemp3(Hr,Btemp3):-
        Hr < 1/3,
        Btemp3 is Hr + 2/3.  % is -1/3 + 1

/**************** temp 2 **************/
calculatetemp2(Lr,Sr,Temp2):-
        Lr < 0.5,
        Temp2 is (Sr + 1.0)*Lr.
calculatetemp2(Lr,Sr,Temp2):-
        Lr >= 0.5,
        Temp2 is (Lr+Sr)-(Lr*Sr).

/************** temp 1 ***************/
calculatetemp1(Temp2,Lr,Temp1):-
        Temp1 is (2*Lr) - Temp2.

