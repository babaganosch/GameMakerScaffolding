gpu_set_ztestenable(true);
object_z_sort_shader.set();
object_z_sort_shader.uniforms.room_height.set(room_height);

with(GameObject) {
	enocde_image_blend(bbox_bottom mod 255, bbox_bottom div 256, 0);
	event_perform(ev_draw, ev_draw_normal);
}

var game_objects = ACTIVE_LITE_OBJECTS;
var list_size = array_length(game_objects);
for (var i = 0; i < list_size; ++i)
{
	var obj = game_objects[i];
		obj.zsort();
	    obj.draw();
}

object_z_sort_shader.reset();
gpu_set_ztestenable(false);
