% prove that [a,b,add] ~ [b,a,add]
% with a and b either variables or integer values.
%
% show that
% (forall e,a,b,s)(exists V0,V1)
%    [([a,b,add],(s,e))-->>([V0|s],e) ^
%     [b,a,add],(s,e))-->>([V1|s],e) ^
%     V0=V1]
% assuming
% (a,(Stk,Dict)) -->> ([va|Stk],Dict).
% (b,(Stk,Dict)) -->> ([vb|Stk],Dict).
%

% load semantics
:- ['forth.pl'].

% assumptions
:- asserta((a,(Stk,Dict)) -->> ([va|Stk],Dict)).
:- asserta((b,(Stk,Dict)) -->> ([vb|Stk],Dict)).
% we also have to assume that the values are integers for add's sake'
:- asserta(int(va)).
:- asserta(int(vb)).

% assumption on integer addition commutativity
:- asserta(comm(A + B, B + A)).

% proof
:- ([a,b,add],(s,e))-->>([V0|s],e),
   ([b,a,add],(s,e))-->>([V1|s],e),
   comm(V0,V1),!.


