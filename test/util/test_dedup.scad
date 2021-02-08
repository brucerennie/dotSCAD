use <util/dedup.scad>;
use <util/sort.scad>;

module test_dedup() {
    echo("==== test_dedup ====");

    eq = function(e1, e2) e1[0] == e2[0] && e1[1] == e2[1] && e1[2] == e2[2];

    points = [[1, 1, 2], [3, 4, 2], [7, 2, 2], [3, 4, 2], [1, 2, 3]];
    assert(
        dedup([[1, 1, 2], [3, 4, 2], [7, 2, 2], [3, 4, 2], [1, 2, 3]]) 
            == [[1, 1, 2], [3, 4, 2], [7, 2, 2], [1, 2, 3]]
    );

    assert(
        dedup([[1, 1, 2], [3, 4, 2], [7, 2, 2], [3, 4, 2], [1, 2, 3]], eq = eq) 
            == [[1, 1, 2], [3, 4, 2], [7, 2, 2], [1, 2, 3]]
    );

    sorted = sort([[1, 1, 2], [3, 4, 2], [7, 2, 2], [3, 4, 2], [1, 2, 3]]);

    assert(
        dedup(sorted, sorted = true) == [[1, 1, 2], [1, 2, 3], [3, 4, 2], [7, 2, 2]]
    );

    assert(
        dedup(sorted, sorted = true, eq = eq) == [[1, 1, 2], [1, 2, 3], [3, 4, 2], [7, 2, 2]]
    );
}

test_dedup();