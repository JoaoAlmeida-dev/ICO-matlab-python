import random
from datetime import datetime
import multiprocessing as mp
from typing import List

import matlab.engine
import matlab


def runMatlab(engine, method: str, seed: int, initial_points: int, n_max_iter: int, error: float, xmin: int, xmax: int,
              ymin: int, ymax: int, display: bool):
    attr = getattr(engine, method)
    result = attr(seed, initial_points, n_max_iter, error, xmin, xmax, ymin, ymax, display, nargout=6)

    xoptimo = result[0]
    foptimo = result[1]
    dffinal = result[2]
    NIterMean = result[3]
    Lopt = result[4]
    LNit = result[5]
    print(f'xoptimo:{xoptimo}')
    print(f'foptimo:{foptimo}')
    print(f'dffinal:{dffinal}')
    print(f'NIterMean:{NIterMean}')
    print(f'Lopt:{Lopt}')
    print(f'LNit:{LNit}')
    INF: float = float('inf')
    MINUSINF: float = float('-inf')
    NAN: float = float("nan")
    loptPythonMatrix = matlab.double(Lopt)
    print(loptPythonMatrix)
    hasInfOrNan: bool = False
    for row_index, row in enumerate(loptPythonMatrix):
        for col_index, col in enumerate(row):
            currvalue = Lopt[row_index][col_index]
            isInforNan = currvalue == INF or currvalue == MINUSINF or currvalue == NAN
            hasInfOrNan = hasInfOrNan or isInforNan

            print(f'\t{currvalue}; is inf or Nan: {isInforNan}')
    print(f'Found any Inf or Nan? {hasInfOrNan}')
    return hasInfOrNan


def find_good_seed(eng, method, initialPoints, nMaxIter, error, xmin, xmax, ymin, ymax, start, ):
    matlabBroke: bool = True
    seed: int = 0
    counter: int = 0
    while matlabBroke:  # and seed < 80:
        seed = random.randint(0, 1000000)
        matlabBroke = runMatlab(eng, method=method, seed=seed, initial_points=initialPoints,
                                n_max_iter=nMaxIter, error=error, xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax,
                                display=False)
        print(f'seed: {seed}')
        print(f'Elapsed Time = {(datetime.now() - start)}')
        print("=========================================================")
        counter += 1
    print(f'FINISHED\nElapsed Time = {(datetime.now() - start)}')
    return seed, counter


def main():
    methods: [str] = ['descidaMaximaV1aula', 'descidaMaximaWolfe', 'Newton2015']

    print("starting engine")
    #eng = matlab.engine.start_matlab()
    eng = matlab.engine.start_matlab("-desktop")
    # eng.eval(dbstop in descidaMaximaV1aula if error)

    print("starting script")
    eng.cd('/home/joao/Uni/Mestrado/ICO/matlab/lineSearch')
    initial_points = 2
    nMaxIter = 50
    error = 0.15
    window: List[int] = [-4, 4, -4, 4]
    start = datetime.now()
    # nice seed: 4414055 # demorou 30 min a achar esta seed
    # nice seed: 856360 # demorou 14 min a achar esta seed

    seed, counter = find_good_seed(eng,
                                   method=methods[0],
                                   initialPoints=initial_points,
                                   nMaxIter=nMaxIter,
                                   error=error,
                                   start=start,
                                   xmin=-4, xmax=4, ymin=-4, ymax=4)
    runMatlab(eng, method=methods[0], seed=seed, initial_points=initial_points, n_max_iter=nMaxIter, error=error,
              xmin=-4, xmax=4, ymin=-4, ymax=4,
              display=True)
    print(f'seed: {seed}')
    print(f'counter: {counter}')

    print("finished")

    input("\nPress enter to close...")
    eng.quit()
    print("closed engine")


if __name__ == '__main__':
    main()
