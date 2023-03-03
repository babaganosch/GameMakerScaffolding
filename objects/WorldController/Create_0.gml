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

function Shop(tileset, w, h) : World(tileset, w, h) constructor
{
    // Empty
}

global.level = [];
global.area = AREA.OVER_WORLD;
var level = global.level;
var level_size = [ room_width div CELL_W, room_height div CELL_H ];
level[AREA.OVER_WORLD] = new World(tset_test0, level_size[X], level_size[Y]);
level[AREA.SHOP] = new Shop(tset_test0, level_size[X], level_size[Y]);

level[AREA.OVER_WORLD].set_area(4, 4, 17, 17,   CELL_DATA.FLOOR);
level[AREA.OVER_WORLD].set_area(8, 4, 12, 8,    CELL_DATA.WALL);
level[AREA.OVER_WORLD].set_area(12, 12, 24, 24, CELL_DATA.FLOOR);
level[AREA.OVER_WORLD].set_area(16, 16, 20, 20, CELL_DATA.WALL);
level[AREA.OVER_WORLD].render();

level[AREA.SHOP].set_area(5, 5, level_size[X] - 5, level_size[Y] - 5, CELL_DATA.FLOOR);
level[AREA.SHOP].set_area(24, 24, 26, 26, CELL_DATA.WALL);
level[AREA.SHOP].render();
global.level = level;

CURRENT_LEVEL.activate();
