% program3.pl
:- ['preamble.pl'].
:- ['forth.pl'].
:- >>> 'Output of the following program :'.
:- >>> '[10,dup,0,eq,invert,while([dup,dot,1,sub,dup,0,eq,invert])]'.

:- ([10,dup,0,eq,invert,while([dup,dot,1,sub,dup,0,eq,invert])],([],_))-->>(_,_),!.