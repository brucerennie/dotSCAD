TAU = 360;

MAX_ANGLE = 720;

function vt(center, r, startAngle, angleSign, angle) = 
    let(
        a = angle * angleSign + startAngle,
        s = (MAX_ANGLE - angle) / MAX_ANGLE
    )
    [
        center.x + r * cos(a) * s, 
        center.y + r * sin(a) * s
    ];

function spiral(center, r, startAngle, angleSign = 1, angle = 0, path) = 
[
    center, 
    r, 
    startAngle,
    angleSign,
    angle,
    is_undef(path) ? [vt(center, r, startAngle, angleSign, angle)] :  path
];

function spiral_center(spiral) = spiral[0];
function spiral_r(spiral) = spiral[1];
function spiral_startAngle(spiral) = spiral[2];
function spiral_angleSign(spiral) = spiral[3];
function spiral_angle(spiral) = spiral[4];
function spiral_path(spiral) = spiral[5];

function spiral_step(spiral, angleStep) = 
    let(    
        c = spiral_center(spiral),
        r = spiral_r(spiral),
        sa = spiral_startAngle(spiral),
        as = spiral_angleSign(spiral),
        a = spiral_angle(spiral) + angleStep
        
    )
    spiral(
        c,
        r,
        sa,
        as,
        a,
        [each spiral_path(spiral), vt(c, r, sa, as, a)]
    );
    

function foliage_scroll(width, height, spirals, maxSpirals, minR, done = 0) =
    let(
        more_spirals = try_add_spiral(width, height, spirals, maxSpirals, minR, done),
        nx_spirals = [
            for(i = 0; i < len(more_spirals); i = i + 1)
            if(i < done) more_spirals[i] else spiral_step(more_spirals[i], angleStep)
        ],
        nx_done = count(nx_spirals, function(s) spiral_angle(s) > 630)
    )
    nx_done < len(nx_spirals)? foliage_scroll(width, height, nx_spirals, maxSpirals, minR, nx_done) : nx_spirals;

function try_add_spiral(width, height, spirals, maxSpirals, minR, done) = 
    let(
        leng = len(spirals),
        more_spirals = [
            each spirals,
            each [
                for(i = done; i < leng; i = i + 1) 
                let(maybeSpiral = try_create_spiral(width, height, spirals, i, minR))
                if(!is_undef(maybeSpiral)) maybeSpiral
            ]
        ],
        leng_more_spirals = len(more_spirals)
    )
    leng_more_spirals > maxSpirals ? [for(i = [0:maxSpirals - 1]) more_spirals[i]] : more_spirals;
    
function try_create_spiral(width, height, spirals, i, minR) = 
    let(spiral = spirals[i])
    spiral_angle(spiral) <= 270 ? undef :
    let(
        r = spiral_r(spiral),
        cr = r * rands(0.5, 1.75, 1)[0]
    )
    cr < minR ? undef : 
    let(
        offAngle = rands(0, 270, 1)[0],
        offR = r * (MAX_ANGLE - offAngle) / MAX_ANGLE + cr,
        angleSign = spiral_angleSign(spiral),
        ca = offAngle * angleSign + spiral_startAngle(spiral) + 180,
        center = spiral_center(spiral),
        cx = center.x + offR * cos(ca - 180),
        cy = center.y + offR * sin(ca - 180)
    )
    out_size(width, height, cx, cy, cr) || overlapped(spirals, i, cx, cy, cr) ? undef : spiral([cx, cy], cr, ca, -angleSign);

function out_size(width, height, cx, cy, cr) =
    cx < -width / 2 + cr || cx > width / 2 - cr || cy < -height / 2 + cr || cy > height / 2 - cr;
    
function overlapped(spirals, i, cx, cy, cr, j = 0) = 
    j == len(spirals) ? false :
    j == i ? overlapped(spirals, i, cx, cy, cr, j + 1) :
    let(
        spiral = spirals[j],
        leng = norm(spiral_center(spiral) - [cx, cy]),
        sa = startAngle(cx, cy, spiral),
        d = cr * 1.5,
        r = spiral_r(spiral)
    )
    dist(leng, r, sa) <  d || dist(leng, r, sa + 360) < d || overlapped(spirals, i, cx, cy, cr, j + 1);
    
function startAngle(cx, cy, spiral) = 
    let(
        center = spiral_center(spiral),
        sa = (atan2((cy - center.y), (cx - center.x)) - spiral_startAngle(spiral)) % 360
    )
    abs((sa + spiral_angleSign(spiral) * 360) % 360);
    
function dist(leng, r, a) = abs(leng - r * (MAX_ANGLE - a) / MAX_ANGLE);

use <polyline_join.scad>
use <util/count.scad>

width = 400;
height = 400;
maxSpirals = 100; 
angleStep = 10; 
minR = 10; 

r = rands(minR * 2, minR * 4, 1)[0];

spirals = [
    spiral([r, 0], r, 180),
    spiral([-r, 0], r, 0)
];

ss = foliage_scroll(width, height, spirals, maxSpirals, minR);
for(s = ss) {
    polyline_join(spiral_path(s))
        circle(minR / 5);
}