/// @desc Toggle world
if (active) {
    CURRENT_LEVEL.deactivate();
    var area = CURRENT_AREA;
    area = ( area + 1) % 2;
    CURRENT_AREA = area;
    CURRENT_LEVEL.activate();
    LOG("K pressed");
}