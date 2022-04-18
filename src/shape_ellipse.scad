/**
* shape_ellipse.scad
*
* @copyright Justin Lin, 2017
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib3x-shape_ellipse.html
*
**/

use <__comm__/__frags.scad>;

function shape_ellipse(axes) =
    let(
        frags = __frags(axes[0]),
        step_a = 360 / frags
    ) 
    [
        for(i = [0:frags - 1]) 
        let(a = i * step_a)
            [axes[0] * cos(a), axes[1] * sin(a)]
    ];