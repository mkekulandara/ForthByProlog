% forth.pl
% Version 1.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% definition of our target language (a stack machine):
%
%	PROG ::= [ CMDS ]
%		| [ ]
%
%	CMDS ::= CMD
%		| CMD , CMDS
%
%	CMD ::= DICTIONARY
%		| COMPUTE
%
%	DICTIONARY ::= variable(x)
%		| define(f,BODY)
%
%	BODY ::= [ BODYCMDS ]
%		| [ ]
%
%	BODYCMDS ::= COMPUTE
%		| COMPUTE , BODYCMDS
%
%	COMPUTE ::= VAL
%		| add
%		| sub
%		| mult
%		| and
%		| or
%		| invert
%		| eq
%		| le
%		| dot
%		| bang
%		| at
%		| dup
%		| if(BODYCMDS)
%		| while(BODYCMDS)
%		| call(f)
%
%	VAL ::= x | n | true | false
%
% for convenience sake make seq infix and left associative
:- op(1200,yfx,seq).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% some basic definitions
:- ['preamble.pl'].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% we need the definition of predicate 'xis' for the 
% evaluation of our terms.
:- ['xis.pl'].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% semantic definition of the forth commands

([],State) -->> State :- !.

([Instr|P],State) -->> OState :- 
	(Instr,State) -->> IState,
	(P,IState) -->> OState,!.

(variable(X),(Stk,Dict)) -->> (Stk,ODict) :-
	dput(X,0,Dict,ODict),!.
	
(define(F,C),(Stk,Dict)) -->> (Stk,ODict) :-
	dput(F,C,Dict,ODict),!.

(N,(Stk,Dict)) -->> ([N|Stk],Dict) :-       
    int(N),!.

(true,(Stk,Dict)) -->> ([true|Stk],Dict) :- !.

(false,(Stk,Dict)) -->> ([false|Stk],Dict) :- !.

(add,([ValB,ValA|Stk],Dict)) -->> ([Val|Stk],Dict) :-  
    int(ValA),
    int(ValB),
    Val xis ValA + ValB,!.

(sub,([ValB,ValA|Stk],Dict)) -->> ([Val|Stk],Dict) :-  
    int(ValA),
    int(ValB),
    Val xis ValA - ValB,!.

(mult,([ValB,ValA|Stk],Dict)) -->> ([Val|Stk],Dict) :- 
    int(ValA),
    int(ValB),
    Val xis ValA * ValB,!.

(eq,([ValB,ValA|Stk],Dict)) -->> ([Val|Stk],Dict) :-  
    int(ValA),
    int(ValB),
    Val xis (ValA =:= ValB),!.

(le,([ValB,ValA|Stk],Dict)) -->> ([Val|Stk],Dict) :-  
    int(ValA),
    int(ValB),
    Val xis (ValA =< ValB),!.
	
(and,([ValB,ValA|Stk],Dict)) -->> ([Val|Stk],Dict) :-  
    bool(ValA),
    bool(ValB),
    Val xis (ValA and ValB),!.

(or,([ValB,ValA|Stk],Dict)) -->> ([Val|Stk],Dict) :-  
    bool(ValA),
    bool(ValB),
    Val xis (ValA or ValB),!.
	
(invert,([ValA|Stk],Dict)) -->> ([Val|Stk],Dict) :-  
    bool(Val),
    Val xis (not(ValA)),!.
	
(dot,([Top|Stk],Dict)) -->> (Stk,Dict) :-
    write('Top of stack is '),
    writeln(Top),!. 
	
(bang,([X,Val|Stk],Dict)) -->> (Stk,ODict) :-
    dput(X,Val,Dict,ODict),!.

(at,([X|Stk],Dict)) -->> ([ValX|Stk],Dict) :-
    dlookup(X,Dict,ValX),!.	
	
(dup,([Top|Stk],Dict)) -->> ([Top,Top|Stk],Dict) :- !.

(if(C),([true|Stk],Dict)) -->> OState :-
    (C,(Stk,Dict)) -->> OState,!.

(if(_),([false|Stk],Dict)) -->> OState :- 
	OState = (Stk,Dict),!.

(while(C),([true|Stk],Dict)) -->> OState :-
    (C,(Stk,Dict)) -->> S1,
    (while(C),S1) -->> OState,!.

(while(_),([false|Stk],Dict)) -->> OState :-
    OState = (Stk,Dict),!.

(call(F),(Stk,Dict)) -->> (OStk,ODict) :- 
	dlookup(F,Dict,C),
	(C,(Stk,Dict)) -->> (OStk,ODict),!.

(X,(Stk,Dict)) -->> ([X|Stk],Dict) :- 
	dlookup(X,Dict,_),!.	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the predicate 'dlookup(+Variable,+Dict,-Value)' looks up
% the variable in the binding dictionary and returns its bound value.
:- dynamic dlookup/3.                % modifiable predicate

dlookup(_,s0,0).

dlookup(X,dict([],S),Val) :-
    dlookup(X,S,Val).

dlookup(X,dict([bind(Val,X)|_],_),Val).

dlookup(X,dict([_|Rest],S),Val) :-
    dlookup(X,dict(Rest,S),Val).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the predicate 'dput(+Variable,+Value,+State,-FinalState)' adds
% a binding term to the state.
:- dynamic dput/4.                   % modifiable predicate

dput(X,Val,dict(L,S),dict([bind(Val,X)|L],S)).

dput(X,Val,S,dict([bind(Val,X)],S)) :- 
	atom(S).