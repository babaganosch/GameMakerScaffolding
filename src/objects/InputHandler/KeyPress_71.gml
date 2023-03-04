/// @desc Spawn box
if (active) {
    instance_create(DebugBox, mouse_x, mouse_y, -50);
    LOG_T("DebugBox spawned at", mouse_x, mouse_y);
}