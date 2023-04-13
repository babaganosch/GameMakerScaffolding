gpu_set_ztestenable(true);
object_z_sort_shader.set();
with(GameObject) {
	enocde_image_blend(OBJECT_Z_SORT, 0, 0);
	event_perform(ev_draw, ev_draw_normal);
}
object_z_sort_shader.reset();
gpu_set_ztestenable(false);

var game_objects = ACTIVE_LITE_OBJECTS;
var list_size = array_length(game_objects);
for (var i = 0; i < list_size; ++i)
{
    game_objects[i].draw();
}