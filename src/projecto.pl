% Star Battle (Two Not Touch) Prolog Solver
% Author: David Vasques
:- use_module(library(clpfd)). % transpose/2
:- set_prolog_flag(answer_write_options, [max_depth(0)]).
:- [puzzles].
:- [codigoAuxiliar].

% Segue-se o código
%%%%%%%%%%%%


%---------------------------------------------------------------------
% visualiza/1
% visualiza(Lista)
% Descrição: Predicado que permite escrever, por linha, cada elemento da lista Lista.
% Argumento:
%   -Lista: Uma lista.
visualiza([]):- !.
visualiza([H|T]):- 
    write(H),
    nl,
    visualiza(T).

% visualizaLinha/1
% visualizaLinha(Lista)
% Descrição: Predicado que permite escrever, por linha, cada elemento da lista Lista, aparecendo antes o número da linha
% em causa, um “:” e um espaço.
%   - Linha: Uma lista.
visualizaLinha([]).
visualizaLinha([H|T]):-
    visualizaLinhaAux([H|T], 1).

% visualizaLinhaAux/2
% visualizaLinhaAux(Lista, N)
% Descrição: Predicado auxiliar que imprime cada elemento da lista com a numeração das colunas.
% Argumentos:
%   - Lista: Uma lista.
%   - N: Número da coluna atual.
visualizaLinhaAux([], _).
visualizaLinhaAux([H|T], N):-
    N1 is N + 1,
    write(N), write(": "), write(H), nl,
    visualizaLinhaAux(T, N1).

%---------------------------------------------------------------------
% insereObjecto/3
% insereObjecto(Coordenada, Tabuleiro, Objeto)
% Descrição: Predicado que insere um objeto em uma coordenada específica do tabuleiro.
% Argumentos:
%   - Coordenada: Par (L, C) representando a linha e coluna.
%   - Tabuleiro: Lista de listas representando o tabuleiro.
%   - Objeto: Objeto a ser inserido na coordenada.
insereObjecto(_, [], _).
insereObjecto((L,C), Tabuleiro, Obj):-
    length(Tabuleiro, Dim),
    L > 0, L =< Dim, C > 0, C =< Dim,
    nth1(L, Tabuleiro, Linha),
    nth1(C, Linha, Coluna),
    var(Coluna), !,
    Coluna = Obj;
    true.

% insereVariosObjectos/3
% insereVariosObjectos(ListaCoords, Tabuleiro, ListaObjs)
% Descrição: Predicado que insere vários objetos em várias coordenadas do tabuleiro.
% Argumentos:
%   - ListaCoords: Lista de pares (L, C) representando as coordenadas.
%   - Tabuleiro: Lista de listas representando o tabuleiro.
%   - ListaObjs: Lista de objetos a serem inseridos nas coordenadas.
insereVariosObjectos([], _, []) :- !.
insereVariosObjectos([(L,C)|T], Tabuleiro, [Obj|TObj]):-
    length([(L,C)|T], DimCoor), length([Obj|TObj], DimObj),
    DimCoor == DimObj,
    insereObjecto((L,C), Tabuleiro, Obj),
    insereVariosObjectos(T, Tabuleiro, TObj).

% inserePontosVolta/2
% inserePontosVolta(Tabuleiro, Coordenada)
% Descrição: Predicado que insere pontos ao redor de uma coordenada específica do tabuleiro.
% Argumentos:
%   - Tabuleiro: Lista de listas representando o tabuleiro.
%   - Coordenada: Par (L, C) representando a linha e coluna.
inserePontosVolta([], _) :- !.
inserePontosVolta(Tabuleiro, (L,C)):-
    L1 is L - 1, L2 is L + 1,
    C1 is C - 1, C2 is C + 1,
    insereVariosObjectos([(L1,C1),(L1,C),(L1,C2),(L,C1),(L,C2),(L2,C1),(L2,C),(L2,C2)], Tabuleiro, [p,p,p,p,p,p,p,p]).

% inserePontos/2
% inserePontos(Tabuleiro, ListaCoord)
% Descrição: Predicado que insere pontos em várias coordenadas do tabuleiro.
% Argumentos:
%   - Tabuleiro: Lista de listas representando o tabuleiro.
%   - ListaCoord: Lista de pares (L, C) representando as coordenadas.
inserePontos([],_).
inserePontos(Tabuleiro, [(L,C)|T]):-
    length([(L,C)|T], Len),
    length(Objs, Len),
    maplist(=(p), Objs),
    insereVariosObjectos([(L,C)|T], Tabuleiro, Objs).

%---------------------------------------------------------------------
% objectosEmCoordenadas/3
% objectosEmCoordenadas(ListaCoords, Tabuleiro, ListaObjs)
% Descrição: Predicado que obtém os objetos presentes em várias coordenadas do tabuleiro,
% sendo os objetos apresentados na mesma ordem das coordenadas fornecidas.
% Argumentos:
%   - ListaCoords: Lista de pares (L, C) representando as coordenadas.
%   - Tabuleiro: Lista de listas representando o tabuleiro.
%   - ListaObjs: Lista de objetos presentes nas coordenadas.
objectosEmCoordenadas([], _, []):- !.
objectosEmCoordenadas([(L,C)|T], Tabuleiro, [Coluna|TObj]):-
    nth1(L, Tabuleiro, Linha),
    nth1(C, Linha, Coluna),
    objectosEmCoordenadas(T, Tabuleiro, TObj).

