
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

#macro SECURE_WORLD_DIRECT_LOOKUP    { _x = clamp(_x, 0, size[X] - 1); _y = clamp(_y, 0, size[Y] - 1); }
#macro UNSECURE_WORLD_DIRECT_LOOKUP  { }
#macro SECURE_WORLD_SQUARE_LOOKUP    { _x1 = clamp(_x1, 0, size[X] - 1); _y1 = clamp(_y1, 0, size[Y] - 1); \
                                       _x2 = clamp(_x2, 0, size[X] - 1); _y2 = clamp(_y2, 0, size[Y] - 1); }
#macro UNSECURE_WORLD_SQUARE_LOOKUP  { }

// feather disable GM1038
#macro DIRECT_LOOKUP_SAFETY          UNSECURE_WORLD_DIRECT_LOOKUP
#macro SQUARE_LOOKUP_SAFETY          UNSECURE_WORLD_SQUARE_LOOKUP
#macro Debug:DIRECT_LOOKUP_SAFETY    SECURE_WORLD_DIRECT_LOOKUP
#macro Debug:SQUARE_LOOKUP_SAFETY    SECURE_WORLD_SQUARE_LOOKUP

#macro ACTIVE_GAME_OBJECTS    CURRENT_LEVEL.active_game_objects
#macro INACTIVE_GAME_OBJECTS  CURRENT_LEVEL.inactive_game_objects

#macro ACTIVE_LITE_OBJECTS    CURRENT_LEVEL.active_lite_objects
#macro INACTIVE_LITE_OBJECTS  CURRENT_LEVEL.inactive_lite_objects

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

