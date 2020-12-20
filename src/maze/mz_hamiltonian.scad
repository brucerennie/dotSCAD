use <_impl/_mz_hamiltonian_impl.scad>;
use <mz_square_cells.scad>;
use <mz_square_get.scad>;
use <../util/sort.scad>;
use <../util/dedup.scad>;

function mz_hamiltonian(rows, columns, start, seed) =
    let(
        cells = mz_square_cells(  
            rows, columns,
            seed = seed
        ),
        all = concat(
            [
                for(cell = cells)
                let(
                    x = mz_square_get(cell, "x"),
                    y = mz_square_get(cell, "y"),
                    wall_type = mz_square_get(cell, "w"),
                    pts = wall_type == "TOP_WALL" ? _mz_hamiltonian_top(x, y) :
                          wall_type == "RIGHT_WALL" ? _mz_hamiltonian_right(x, y) :
                          wall_type == "TOP_RIGHT_WALL" ? _mz_hamiltonian_top_right(x, y) : []
                )
                each pts
            ],
            [for(x = [0:columns * 2 - 1]) [x, 0]],
            [for(y = [0:rows * 2 - 1]) [0, y]]
        ),
        dot_pts = dedup(sort(all, by = "vt"), sorted = true)
    )
    _mz_hamiltonian_travel(dot_pts, start, rows * columns * 4);