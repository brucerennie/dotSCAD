use <__comm__/__line_intersection.scad>;
use <__comm__/__in_line.scad>;

function lines_intersection2(line1, line2, ext = false, epsilon = 0.0001) =
     let(
         pt = __line_intersection(line1, line2, epsilon)
     )
     ext ? pt :
     pt != [] && __in_line(line1, pt, epsilon) && __in_line(line2, pt, epsilon) ? pt : [];