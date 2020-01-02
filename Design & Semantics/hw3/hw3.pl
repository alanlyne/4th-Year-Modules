mushed([],[],[]).

mushed([X|Xs], Ys, [X|Zs]) :- 
    mushed(Xs, Ys, Zs).

mushed(Xs, [Y|Ys], [Y|Zs]) :- 
    mushed(Xs, Ys, Zs).

circular([_|_], []). 
circular([H|L1], L2) :- 
    append([H|L1], L3, L2), circular([H|L1], L3).