%Define a predicate mushed/3 which is true when its three arguments, 
%all lists, has the third list containing all elements of the first two arguments, in order.

mushed([],[],[]).

mushed([A|As], Bs, [A|Cs]) :- 
    mushed(As, Bs, Cs).

mushed(As, [B|Bs], [B|Cs]) :- 
    mushed(As, Bs, Cs).

%Define circular/2 which is true when its first argument is a non-empty list 
%and its second argument is a list consisting of zero or more appended copies of the first argument.
circular([_|_], []). 

circular([A|List1], List2) :- 
    append([A|List1], List3, List2), circular([A|List1], List3).