% coordObjectos/5
% coordObjectos(Objecto, Tabuleiro, ListaCoords, ListaCoordObjs, NumObjectos)
% Descrição: Predicado que obtém todas as coordenadas de um objeto específico, tal como ocorrem no tabuleiro.
% Argumentos:
%   - Objecto: Objeto a ser procurado.
%   - Tabuleiro: Lista de listas representando o tabuleiro.
%   - ListaCoords: Lista de pares (L, C) representando as coordenadas.
%   - ListaCoordObjs: Lista de coordenadas onde o objeto foi encontrado, ordenada por linhas e colunas.
%   - NumObjectos: Número de objetos encontrados.
coordObjectos(_, _, [], [], 0):- !.
coordObjectos(Objecto, Tabuleiro, [(L,C)|T], ListaCoordObjs, NumObjectos):-
    objectosEmCoordenadas([(L,C)|T], Tabuleiro, [Objectos|_]),
    (Objectos == Objecto; var(Objectos), var(Objecto)), !,
    coordObjectos(Objecto, Tabuleiro, T, TListaCoordObjs, _),
    ListaCoordObjs1 = [(L,C)|TListaCoordObjs],
    sort(1, @=<, ListaCoordObjs1, ListaCoordObjs),
    length(ListaCoordObjs, NumObjectos);
    coordObjectos(Objecto, Tabuleiro, T, ListaCoordObjs, NumObjectos).

% coordenadasVars/2
% coordenadasVars(Tabuleiro, ListaVars)
% Descrição: Predicado que obtém as coordenadas das variáveis no tabuleiro.
% Argumentos:
%   - Tabuleiro: Lista de listas representando o tabuleiro.
%   - ListaVars: Lista de pares (L, C) representando as coordenadas das variáveis, ordenada por linhas e colunas.
coordenadasVars([], []).
coordenadasVars(Tabuleiro, ListaVars):-
    findall((L,C), (nth1(L, Tabuleiro, Linha), nth1(C, Linha, Elem), var(Elem)), ListaVars).

%---------------------------------------------------------------------
% h1/2
% h1(Tabuleiro, ListaCoord)
% Descrição: Predicado que insere pontos no tabuleiro nas coordenadas especificadas, seguindo a estratégia h1.
% Argumentos:
%   - Tabuleiro: Lista de listas representando o tabuleiro.
%   - ListaCoord: Lista de pares (L, C) representando as coordenadas.
h1([], []).
h1(Tabuleiro, ListaCoord) :-
    inserePontos(Tabuleiro, ListaCoord).

% h2/2
% h2(Tabuleiro, ListaCoord)
% Descrição: Predicado que insere um objeto 'e' e pontos ao redor de uma coordenada específica do tabuleiro, seguindo a estratégia h2.
% Argumentos:
%   - Tabuleiro: Lista de listas representando o tabuleiro.
%   - ListaCoord: Lista de pares (L, C) representando as coordenadas.
h2([], []).
h2(Tabuleiro, [(L,C)|_]) :-
    insereObjecto((L,C), Tabuleiro, e),
    inserePontosVolta(Tabuleiro, (L,C)).

% h3/2
% h3(Tabuleiro, ListaCoord)
% Descrição: Predicado que insere um objeto 'e' e pontos ao redor de várias coordenadas do tabuleiro, seguindo a estratégia h3.
% Argumentos:
%   - Tabuleiro: Lista de listas representando o tabuleiro.
%   - ListaCoord: Lista de pares (L, C) representando as coordenadas.
h3([], []).
h3(Tabuleiro, [(L,C)|T]) :-
    insereObjecto((L,C), Tabuleiro, e),
    inserePontosVolta(Tabuleiro, (L,C)),
    h3(Tabuleiro, T).

% fechaListaCoordenadas/2
% fechaListaCoordenadas(Tabuleiro, ListaCoord)
% Descrição: Predicado que substitui as variáveis da ListaCoord, por estrelas ou pontos, seguindo uma das estratégias(h1, h2, h3).
% Argumentos:
%   - Tabuleiro: Lista de listas representando o tabuleiro.
%   - ListaCoord: Lista de pares (L, C) representando as coordenadas.
fechaListaCoordenadas([], []).
fechaListaCoordenadas(Tabuleiro, ListaCoord):-
    coordObjectos(e, Tabuleiro, ListaCoord, _, NumEstrelas),
    coordenadasVars(Tabuleiro, ListaVarsTemp),
    include({ListaCoord}/[(L, C)]>>member((L, C), ListaCoord), ListaVarsTemp, ListaVars),
    length(ListaVars, NumVariaveis),
    ((NumEstrelas == 2, h1(Tabuleiro, ListaCoord));
    (NumEstrelas == 1, NumVariaveis == 1, h2(Tabuleiro, ListaVars));
    (NumEstrelas == 0, NumVariaveis == 2, h3(Tabuleiro, ListaVars));
    true),!.

