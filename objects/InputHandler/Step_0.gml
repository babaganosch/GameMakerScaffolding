/// @desc Move camera
if (!DEBUG_STRESS_TEST && !keyboard_check(ord("C"))) 
    CAMERA.approach_center(mouse_x, mouse_y, 0.1);