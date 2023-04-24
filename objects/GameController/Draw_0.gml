gpu_set_ztestenable(true);
shader_zsort.set();
shader_enable_corner_id(true);

with(GameObject) {
	event_perform(ev_draw, ev_draw_normal);
}

var game_objects = ACTIVE_LITE_OBJECTS;
var list_size = array_length(game_objects);
for (var i = 0; i < list_size; ++i)
{
	game_objects[i].draw();
}

shader_enable_corner_id(false);
shader_zsort.reset();
gpu_set_ztestenable(false);