% fecha/2
% fecha(Tabuleiro, ListaCoord)
% Descrição: Predicado que aplica fechaListaCoordenadas a cada Lista de ListaListasCoord.
% Argumentos:
%   - Tabuleiro: Lista de listas representando o tabuleiro.
%   - ListaListasCoord: Lista de listas de pares (L, C) representando as coordenadas.
fecha(_, []) :- !.
fecha(Tabuleiro, [ListaCoord|T]) :-
    fechaListaCoordenadas(Tabuleiro, ListaCoord),
    fecha(Tabuleiro, T).

%---------------------------------------------------------------------
% sublista/2
% sublista(SubLista, Lista)
% Descrição: Predicado que verifica se uma lista é sublista de outra.
% Argumentos:
%   - SubLista: Lista que pode ser sublista.
%   - Lista: Lista principal.
sublista([], []).
sublista(SubLista, Lista) :-
    append(_, Resto, Lista),
    append(SubLista, _, Resto), !.

% encontraSequencia/4
% encontraSequencia(Tabuleiro, N, ListaCoords, Seq)
% Descrição: Predicado que encontra uma sequência de variáveis na ListaCoords.
% Argumentos:
%   - Tabuleiro: Lista de listas representando o tabuleiro.
%   - N: Número de variáveis na sequência.
%   - ListaCoords: Lista de pares (L, C) representando as coordenadas.
%   - Seq: Sequência de coordenadas encontrada.
encontraSequencia([], 0, [], []).
encontraSequencia(Tabuleiro, N, ListaCoords, Seq):-
    coordenadasVars(Tabuleiro, ListaVars),
    include({ListaVars}/[(L, C)]>>member((L, C), ListaVars), ListaCoords, Seq),
    sublista(Seq, ListaCoords),
    coordObjectos(_, Tabuleiro, Seq, _, NumVars),
    NumVars == N,
    coordObjectos(e, Tabuleiro, ListaCoords, _, NumEstrelas),
    NumEstrelas =:= 0, !.

%---------------------------------------------------------------------
% aplicaPadraoI/2
% aplicaPadraoI(Tabuleiro, ListaCoord)
% Descrição: Predicado que aplica o padrão I no tabuleiro, ou seja após a aplicação deste predicado, Tabuleiro será o resultado de colocar 
% uma estrela (e) em (L1, C1) e (L3, C3) e os obrigatórios pontos (p) à volta de cada estrela.
% Argumentos:
%   - Tabuleiro: Lista de listas representando o tabuleiro.
%   - [(L1, C1), (L2, C2), (L3, C3)]: Lista de pares (L, C) representando as coordenadas.
aplicaPadraoI(_,[]) :- !.
aplicaPadraoI(Tabuleiro, [(L1, C1), _, (L3, C3)]) :-
    insereVariosObjectos([(L1, C1), (L3, C3)], Tabuleiro, [e, e]),
    inserePontosVolta(Tabuleiro, (L1, C1)),
    inserePontosVolta(Tabuleiro, (L3, C3)), !.

% aplicaPadroes/2
% aplicaPadroes(Tabuleiro, ListaCoord)
% Descrição: Predicado que procura sequências de tamanho 3 ou de 4, e aplica o respectivo padrão associado, padrãoI ou padrãoT.
% Argumentos:
%   - Tabuleiro: Lista de listas representando o tabuleiro.
%   - ListaListaCoords: Lista de listas de pares (L, C) representando as coordenadas.
aplicaPadroes(_, []) :- !.
aplicaPadroes(Tabuleiro, [ListaCoord|T]) :-
    (encontraSequencia(Tabuleiro, 3, ListaCoord, Seq3), aplicaPadraoI(Tabuleiro, Seq3);
    encontraSequencia(Tabuleiro, 4, ListaCoord, Seq4), aplicaPadraoT(Tabuleiro, Seq4);
    true),
    aplicaPadroes(Tabuleiro, T).

%---------------------------------------------------------------------
% resolve/2
% resolve(Estruturas, Tabuleiro)
% Descrição: Predicado que resolve o puzzle aplicando padrões e fechando listas de coordenadas.
% Argumentos:
%   - Estruturas: Lista de estruturas do puzzle.
%   - Tabuleiro: Lista de listas representando o tabuleiro.
resolve(_, []) :- !.
resolve(Estruturas, Tabuleiro) :-
    coordTodas(Estruturas, ListaCoord),
    coordenadasVars(Tabuleiro, ListaVarsAntigas),
    aplicaPadroes(Tabuleiro, ListaCoord),
    fecha(Tabuleiro, ListaCoord),
    coordenadasVars(Tabuleiro, ListaVarsNovas),
    ListaVarsAntigas \= ListaVarsNovas, 
    resolve(Estruturas, Tabuleiro), !; true.
