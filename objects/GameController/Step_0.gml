var lite_game_objects = ACTIVE_LITE_OBJECTS;
var list_size = array_length(lite_game_objects);
var delta = dt;
for (var i = 0; i < list_size; ++i)
{
    lite_game_objects[i].update(delta);
}