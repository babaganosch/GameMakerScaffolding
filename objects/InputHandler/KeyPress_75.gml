/// @desc Toggle world
if (active) {
    CURRENT_LEVEL.deactivate();
    var _area = CURRENT_AREA;
    _area = ( _area + 1) % 2;
    CURRENT_AREA = _area;
    CURRENT_LEVEL.activate();
    LOG("K pressed");
}