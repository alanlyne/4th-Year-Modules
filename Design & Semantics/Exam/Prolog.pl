%Aug 2019
%Define a Prolog predicate tworthree/2 which is true when the first 
%list it is passed is identical to the second list except each element 
%in the first list has been duplicated either two or three times.

tworthree([],[]).   % vacuously true
tworthree([X|A],[X,X|B])   :- tworthree(A,B). % duplicated 2 times
tworthree([X|A],[X,X,X|B]) :- tworthree(A,B). % duplicated 3 times

%?- tworthree([a,b,c,d],[a,a,b,b,c,c,d,d,d]).
%true.
%?- tworthree(X,[a,a,b,b,c,c,d,d,d]).
%X = [a,b,c,d] ? 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Jan 2019
%Define the Prolog predicate runs/1 which is true of lists whose
%elements each have an identical adjacent element.

runs([]).
runs([X,X|Y]) :- runs(Y).
runs([X,X,X|Y]) :- runs(Y).

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
    append(List2, [C|List3], List), %% Concatenate (Append) 2 lists into "List" 
    List = List1.

%?- scissors([a,b,c,d,e,f],c,[a,b],[d,e,f]).
%yes