function World(_tileset, _w, _h) constructor
{
    tileset = _tileset;
    tile_variations = 2;       // TODO: Make dynamic
    tileset_max_tiles = 24;    // TODO: Make dynamic
    size = [_w, _h];
    valid = true;
    active = false;
    data = ds_grid_create(_w, _h);
    ds_grid_set_region(data, 0, 0, _w, _h, CELL_DATA.VOID);
    
    active_game_objects = [];
    inactive_game_objects = [];
    
    active_lite_objects = [];
    inactive_lite_objects = [];
    
    floor_tm = new TileMap(tileset, +50, _w, _h);
    wall_tm = new TileMap(tileset, -200, _w, _h);
    
    // World coordinates passed in. Collision if CELL_DATA is even (WALL bit set)
    // Returns
    // 0 (false): FLOOR
    // 1 (true):  WALL
    static check_collision_point = function(_x, _y)
    {
        _x = _x div CELL_W;
        _y = _y div CELL_H;
        DIRECT_LOOKUP_SAFETY
        return !(data[# _x, _y - 1] & 1) || !(data[# _x, _y] & 1);
    }
    
    static check_collision_square = function(_x1, _y1, _x2, _y2)
    {
        _x1 = _x1 div CELL_W; _y1 = _y1 div CELL_H;
        _x2 = _x2 div CELL_W; _y2 = _y2 div CELL_H;
        _y1 -= 1;
        SQUARE_LOOKUP_SAFETY
        return !(data[# _x1, _y1] & 1) || !(data[# _x2, _y2] & 1) ||
               !(data[# _x1, _y2] & 1) || !(data[# _x2, _y1] & 1);
    }
    
    static get_cell_data = function(_x, _y)
    {
        DIRECT_LOOKUP_SAFETY
        return data[# _x, _y]; 
    }
    
    static get_cell_coordinates = function(_x, _y)
    {
        var _xx = (_x div CELL_W) * CELL_W;
        var _yy = (_y div CELL_H) * CELL_H;
        return [ _xx, _yy, _xx + CELL_W, _yy + CELL_H];
    }
    
    // Grid coordinates passed instead of world coordinates, usefull when pre-computing
    // coordinates for multiple calls.
    static check_collision_point_raw = function(_x, _y)
    {
        DIRECT_LOOKUP_SAFETY
        return !(data[# _x, _y] & 1);
    }
    
    static render = function(_x1 = 1, _y1 = 1, _x2 = size[X]-1, _y2 = size[Y]-1) {
        _x1 = clamp(_x1, 1, size[X]-1);
        _x2 = clamp(_x2, 1, size[X]-1);
        _y1 = clamp(_y1, 1, size[Y]-1);
        _y2 = clamp(_y2, 1, size[Y]-1);
        for (var _x = _x1; _x < _x2; ++_x) {
            for (var _y = _y1; _y < _y2; ++_y) {
                var _variation = tileset_max_tiles * irandom(tile_variations-1);
                switch (data[# _x, _y]) {
                    case CELL_DATA.FLOOR: {
                        // CLEAR OLD WALLS FROM TILE
                        wall_tm.set_tile(_x, _y, TILE_ORIENTATION.EMPTY);
                        // INNER WALL
                        if ((data[# _x, _y-1] != CELL_DATA.FLOOR))
                             floor_tm.set_tile(_x, _y, irandom_range(TILE_ORIENTATION.WALL0, TILE_ORIENTATION.WALL2) + _variation);
                        // FLOOR
                        else floor_tm.set_tile(_x, _y, irandom_range(TILE_ORIENTATION.FLOOR0, TILE_ORIENTATION.FLOOR3) + _variation);
                        
                    } break;
                    default: {
                        // WALLS ( data % 2 to check if void/wall bit is set, invert to check NOT void/wall )
                        var _north_tile = !(data[# _x, _y-1] & 1) * 1;
                        var _west_tile  = !(data[# _x-1, _y] & 1) * 2;
                        var _east_tile  = !(data[# _x+1, _y] & 1) * 4;
                        var _south_tile = !(data[# _x, _y+1] & 1) * 8;
                        var _tile_index = (_north_tile + _west_tile + _east_tile + _south_tile + 1) + _variation;
                        wall_tm.set_tile(_x, _y, _tile_index);
                    } break;
                }
            }
        }
    }
    
    static activate = function()
    {
        active = true;
        floor_tm.set_visible( true );
        wall_tm.set_visible( true );
    }
    
    static deactivate = function()
    {
        active = false;
        floor_tm.set_visible( false );
        wall_tm.set_visible( false );
        for (var _i = 0; _i < array_length(active_game_objects); ++_i) {
            var _ins = active_game_objects[_i];
            if (_ins.dont_deactivate) continue;
            array_push(inactive_game_objects, _ins);
            array_delete(active_game_objects, _i--, 1);
            _ins.active = false;
            instance_deactivate_object(_ins);
        }
        
        for (var _i = 0; _i < array_length(active_lite_objects); ++_i) {
            var _ins = active_lite_objects[_i];
            array_push(inactive_lite_objects, _ins);
            array_delete(active_lite_objects, _i--, 1);
        }
        
    }
    
    static set_area = function(_x1, _y1, _x2, _y2, _value)
    {
        ds_grid_set_region(data, clamp(_x1, 0, size[X] - 1), clamp(_y1, 0, size[Y] - 1), 
                                  clamp(_x2, 0, size[X] - 1), clamp(_y2, 0, size[Y] - 1), _value);
    }
    
    static set_cell = function(_x, _y, _value)
    {
        ds_grid_set(data, clamp(_x, 0, size[X] - 1), clamp(_y, 0, size[Y] - 1), _value);
    }
    
    // Get map data from world coordinates
    static get_cell = function(_x, _y)
    {
        return data[# _x div CELL_W, _y div CELL_H];
    }
    
    // Get map data from grid coordinates
    static get_cell_raw = function(_x, _y)
    {
        return data[# floor(_x), floor(_y)];
    }
    
    static is_valid = function()
    {
        return valid;
    }
    
    static is_active = function()
    {
        return active;
    }
    
    static destroy = function()
    {
        valid = false;
        ds_grid_destroy(data);
        floor_tm.destroy();
        wall_tm.destroy();
    }
}

function TileMap(_tileset, _depth, _w, _h) constructor
{
    tileset = _tileset;
    size = [_w, _h];
    layer_handle = layer_create(_depth);
    tilemap = layer_tilemap_create(layer_handle, 0, 0, tileset, size[X], size[Y]);
    layer_set_visible(layer_handle, false);
    
    static set_tile = function( _x, _y, _data )
    {
        tilemap_set(tilemap, _data, _x, _y);
    }
    
    static set_visible = function( _value )
    {
        layer_set_visible(layer_handle, _value);
    }
    
    static destroy = function()
    {
        layer_tilemap_destroy(tilemap);
        layer_destroy(layer_handle);
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

