var _lite_game_objects = ACTIVE_LITE_OBJECTS;
var _list_size = array_length(_lite_game_objects);
var _delta = dt;
for (var _i = 0; _i < _list_size; ++_i)
{
    _lite_game_objects[_i].update(_delta);
}