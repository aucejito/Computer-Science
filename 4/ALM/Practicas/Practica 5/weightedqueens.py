# -*- coding: utf-8 -*-
#Alberto Hernández Pellicer
#Juan Antonio López Ramírez
#4CO-21
import numpy as np
import random
import heapq # a priority queue, es un minheap
import argparse
import time

def pessimistic(N,weights):
    return sum(max(weights[row,col] for col in range(N))
               for row in range(N))

def evaluate(s,weights):
    return sum(weights[row,col] for row,col in enumerate(s))

def show_solution(s,N,weights):
    print("    "+"".join("%5d" % c for c in  range(N)))
    for r in range(N):
        print("%3d %s" % (r,"".join((" %4d" % (weights[r,c]))
                                              if s[r]==c else "   --"
                                              for c in range(N))))
    print("+".join(str(weights[r,c]) for r,c in enumerate(s)),"=",
          evaluate(s,weights))

def backtracking(N,weights):
    # weights es una matriz NxN
    assert((type(weights) is np.ndarray) and (weights.shape == (N,N)))
    bestSolution, bestScore = None, pessimistic(N,weights)
    def is_promising(s, newcol):
        # si tenemos el estado s = [1,3,0]
        # en row 0 la reina va en col 1
        # en row 1 la reina va en col 3
        # en row 2 la reina va en col 0
        # check if a new queen can be put in coordinate [newrow,newcol]
        newrow = len(s)
        return all(newcol != col and newrow-row != abs(newcol-col)
                   for row,col in enumerate(s))
    def back(s):
        nonlocal bestSolution, bestScore
        if len(s) == N:
            current = evaluate(s,weights)
            if current < bestScore:
                bestScore = current
                bestSolution = s
        else:
            for col in range(N):
                if is_promising(s, col):
                    back(s+[col])
    back([])
    return bestSolution, bestScore

def optimisticSimple(s,weights,parentScore):
    # parentScore es la puntuacion del padre de s
    # weights es una matriz NxN con los pesos de poner la reina en cada una de las culumnas
    # s es la solucion actual

    opt = 0 # COMPLETAR, CALCULAR DE MANERA INCREMENTAL

    posPadre = len(s)-1

    PuntuacionConocida = parentScore

    PuntuacionDesconocida = weights[posPadre][s[-1]]

    PuntuacionActualMala = min(weights[posPadre][j] for j in range(N))

    opt = PuntuacionConocida - PuntuacionActualMala + PuntuacionDesconocida

    return opt
    
def optimisticVert(s,weights,parentScore):
    #Infty=2**30
    # parte conocida:
    #opt = sum(weights[row,col] for row,col in enumerate(s))
    # cota optimista de la parte que nos queda por completar:
    # COMPLETAR, se aconseja usar min con un iterador y el argumetno default

    visitados = set()
    PuntuacionConocida = 0

    for row,col in enumerate(s):
        visitados.add(col)
        PuntuacionConocida += weights[row,col]


    for i in range(len(s), N):
        PuntuacionConocida += min(weights[i][j] for j in range(N) if j not in visitados)
    

    return PuntuacionConocida

def optimisticEllaborate(s,weights,parentScore):
    Infty=2**30
    # la diagonal ppal:
    #     c0 c1 c2 c3
    #    -------------
    # r0 | 0| 1| 2| 3|
    #    -------------
    # r1 |-1| 0| 1| 2|
    #    -------------
    # r2 |-2|-1| 0| 1|
    #    -------------
    # r3 |-3|-2|-1| 0|
    #    -------------
    # esto se consigue para [r,c] con el valor c-r

    # la diagonal inversa:
    #     c0 c1 c2 c3
    #    -------------
    # r0 |-3|-2|-1|0 |
    #    -------------
    # r1 |-2|-1| 0| 1|
    #    -------------
    # r2 |-1| 0| 1| 2|
    #    -------------
    # r3 | 0| 1| 2| 3|
    #    -------------
    # se consigue con r+c-(N-1)
    vertical = set()
    diagonalPrincipal = set()
    diagonalSecundaria = set()
    PuntuacionConocida = 0

    for row,col in enumerate(s):
        vertical.add(col)
        diagonalPrincipal.add(col-row)
        diagonalSecundaria.add(col+row)
        PuntuacionConocida += weights[row,col]


    for i in range(len(s), N):
        PuntuacionConocida += min((weights[i][j] for j in range(N) 
                                    if j not in vertical and 
                                    j-i not in diagonalPrincipal and 
                                    i+j not in diagonalSecundaria), default=Infty)
    

    return PuntuacionConocida

