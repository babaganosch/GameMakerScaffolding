
if (keyboard_check_pressed(ord("H"))) physics.velocity[@ X] -= 5;
if (keyboard_check_pressed(ord("J"))) physics.velocity[@ X] += 5;

var _fx = (keyboard_check(ord("D")) - keyboard_check(ord("A")));
var _fy = (keyboard_check(ord("S")) - keyboard_check(ord("W")));
var _dir = point_direction(0, 0, _fx, _fy);
physics.force[@ X] = 0;
physics.force[@ Y] = 0;

if (_fx != 0)
    physics.force[@ X] = lengthdir_x(spd, _dir);
if (_fy != 0)
    physics.force[@ Y] = lengthdir_y(spd, _dir);

event_inherited();
