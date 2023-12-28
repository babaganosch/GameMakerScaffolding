gpu_set_ztestenable(true);
shader_zsort.set();
shader_enable_corner_id(true);

with(GameObject) {
	event_perform(ev_draw, ev_draw_normal);
}

var _game_objects = ACTIVE_LITE_OBJECTS;
var _list_size = array_length(_game_objects);
for (var _i = 0; _i < _list_size; ++_i)
{
	_game_objects[i].draw();
}

shader_enable_corner_id(false);
shader_zsort.reset();
gpu_set_ztestenable(false);
