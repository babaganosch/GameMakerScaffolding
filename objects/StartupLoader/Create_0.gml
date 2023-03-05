sprite_index = -1;
show_debug_overlay(DEBUG);
gml_release_mode(!DEBUG);
print();
print("-|   Starting Game   |-");
print();

/* TODO: Calc following based on aspect ratio.. or anything! */
var w = display_get_width()  div 4;
var h = display_get_height() div 4;

global.game_width  = w; // 420 // 384 // 192
global.game_height = h; // 262 // 216 // 108
global.zoom        = 3; // 3   // 3   // 6

global.screen_width  = global.game_width * global.zoom;
global.screen_height = global.game_height * global.zoom;

instance_create(GameController, 0, 0, 0);
instance_create(InputHandler, 0, 0, 0);
instance_create(Renderer, 0, 0, 0);
instance_create(Time, 0, 0, 0);
instance_create(Terminal, 0, 0, 0);
instance_create(ParticlesController, 0, 0, 0);
instance_create(WorldController, 0, 0, 0);
//instance_create(LightController, 0, 0, -400);

// Stress test lights
/*
var _num = 0;
var _z = 32;
for (var _x = 0; _x < (room_width div _z); _x++) {
    for (var _y = 0; _y < (room_height div _z); _y++) {
        instance_create(DebugLight, _x*_z, _y*_z, 0);
        _num++;
    }
}
*/

// Stress test instances
/*
var _num = 0;
var _z = 12;
for (var _x = 0; _x < (room_width div _z); _x++) {
    for (var _y = 0; _y < (room_height div _z); _y++) {
        instance_create(DebugBall, _x*_z, _y*_z, 0);
        _num++;
    }
}
LOG("INSTANCES:", _num);
*/

// Stress test LITE instances
/*
var _num = 0;
var _z = 10;
global.TEST = [];
for (var _x = 0; _x < (room_width div _z); _x++) {
    for (var _y = 0; _y < (room_height div _z); _y++) {
        var a = new LiteGameObject(_x * _z, _y * _z, spr_debug_box_tny);
        _num++;
    }
}
LOG("LITE INSTANCES:", _num);
*/

instance_destroy();