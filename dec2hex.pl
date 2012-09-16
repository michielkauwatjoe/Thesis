/*************************************************************************
Name    : dec2hex
Date    : 07-02-2003
Creator : Amit Manniesing
Version : 0.4
Use     : dec2hex(1023,Output).
Description:
Converts a decimal input in to hexadecimal (Base = 16), Base can be altered
for binary, octal etc... system 
07-03-03 : Added readability comments
**************************************************************************/

%:-lib(lists).
% rgb2hex([+R,+G,+B],-Hex)
% converts one colour to Hex

rgb2hex([R,G,B],Hex):-
  dec2hex(R,Rout),
  dec2hex(G,Gout),
  dec2hex(B,Bout),
  addzero(Rout,Rfull),
  addzero(Gout,Gfull),
  addzero(Bout,Bfull),
  concat_string(['#',Rfull,Gfull,Bfull],Hex),
  true.

hex2rgb(Hex,[R,G,B]):-
        append_strings("#",Without,Hex),
        substring(Without,1,2,Rhex),
        substring(Without,3,2,Ghex),
        substring(Without,5,2,Bhex),
        value(Rhex,R),
        value(Ghex,G),
        value(Bhex,B),
        true.

% addzeor(+In,-Out)
% if length = 1, adds leading zero
addzero(In,Out):-
  string_length(In,1), !,
  concat_string(["0",In],Out).
addzero(In,In).

