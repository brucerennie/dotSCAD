use <util/rand.scad>;
use <experimental/_impl/_nz_worley2_comm.scad>;

function nz_worley2s(size, points, seed, dim = 3, dist = "euclidean") =
    let(
        sd = 6 + (is_undef(seed) ? floor(rand(0, 256)) : seed % 256),
        // m*n pixels per grid
        m = size[0] / dim,
        n = size[1] / dim
    )
    [for(p = points) _nz_worley2(p, sd, dim, m, n, dist)];