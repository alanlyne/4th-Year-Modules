%Jan 2018
%Define a Prolog predicate mul/3 (+,+,-) which is true when, given
%three lists, the length of the third is the product of the lengths
%of the first two.

mul(List1, List2, List3) :- % This is a rule where :- (if) says if the item on the right is true, then so is the item on the left
    length(List1, X),   % Get the length of a list1 and assigns value to X
    length(List2, Y),   % Get the length of a list2 and assigns value to Y
    length(List3,Z),    % Get the length of a list3 and assigns value to Z
    X*Y =:= Z.  % =:= (Check for equality between expressions)

%?- mul([a,b],[a,b,c],[w,x,y,z,p,d])
%yes
%?- mul([a,b],[b,c],Xs)
%Xs = [_,_,_,_,_,_]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Autumn 2018
%Define a Prolog predicate scissor/4 which is true when a list
%(first arg) is split into two pieces (3rd and 4th arg) at a given
%element (third arg).

scissors(List1, C, List2, List3) :- % This is a rule where :- (if) says if the item on the right is true, then so is the item on the left
    append(List2, [C|List3], List), %% Concatenate (Append) 2 lists into "List" 
    List = List1.

%?- scissors([a,b,c,d,e,f],c,[a,b],[d,e,f]).
%yes