
enum CELL_DATA {
    VOID    = 0,
    
    FLOOR   = 1,    // Uneven numbers is on FLOOR
    WALL    = 2,    // Even numbers is WALL (and VOID)
    
    // Placeholders could be used for doors, chests etc. 
    // (Note that a cell can have MULTIPLE data, as it's just bit flags)
    PLACEHOLDER0 = 4,
    PLACEHOLDER1 = 8,
    PLACEHOLDER2 = 16,
    PLACEHOLDER3 = 32
}

#macro SECURE_WORLD_DIRECT_LOOKUP    { x = clamp(x, 0, _size[X] - 1); y = clamp(y, 0, _size[Y] - 1); }
#macro UNSECURE_WORLD_DIRECT_LOOKUP  { }
#macro SECURE_WORLD_SQUARE_LOOKUP    { x1 = clamp(x1, 0, _size[X] - 1); y1 = clamp(y1, 0, _size[Y] - 1); \
                                       x2 = clamp(x2, 0, _size[X] - 1); y2 = clamp(y2, 0, _size[Y] - 1); }
#macro UNSECURE_WORLD_SQUARE_LOOKUP  { }

#macro DIRECT_LOOKUP_SAFETY          UNSECURE_WORLD_DIRECT_LOOKUP
#macro SQUARE_LOOKUP_SAFETY          UNSECURE_WORLD_SQUARE_LOOKUP
#macro Debug:DIRECT_LOOKUP_SAFETY    SECURE_WORLD_DIRECT_LOOKUP
#macro Debug:SQUARE_LOOKUP_SAFETY    SECURE_WORLD_SQUARE_LOOKUP

#macro ACTIVE_GAME_OBJECTS    CURRENT_LEVEL._active_game_objects
#macro INACTIVE_GAME_OBJECTS  CURRENT_LEVEL._inactive_game_objects

#macro ACTIVE_LITE_OBJECTS    CURRENT_LEVEL._active_lite_objects
#macro INACTIVE_LITE_OBJECTS  CURRENT_LEVEL._inactive_lite_objects

/*** Worlds
 * When implementing new levels, always inherit the World base class
 * For example:
 *   function Shop(...) : World(...) constructor {...
 *   function SecretRoom(...) : World(...) constructor {...
 *   function BossRoom(...) : World(...) constructor {...
 *
 *   function LevelXYShop(...) : Shop(...) constructor {... 
 *   function LevelXYSecretRoom(...) : SecretRoom(...) constructor {...
 */

