% Test suite for Star Battle Solver
:- use_module(library(plunit)).
:- [projecto].

:- begin_tests(star_battle_tests).

test(solve_puzzle_9_2, [nondet]) :-
    regioes(9-2, E),
    inicial(9-2-1, Tab),
    resolve(E, Tab),
    limpaTabuleiro(Tab, Sol),
    Sol == [[p,p,p,p,p,p,e,p,e],
            [e,p,e,p,p,p,p,p,p],
            [p,p,p,p,e,p,p,e,p],
            [e,p,e,p,p,p,p,p,p],
            [p,p,p,p,e,p,e,p,p],
            [p,e,p,p,p,p,p,p,e],
            [p,p,p,e,p,e,p,p,p],
            [p,e,p,p,p,p,p,e,p],
            [p,p,p,e,p,e,p,p,p]].

test(solve_puzzle_9_24, [nondet]) :-
    regioes(9-24, E),
    inicial(9-24-1, Tab),
    resolve(E, Tab),
    limpaTabuleiro(Tab, Sol),
    Sol == [[p,p,p,p,e,p,p,e,p],
            [e,p,e,p,p,p,p,p,p],
            [p,p,p,p,p,e,p,e,p],
            [p,e,p,e,p,p,p,p,p],
            [p,p,p,p,p,p,e,p,e],
            [p,p,e,p,e,p,p,p,p],
            [e,p,p,p,p,p,e,p,p],
            [p,p,p,e,p,p,p,p,e],
            [p,e,p,p,p,e,p,p,p]].

:- end_tests(star_battle_tests).
