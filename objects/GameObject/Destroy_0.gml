var active_game_objects = ACTIVE_GAME_OBJECTS;
for (var i = 0; i < array_length(active_game_objects); ++i) {
	if (id == active_game_objects[i].id) {
		array_delete(active_game_objects, i, 1);
		break;
	}
}