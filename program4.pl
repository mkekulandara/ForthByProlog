% program4.pl
:- ['preamble.pl'].
:- ['forth.pl'].
:- >>> 'Output of the following program :'.
:- >>> '[define(inc,[1,add]),variable(x),10,call(inc),x,bang,x,at,dot]'.

:- ([define(inc,[1,add]),variable(x),10,call(inc),x,bang,x,at,dot],([],_))-->>(_,_),!.