function World(tileset, w, h) constructor
{
    _tileset = tileset;
    _tile_variations = 2;       // TODO: Make dynamic
    _tileset_max_tiles = 24;    // TODO: Make dynamic
    _size = [w, h];
    _valid = true;
    _active = false;
    _data = ds_grid_create(w, h);
    ds_grid_set_region(_data, 0, 0, w, h, CELL_DATA.VOID);
    
    _active_game_objects = [];
    _inactive_game_objects = [];
    
    _active_lite_objects = [];
    _inactive_lite_objects = [];
    
    _floor_tm = new TileMap(_tileset, +50, w, h);
    _wall_tm = new TileMap(_tileset, -200, w, h);
    
    // World coordinates passed in. Collision if CELL_DATA is even (WALL bit set)
    // Returns
    // 0 (false): FLOOR
    // 1 (true):  WALL
    static check_collision_point = function(x, y)
    {
        x = x div CELL_W;
        y = y div CELL_H;
        DIRECT_LOOKUP_SAFETY;
        return !(_data[# x, y - 1] % 2) || !(_data[# x, y] % 2);
    }
    
    static check_collision_square = function(x1, y1, x2, y2)
    {
        x1 = x1 div CELL_W; y1 = y1 div CELL_H;
        x2 = x2 div CELL_W; y2 = y2 div CELL_H;
        y1 -= 1;
        SQUARE_LOOKUP_SAFETY;
        return !(_data[# x1, y1] % 2) || !(_data[# x2, y2] % 2) ||
               !(_data[# x1, y2] % 2) || !(_data[# x2, y1] % 2);
    }
    
    static get_cell_data = function(x, y)
    {
        DIRECT_LOOKUP_SAFETY;
        return _data[# x, y]; 
    }
    
    static get_cell_coordinates = function(x, y)
    {
        var xx = (x div CELL_W) * CELL_W;
        var yy = (y div CELL_H) * CELL_H;
        return [ xx, yy, xx + CELL_W, yy + CELL_H];
    }
    
    // Grid coordinates passed instead of world coordinates, usefull when pre-computing
    // coordinates for multiple calls.
    static check_collision_point_raw = function(x, y)
    {
        DIRECT_LOOKUP_SAFETY;
        return !(_data[# x, y] % 2);
    }
    
    static render = function(x1, y1, x2, y2) {
        if (is_undefined(argument[0])) {
            x1 = 1; x2 = _size[X]-1;
            y1 = 1; y2 = _size[Y]-1;
        }
        x1 = clamp(x1, 1, _size[X]-1);
        x2 = clamp(x2, 1, _size[X]-1);
        y1 = clamp(y1, 1, _size[Y]-1);
        y2 = clamp(y2, 1, _size[Y]-1);
        for (var _x = x1; _x < x2; ++_x) {
            for (var _y = y1; _y < y2; ++_y) {
                var variation = _tileset_max_tiles * irandom(_tile_variations-1);
                switch (_data[# _x, _y]) {
                    case CELL_DATA.FLOOR: {
                        // CLEAR OLD WALLS FROM TILE
                        _wall_tm.set_tile(_x, _y, TILE_ORIENTATION.EMPTY);
                        // INNER WALL
                        if ((_data[# _x, _y-1] != CELL_DATA.FLOOR))
                             _floor_tm.set_tile(_x, _y, irandom_range(TILE_ORIENTATION.WALL0, TILE_ORIENTATION.WALL2) + variation);
                        // FLOOR
                        else _floor_tm.set_tile(_x, _y, irandom_range(TILE_ORIENTATION.FLOOR0, TILE_ORIENTATION.FLOOR3) + variation);
                        
                    } break;
                    default: {
                        // WALLS ( data % 2 to check if void/wall bit is set, invert to check NOT void/wall )
                        var _north_tile = !(_data[# _x, _y-1] % 2) * 1;
                        var _west_tile  = !(_data[# _x-1, _y] % 2) * 2;
                        var _east_tile  = !(_data[# _x+1, _y] % 2) * 4;
                        var _south_tile = !(_data[# _x, _y+1] % 2) * 8;
                        var _tile_index = (_north_tile + _west_tile + _east_tile + _south_tile + 1) + variation;
                        _wall_tm.set_tile(_x, _y, _tile_index);
                    } break;
                }
            }
        }
    }
    
    static activate = function()
    {
        _active = true;
        _floor_tm.set_visible( true );
        _wall_tm.set_visible( true );
    }
    
    static deactivate = function()
    {
        _active = false;
        _floor_tm.set_visible( false );
        _wall_tm.set_visible( false );
        for (var i = 0; i < array_length(_active_game_objects); ++i) {
            var ins = _active_game_objects[i];
            if (ins.dont_deactivate) continue;
            array_push(_inactive_game_objects, ins);
            array_delete(_active_game_objects, i--, 1);
            ins.active = false;
            instance_deactivate_object(ins);
        }
        
        for (var i = 0; i < array_length(_active_lite_objects); ++i) {
            var ins = _active_lite_objects[i];
            array_push(_inactive_lite_objects, ins);
            array_delete(_active_lite_objects, i--, 1);
        }
        
    }
    
    static set_area = function(x1, y1, x2, y2, value)
    {
        ds_grid_set_region(_data, clamp(x1, 0, _size[X] - 1), clamp(y1, 0, _size[Y] - 1), 
                                  clamp(x2, 0, _size[X] - 1), clamp(y2, 0, _size[Y] - 1), value);
    }
    
    static set_cell = function(x, y, value)
    {
        ds_grid_set(_data, clamp(x, 0, _size[X] - 1), clamp(y, 0, _size[Y] - 1), value);
    }
    
    // Get map data from world coordinates
    static get_cell = function(x, y)
    {
        return _data[# x div CELL_W, y div CELL_H];
    }
    
    // Get map data from grid coordinates
    static get_cell_raw = function(x, y)
    {
        return _data[# floor(x), floor(y)];
    }
    
    static valid = function()
    {
        return _valid;
    }
    
    static active = function()
    {
        return _active;
    }
    
    static destroy = function()
    {
        _valid = false;
        ds_grid_destroy(_data);
        _floor_tm.destroy();
        _wall_tm.destroy();
    }
}

function TileMap(tileset, depth, w, h) constructor
{
    _tileset = tileset;
    _size = [w, h];
    _depth = depth;
    _layer = layer_create(_depth);
    _tilemap = layer_tilemap_create(_layer, 0, 0, _tileset, _size[X], _size[Y]);
    layer_set_visible(_layer, false);
    
    static set_tile = function( x, y, data )
    {
        tilemap_set(_tilemap, data, x, y);
    }
    
    static set_visible = function( value )
    {
        layer_set_visible(_layer, value);
    }
    
    static destroy = function()
    {
        layer_tilemap_destroy(_tilemap);
        layer_destroy(_layer);
    }
}

/****** This is the index ledger of the tilesheet.
 * Frames 0-16 should always stay the same, while any arbitrary number of 
 * floor and front-facing wall tiles could be implemented post 16.
 * If new variants are needed for frame 1-16 a new set of tiles can be created
 * after the last tile in the tilesheet, but the index will have to stay the same.
 *
 * Indexing a tile is then performed like this:
 *   tile = (max_tiles_for_one_variant * variant) * orientation
 * Wall orientation tile (index 1-16) is calculated bitwise while floor and
 * font-facing wall tiles will have to be calculated manually.
 ***/
enum TILE_ORIENTATION {
    EMPTY  = 0,
    CLOSED = 1,
    ESW    = 2,
    NES    = 3,
    ES     = 4,
    NSW    = 5,
    SW     = 6,
    NS     = 7,
    S      = 8,
    WNE    = 9,
    EW     = 10,
    NE     = 11,
    E      = 12,
    NW     = 13,
    W      = 14,
    N      = 15,
    OPEN   = 16,
    
    FLOOR0 = 17,
    FLOOR1 = 18,
    FLOOR2 = 19,
    FLOOR3 = 20,
    WALL0  = 21,
    WALL1  = 22,
    WALL2  = 23
}

