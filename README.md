# ForthByProlog
Implemantation of the Forth Programming language by Prolog

PROG ::= [ CMDS ]
| [ ]
CMDS ::= CMD
| CMD , CMDS
CMD ::= DICTIONARY
1
| COMPUTE
DICTIONARY ::= variable(x)
| define(f,BODY)
BODY ::= [ BODYCMDS ]
| [ ]
BODYCMDS ::= COMPUTE
| COMPUTE , BODYCMDS
COMPUTE ::= VAL
| add
| sub
| mult
| and
| or
| invert
| eq
| le
| dot
| bang
| at
| dup
| if(BODYCMDS)
| while(BODYCMDS)
| call(f)
VAL ::= x | n | true | false
