/// @desc LITE_OBJECT_CULLING

// Check square
var _cs = CAMERA.active_zone;

var _inactive_game_objects = INACTIVE_LITE_OBJECTS;
var _active_game_objects   = ACTIVE_LITE_OBJECTS;

// Re-activate deactivated objects that's inside CS again
for (var _i = 0; _i < array_length(_inactive_game_objects); _i++)
{
    var _ins = _inactive_game_objects[_i];
    if (point_in_rectangle(_ins.x, _ins.y, _cs[X1], _cs[Y1], _cs[X2], _cs[Y2]))
    {
        array_push(_active_game_objects, _ins);
        array_delete(_inactive_game_objects, _i--, 1);
    }
}

// De-activate objects that's ouside CS
for (var _i = 0; _i < array_length(_active_game_objects); _i++)
{
    var _ins = _active_game_objects[_i];
    if (!point_in_rectangle(_ins.x, _ins.y, _cs[X1], _cs[Y1], _cs[X2], _cs[Y2]))
    {
        array_push(_inactive_game_objects, _ins);
        array_delete(_active_game_objects, _i--, 1);
    }
}
