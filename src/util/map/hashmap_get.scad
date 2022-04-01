/**
* hashmap_get.scad
*
* @copyright Justin Lin, 2021
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib3x-hashmap_get.html
*
**/

use <../../__comm__/_str_hash.scad>;
use <../_impl/_find_eq.scad>;

function hashmap_get(map, key, eq = undef, hash = function(e) _str_hash(e)) =
    let(
	    bidx = hash(key) % len(map),
		bucket = map[bidx]
	)
	let(i = _find_eq(bucket, key, eq))
	i == -1 ? undef : bucket[i][1];