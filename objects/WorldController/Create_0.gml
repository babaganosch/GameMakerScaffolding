IS_SINGLETON
sprite_index = -1;
receiver  = new Receiver(["system"]);

enum AREA
{
    OVER_WORLD,
    SHOP
}

#macro CURRENT_LEVEL (global.level[global.area])
#macro CURRENT_AREA  (global.area)

// Feather ignore once GM2017
function Shop(_tileset, _w, _h) : World(_tileset, _w, _h) constructor
{
    // Empty
}

global.level = [];
global.area = AREA.OVER_WORLD;
var _level = global.level;
var _level_size = [ room_width div CELL_W, room_height div CELL_H ];
_level[AREA.OVER_WORLD] = new World(ts_test0, _level_size[X], _level_size[Y]);
_level[AREA.SHOP] = new Shop(ts_test0, _level_size[X], _level_size[Y]);

_level[AREA.OVER_WORLD].set_area(4, 4, 17, 17,   CELL_DATA.FLOOR);
_level[AREA.OVER_WORLD].set_area(8, 4, 12, 8,    CELL_DATA.WALL);
_level[AREA.OVER_WORLD].set_area(12, 12, 24, 24, CELL_DATA.FLOOR);
_level[AREA.OVER_WORLD].set_area(16, 16, 20, 20, CELL_DATA.WALL);
_level[AREA.OVER_WORLD].render();

_level[AREA.SHOP].set_area(5, 5, _level_size[X] - 5, _level_size[Y] - 5, CELL_DATA.FLOOR);
_level[AREA.SHOP].set_area(24, 24, 26, 26, CELL_DATA.WALL);
_level[AREA.SHOP].render();

CURRENT_LEVEL.activate();
