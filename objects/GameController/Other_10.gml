/// @desc OBJECT_CULLING

// Check square
var _cs = CAMERA.active_zone;

var _inactive_game_objects = INACTIVE_GAME_OBJECTS;
var _active_game_objects   = ACTIVE_GAME_OBJECTS;

// Re-activate deactivated objects that's inside CS again
for (var _i = 0; _i < array_length(_inactive_game_objects); _i++)
{
    var _ins = _inactive_game_objects[_i];
    if (point_in_rectangle(_ins.x, _ins.y, _cs[X1], _cs[Y1], _cs[X2], _cs[Y2]))
    {
        instance_activate_object(_ins);
        array_push(_active_game_objects, _ins);
        array_delete(_inactive_game_objects, _i--, 1);
        _ins.active = true;
    }
}

// De-activate objects that's ouside CS
for (var _i = 0; _i < array_length(_active_game_objects); _i++)
{
    var _ins = _active_game_objects[_i];
    if (_ins.dont_deactivate) continue;
    if (!point_in_rectangle(_ins.x, _ins.y, _cs[X1], _cs[Y1], _cs[X2], _cs[Y2]))
    {
        array_push(_inactive_game_objects, _ins);
        array_delete(_active_game_objects, _i--, 1);
        _ins.active = false;
        instance_deactivate_object(_ins);
    }
}
