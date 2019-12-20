mushed([],[],[]).

mushed([X|Xs], Ys, [X|Zs]) :- 
    mushed(Xs, Ys, Zs).

mushed(Xs, [Y|Ys], [Y|Zs]) :- 
    mushed(Xs, Ys, Zs).