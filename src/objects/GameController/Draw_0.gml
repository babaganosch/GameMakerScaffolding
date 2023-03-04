var game_objects = ACTIVE_GAME_OBJECTS;
var list_size = array_length(game_objects);
for (var i = 0; i < list_size; ++i)
{
    game_objects[i].draw();
}

game_objects = ACTIVE_LITE_OBJECTS;
list_size = array_length(game_objects);
for (var i = 0; i < list_size; ++i)
{
    game_objects[i].draw();
}