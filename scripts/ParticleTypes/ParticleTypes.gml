
/// Particles
enum PARTICLES {
	TEST
}

function init_particle(type) {
	var pt = part_type_create();
	
	switch (type) {
		case PARTICLES.TEST: {
			part_type_shape(pt, pt_shape_square);
			part_type_size(pt, .01, .02, 0, 0);
			part_type_colour2(pt, c_orange, c_red);
			part_type_speed(pt, 2, 3, 0, 0);
			part_type_direction(pt, 165, 180, 1, 0);
			part_type_life(pt, 15, 35);
			part_type_blend(pt, true);
		} break;
		default: {
			show_error("Called init_particle with faulty particle enum", true);
		} break;
	}
	
	return [type, pt];
}