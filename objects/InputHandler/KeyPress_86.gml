/// @desc Spawn ball
if (active) {
    instance_create(DebugBall, mouse_x, mouse_y, -50);
    LOG_T("DebugBall spawned at", mouse_x, mouse_y);
}