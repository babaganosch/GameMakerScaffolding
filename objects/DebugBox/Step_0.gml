
if (keyboard_check_pressed(ord("H"))) physics.velocity[@ X] -= 5;
if (keyboard_check_pressed(ord("J"))) physics.velocity[@ X] += 5;

var fx = (keyboard_check(ord("D")) - keyboard_check(ord("A")));
var fy = (keyboard_check(ord("S")) - keyboard_check(ord("W")));
var dir = point_direction(0, 0, fx, fy);
physics.force[@ X] = 0;
physics.force[@ Y] = 0;

if (fx != 0)
    physics.force[@ X] = lengthdir_x(spd, dir);
if (fy != 0)
    physics.force[@ Y] = lengthdir_y(spd, dir);

event_inherited();
