
/// Particles
enum PARTICLES {
	TEST
}

function init_particle(_type) {
	var _pt = part_type_create();
	
	switch (_type) {
		case PARTICLES.TEST: {
			part_type_shape(_pt, pt_shape_square);
			part_type_size(_pt, .01, .02, 0, 0);
			part_type_colour2(_pt, c_orange, c_red);
			part_type_speed(_pt, 2, 3, 0, 0);
			part_type_direction(_pt, 165, 180, 1, 0);
			part_type_life(_pt, 15, 35);
			part_type_blend(_pt, true);
		} break;
		default: {
			show_error("Called init_particle with faulty particle enum", true);
		} break;
	}
	
	return [_type, _pt];
}