def branchAndBound(N,weights,
                   verbosity=0,
                   explicitPruning=False,
                   reportStatistics=False,
                   optimistic=optimisticSimple):
    # weights es una matriz NxN
    assert((type(weights) is np.ndarray) and (weights.shape == (N,N)))

    def branch(s):
        # COMPLETAR, solamente debe ramificar las columnas no amenazadas
        columna = set()
        diagonalPrincipal = set()
        diagonalSecundaria = set()

        for i in range(0,len(s)):
            val = s[i]
            columna.add(val)
            diagonalPrincipal.add(val-i)
            diagonalSecundaria.add(i+val)

            #and col-s[col] not in diagonalPrincipal and s[col]+col not in diagonalSecundaria
            

        return [s+[col] for col in range(N) if col not in columna and col-len(s) not in diagonalPrincipal and len(s)+col not in diagonalSecundaria] #comprobamos que la columna que vamos a coger no se haya cogido aún

    def is_complete(s):
        return len(s)==N

    def initial_score():
        return sum(min(weights[row][col] for col in range(N))
                   for row in range(N))

    def implicit():
        A = [] # empty priority queue
        x = None
        fx = pessimistic(N,weights)

        # anyadimos el estado inicial:
        s = []
        opt = initial_score()
        heapq.heappush(A,(opt,s))

        # bucle principal de ramificacion y poda con PODA IMPLICITA
        maxA = 0
        iter = 0
        while len(A)>0 and A[0][0] < fx:
            score_s,s = heapq.heappop(A)
            lenA = len(A) + 1
            iter += 1
            if lenA > maxA:
                maxA = lenA
            if verbosity > 1:
                print("Iter. %04d |A|=%05d max|A|=%05d fx=%04d len(s)=%02d score_s=%04d" % \
                    (iter,lenA,maxA,fx,len(s),score_s))
            for child in branch(s): #Ramificamos en cada una de las posibles soluciones
                if is_complete(child): # si es terminal
                    # seguro que es factible
                    # falta ver si mejora la mejor solucion en curso
                    opt_child = evaluate(child,weights)
                    if opt_child < fx:
                        if verbosity > 0:
                            print("MEJORAMOS",x,fx,"CON",child,opt_child)
                        x, fx = child, opt_child
                else: # no es terminal
                    # la función optimistic recibe como 3er argumento
                    # el score del padre para poder realizar el
                    # cálculo de manera incremental:
                    opt_child = optimistic(child,weights,score_s)
                    # lo metemos en el cjt de estados activos si supera
                    # la poda por cota optimista:
                    if opt_child < fx:
                        heapq.heappush(A,(opt_child,child))
        if verbosity > 0:
            print("%4d Iterations, max|A|=%05d" % (iter,maxA))
        return x,fx

    def explicit():
        A = [] # empty priority queue
        x = None
        fx = pessimistic(N,weights)

        # anyadimos el estado inicial:
        s = []
        opt = initial_score()
        heapq.heappush(A,(opt,s))

        maxA = 0
        iter = 0
        while len(A)>0: #PODA EXPLICITA
            score_s,s = heapq.heappop(A)
            lenA = len(A)+1
            iter += 1
            if lenA > maxA:
                maxA = lenA
            if verbosity > 1:
                print("Iter. %04d |A|=%05d max|A|=%05d fx=%04d len(s)=%02d score_s=%04d" % \
                      (iter,lenA,maxA,fx,len(s),score_s))
            for child in branch(s):
                if is_complete(child):
                    opt_child = evaluate(child, weights)
                    if opt_child < fx:
                        if verbosity > 0:
                            print("MEJORAMOS",x,fx,"CON",child,opt_child)
                        x, fx = child, opt_child
                        antiguolenA = len(A)
                        #HACER AQUI PODA EXPLICITA
                        A = [x for x in A if x[0] < fx]
                        nuevolenA = len(A)
                        print("La poda explicita baja |A| de %d a %d" % (antiguolenA, nuevolenA))
                        heapq.heapify(A)

                else:
                    opt_child = optimistic(child, weights, score_s)
                    if opt_child < fx:
                        heapq.heappush(A, (opt_child, child))

        if verbosity > 0:
            print("%4d Iterations, max|A|=%05d" % (iter,maxA))

        return x,fx
    
    return explicit() if explicitPruning else implicit()

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-v", "--verbosity", help="increase output verbosity",
                        type=int, choices=[0,1,2], default = 0)
    parser.add_argument("--seed", help="seed of random number generator", type=int, default=1234)
    parser.add_argument("-N", help="chess board size", type=int)
    parser.add_argument("--Nmin", help="minimum chess board size", type=int, default=4)
    parser.add_argument("--Nmax", help="maximum chess board size", type=int, default=10)
    parser.add_argument("-W", help="maximum weight", type=int, default=9999)
    parser.add_argument("-w", "--weights", help="show weights",
                        action="store_true", default=False)
    parser.add_argument("-o", "--optimistic", help="Type of optimistic function (simple, vert, ellaborate)", default="simple", choices=["simple","vert","ellaborate"])
    parser.add_argument("-s", "--statistics", help="Report statistic information",
                        action="store_true")
    parser.add_argument("-b", "--backtracking", help="Also computes solution with backtracking",
                        action="store_true", default=False)
    parser.add_argument("-i", "--implicit", help="Also computes solution B&B implicit pruning",
                        action="store_true", default=False)
    parser.add_argument("-e", "--explicit", help="Also computes solution B&B explicit pruning",
                        action="store_true", default=False)
    args = parser.parse_args()
    random.seed(args.seed)
    np.random.seed(args.seed)
    N = args.N if args.N != None else random.randint(args.Nmin,args.Nmax)
    weights = np.random.randint(args.W, size=(N,N))
    optimistic = optimisticSimple
    if args.optimistic.lower() == 'vert':
        optimistic = optimisticVert
    elif args.optimistic.lower() == 'ellaborate':
        optimistic = optimisticEllaborate
    print("N",N)
    if args.weights:
        print("weights")
        print(weights)
    if args.backtracking:
        print("Probamos con backtracking:")
        time_backtracking_start = time.process_time()
        x,fx = backtracking(N,weights)
        time_backtracking_stop = time.process_time()
        print(x,fx,"(ellapsed time %.5f)" %
              (time_backtracking_stop-time_backtracking_start,))
        show_solution(x,N,weights)
    if args.implicit:
        print("Ahora probamos con branch and bound poda implícita:")
        time_bbimplicit_start = time.process_time()
        x,fx = branchAndBound(N,weights,
                              optimistic = optimistic,
                              reportStatistics=args.statistics,
                              verbosity = args.verbosity)
        time_bbimplicit_stop = time.process_time()
        print(x,fx,"(ellapsed time %.5f)" %
              (time_bbimplicit_stop-time_bbimplicit_start,))
        show_solution(x,N,weights)
    if args.explicit:
        print("Ahora probamos con branch and bound poda explícita:")
        time_bbexplicit_start = time.process_time()
        x,fx = branchAndBound(N,weights,
                              optimistic = optimistic,
                              explicitPruning = True,
                              reportStatistics=args.statistics,
                              verbosity = args.verbosity)
        time_bbexplicit_stop = time.process_time()
        print(x,fx,"(ellapsed time %.5f)" %
              (time_bbexplicit_stop-time_bbexplicit_start,))
        show_solution(x,N,weights)

