/// @desc OBJECT_CULLING

// Check square
var cs = CAMERA.edges;
var buffer = CAMERA.buffer;
cs[X1] -= buffer[X];
cs[Y1] -= buffer[Y];
cs[X2] += buffer[X];
cs[Y2] += buffer[Y];

var inactive_game_objects = INACTIVE_GAME_OBJECTS;
var active_game_objects   = ACTIVE_GAME_OBJECTS;

// Re-activate deactivated objects that's inside CS again
for (var i = 0; i < array_length(inactive_game_objects); i++)
{
    var ins = inactive_game_objects[i];
    if (point_in_rectangle(ins.x, ins.y, cs[X1], cs[Y1], cs[X2], cs[Y2]))
    {
        instance_activate_object(ins);
        array_push(active_game_objects, ins);
        array_delete(inactive_game_objects, i--, 1);
        ins.active = true;
    }
}

// De-activate objects that's ouside CS
for (var i = 0; i < array_length(active_game_objects); i++)
{
    var ins = active_game_objects[i];
    if (ins.dont_deactivate) continue;
    if (!point_in_rectangle(ins.x, ins.y, cs[X1], cs[Y1], cs[X2], cs[Y2]))
    {
        array_push(inactive_game_objects, ins);
        array_delete(active_game_objects, i--, 1);
        ins.active = false;
        instance_deactivate_object(ins);
    }
}

ACTIVE_GAME_OBJECTS   = active_game_objects;
INACTIVE_GAME_OBJECTS = inactive_game_objects;
