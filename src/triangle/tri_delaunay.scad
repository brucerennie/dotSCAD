use <_impl/_tri_delaunay_impl.scad>;
use <tri_delaunay_shapes.scad>;
use <tri_delaunay_indices.scad>;
use <tri_delaunay_voronoi.scad>;

// ret: "TRI_SHAPES", "TRI_INDICES", "VORONOI_CELLS", "DELAUNAY"
function tri_delaunay(points, ret = "TRI_INDICES") = 
    let(
		_indices_hash = function(indices) indices[0] * 961 + indices[1] * 31 + indices[2],
		xs = [for(p = points) p[0]],
		ys = [for(p = points) p[1]],
		max_x = max(xs),
		min_x = min(xs),
		max_y = max(ys),
		min_y = min(ys),
		center = [max_x + min_x, max_y + min_y] / 2,
		width = abs(max_x - center[0]) * 4,
		height = abs(max_y - center[1]) * 4,
		leng_pts = len(points),
        d = _tri_delaunay(
			    delaunay_init(center, width, height, leng_pts, _indices_hash), 
				points, 
				leng_pts,
				_indices_hash
			)
    )
	ret == "TRI_INDICES" ? tri_delaunay_indices(d) :
    ret == "TRI_SHAPES" ?  tri_delaunay_shapes(d) : 
	ret == "VORONOI_CELLS" ? tri_delaunay_voronoi(d) :
    d; // "DELAUNAY": [coords(list), triangles(hashmap), circles(hashmap)]