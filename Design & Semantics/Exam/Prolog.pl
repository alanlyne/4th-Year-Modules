%Jan 2019
%Define the Prolog predicate runs/1 which is true of lists whose
%elements each have an identical adjacent element.

runs([]). % True if list is empty
runs([X,X|Y]) :- % True if the 1st two elements in list are the same (X,X) 
    runs(Y). % |Y is the tail of the list and will run the program again with the tail Y.
runs([X,X,X|Y]) :- % True if the 1st two elements in list are the same (X,X) 
    runs(Y). %|Y is the tail of the list and will run the program again with the tail Y.

%?- runs([a,a,b,b,b,c,c,d,d,d,d,e,e]).
%true.
%?- runs([a,a,b,b,b,c,X,d,d,d,d,e,e]).
%X=c
%?- runs([a,a,b,b,b,c,c,X,d,d,d,e,e]).
%X=c 
%X=d
%?- runs([a]).
%false.
%?- runs([]).
%true.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Aug 2019
%Define a Prolog predicate tworthree/2 which is true when the first 
%list it is passed is identical to the second list except each element 
%in the first list has been duplicated either two or three times.

tworthree([],[]).   % True if both lists ar empty.
tworthree([X|A],[X,X|B]) :- % X is head of list and A is the tail (For first list). 
    tworthree(A,B). %Checks if the 1st two elements in 2nd list are the same (X,X) as the previous list first element. Then buts the tail into B.
tworthree([X|A],[X,X,X|B]) :- 
    tworthree(A,B). % Same as above but checks if first 3 in sendond list are the same.

%?- tworthree([a,b,c,d],[a,a,b,b,c,c,d,d,d]).
%true.
%?- tworthree(X,[a,a,b,b,c,c,d,d,d]).
%X = [a,b,c,d] ? 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Jan 2018
%Define a Prolog predicate mul/3 (+,+,-) which is true when, given
%three lists, the length of the third is the product of the lengths
%of the first two.

mul(List1, List2, List3) :- % This is a rule where :- (if) says if the item on the right is true, then so is the item on the left
    length(List1, X),       % Get the length of a list1 and assigns value to X
    length(List2, Y),       % Get the length of a list2 and assigns value to Y
    length(List3,Z),        % Get the length of a list3 and assigns value to Z
    X*Y =:= Z.              % =:= (Check for equality between expressions)

%?- mul([a,b],[a,b,c],[w,x,y,z,p,d])
%yes
%?- mul([a,b],[b,c],Xs)
%Xs = [_,_,_,_,_,_]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Autumn 2018
%Define a Prolog predicate scissor/4 which is true when a list
%(1st arg) is split into two pieces (3rd and 4th arg) at a given
%element (2nd arg).

scissors(List1, C, List2, List3) :- % This is a rule where :- (if) says if the item on the right is true, then so is the item on the left
    append(List2, [C|List3], List), % Put C onto the top of List3. Then add that and List2 together and call it List. 
    List = List1. % Checks if lists are the same

%?- scissors([a,b,c,d,e,f],c,[a,b],[d,e,f]).
%yes

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Jan 2016
%Define a Prolog predicate noah/3 which is true of three lists when
%corresponding elements of the first two lists, which are of the
%same length are lined up two-by-two on the third list. 

noah([],[],[]).
noah([H1|T1],[H2|T2],[H1,H2|T3]) :- noah(T1,T2,T3).

%noah([ ],[ ],[ ]).
%noah([a,b,c,d],[abb,bee,cee,dee],[a,abb,b,bee,c,cee,d,dee]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Prolog
%Define a Prolog predicate path(X,Y,G), where path(-,-,+), which
%is true when there is a path from node X to node Y in a directed
%graph G, where the graph is represented by a list of edges, each
%represented by a two-element list of the source and destination nodes.

path(X,Y,Z):-
    walk(X, Y, Z, Z).

walk(X, Y, [[X,Y|_]|_], _).
    
walk(X, Y, [[X,C|_]|_], Z):-
    walk(C, Y, Z, Z).

walk(X, Y, [_|G], Z):-
    walk(X, Y, G, Z).
    
% path(b, Y ,[[a,x],[b,a],[b,d],[d,e]]).
% Y = a
% Y = x
% Y = d
% Y = e

% CAREFUL OF LOOOPS ie. path(b, Y ,[[a,x],[x,b],[b,a]]).  -->  Y = x, b, a, x, b, .......
%no loop answer 

paths(X, Y, [[X,Y|_]|_]).
    
paths(X, Y, [[X,C|_]|G]):-
    paths(C, Y, G).

paths(X, Y, [_|G]):-
    paths(X, Y, G).
    
% paths(b, Y ,[[a,x],[b,a],[b,d],[d,e]]).
% Y = a
% Y = d
% Y = e
