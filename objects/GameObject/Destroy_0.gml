var _active_game_objects = ACTIVE_GAME_OBJECTS;
for (var _i = 0; _i < array_length(_active_game_objects); ++_i) {
	if (id == _active_game_objects[_i].id) {
		array_delete(_active_game_objects, _i, 1);
		break;
	}
}