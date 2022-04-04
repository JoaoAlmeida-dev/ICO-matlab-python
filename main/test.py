import random
from datetime import datetime
import multiprocessing as mp
from typing import List, Dict, Any, Tuple, Union

import matlab.engine
from matlab.engine import MatlabEngine, FutureResult


def main():
    global DMV1AULA
    DMV1AULA = 'descidaMaximaV1aula'
    global DMW
    DMW = 'descidaMaximaWolfe'
    global NEWTON2015
    NEWTON2015 = 'Newton2015'

    methods: [str] = [DMV1AULA, DMW, NEWTON2015]

    eng = setup_engine()
    start: datetime = datetime.now()

    initial_points: int = 2
    n_max_iter: int = 50
    error: float = 0.15
    window: Dict[str, int] = dict(xmin=-4, xmax=4, ymin=-4, ymax=4)
    function = "f=@(x) 100*(x(2)-x(1)^2)^2+(1-x(1))^2"

    run_algorithms(eng, error=error, initial_points=initial_points, methods=methods, n_max_iter=n_max_iter,
                   function=function, start=start, window=window)

    #seed = 401434
    #display(eng, seed=seed, initial_points=initial_points, n_max_iter=n_max_iter, error=error, window=window)

    eng.quit()
    print("closed engine")


def run_algorithms(eng, methods, initial_points, n_max_iter, error, function, start, window):
    seeds: Dict[str, Dict[Union[int, str], Union[int, Dict[str, Any]]]] = {
        function: find_seeds_for_all_methods(eng, methods=methods, initial_points=initial_points, n_max_iter=n_max_iter,
                                             error=error, start=start, window=window)
    }
    print(f'seeds:\n{seeds}')
    print("writing seeds to file seeds.txt")
    with open(r'/home/joao/Uni/Mestrado/ICO/matlab/main/seeds.txt', 'a') as convert_file:
        convert_file.write(str(seeds) + "\n")
    print("finished")


def setup_engine():
    print("starting engine")
    eng = matlab.engine.start_matlab()
    # eng = matlab.engine.start_matlab("-desktop")
    # eng.eval(dbstop in descidaMaximaV1aula if error)
    print("starting script")
    eng.cd('/home/joao/Uni/Mestrado/ICO/matlab/lineSearch')
    return eng


# region MATLAB
def run_matlab(engine, method: str, seed: int, initial_points: int, n_max_iter: int, error: float,
               window: Dict[str, int],
               display: bool):
    attr = getattr(engine, method)

    result = attr(seed, initial_points, n_max_iter, error,
                  window["xmin"], window["xmax"], window["ymin"], window["ymax"],
                  display, nargout=6)

    results_dict = {
        "n_iter_mean": result[3],
        "foptimo": result[1],
        "xoptimo": result[0],
        "dffinal": result[2],
        "num_iter_list": result[5],
    }
    print(results_dict)
    opt_points_list = result[4]

    INF: float = float('inf')
    MINUSINF: float = float('-inf')
    NAN: float = float("nan")
    lopt_python_matrix = matlab.double(opt_points_list)

    print(lopt_python_matrix)

    has_inf_or_nan: bool = False
    for row_index, row in enumerate(lopt_python_matrix):
        for col_index, col in enumerate(row):
            currvalue = opt_points_list[row_index][col_index]
            is_infor_nan = currvalue == INF or currvalue == MINUSINF or currvalue == NAN
            has_inf_or_nan = has_inf_or_nan or is_infor_nan

            print(f'\t{currvalue}; is inf or Nan: {is_infor_nan}')
    print(f'Found any Inf or Nan? {has_inf_or_nan}')
    return has_inf_or_nan, results_dict


# endregion


# region SEEDS
def find_good_seed(eng, method: str, initial_points: int, n_max_iter: int, error: float, window: Dict[str, int], start):
    matlab_broke: bool = True
    seed: int = 0
    counter: int = 0
    while matlab_broke:  # and seed < 80:

        try:
            seed = random.randint(0, 1000000)
            matlab_broke, results_dict = run_matlab(eng, method=method, seed=seed, initial_points=initial_points,
                                                    n_max_iter=n_max_iter, error=error, window=window,
                                                    display=False)
            print(f'{method} - seed: {seed}')
            print(f'{method} - Elapsed Time = {(datetime.now() - start)}')
            print(f"{method} - =========================================================")
            counter += 1
        except matlab.engine.MatlabExecutionError:
            print("matlab.engine.MatlabExecutionError")
            continue
    print(f'{method} - FINISHED\nElapsed Time = {(datetime.now() - start)}')
    return seed, results_dict


def find_seeds_for_all_methods(eng, methods: List[str], initial_points: int, n_max_iter: int, error: float,
                               window: Dict[str, int], start):
    seed_dict: Dict[str, Dict[Union[int, str], Union[int, Dict[str, Any]]]] = {}
    for method in methods:
        seed, results_dict = find_good_seed(eng,
                                            method=method,
                                            initial_points=initial_points,
                                            n_max_iter=n_max_iter,
                                            error=error,
                                            start=start,
                                            window=window
                                            )
        seed_dict[method] = {"seed": seed, "results": results_dict}

    return seed_dict


# endregion


# region DISPLAYS
def display_DMV1AULA(eng, seed: int, initial_points: int, n_max_iter: int, error: float,
                     window: Dict[str, int]):
    run_matlab(eng, method=DMV1AULA, seed=seed, initial_points=initial_points,
               n_max_iter=n_max_iter, error=error, window=window,
               display=True)


def display_DMW(eng, seed: int, initial_points: int, n_max_iter: int, error: float,
                window: Dict[str, int]):
    run_matlab(eng, method=DMW, seed=seed, initial_points=initial_points,
               n_max_iter=n_max_iter, error=error, window=window,
               display=True)


def display_NEWTON2015(eng, seed: int, initial_points: int, n_max_iter: int, error: float,
                       window: Dict[str, int]):
    run_matlab(eng, method=NEWTON2015, seed=seed, initial_points=initial_points,
               n_max_iter=n_max_iter, error=error, window=window,
               display=True)


def display(eng, seed: int, initial_points: int, n_max_iter: int, error: float, window: Dict[str, int]):
    # display_DMV1AULA(eng, seed, initial_points, n_max_iter, error,window)
    # display_DMW(eng, seed, initial_points, n_max_iter, error,window)
    display_NEWTON2015(eng, seed, initial_points, n_max_iter, error, window)
    input("\nPress enter to close...")


# endregion


if __name__ == '__main__':
    main()
