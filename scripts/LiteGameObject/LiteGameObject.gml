
/*** Lightweight Game Objects
 * To create a light object class, inherit either
 * AnimatedLiteGameObject or LiteGameObject, and extend
 * the class with variables and methods as needed.
 * 
 * NOTE:
 *   - LGOs are not depth sorted, and always drawn
 *     after regular Game Objects
 *   - LGOs ALWAYS needs to have an update and
 *     draw method. Override when creating new classes!
 **/


function AnimatedLiteGameObject(_x_start, _y_start, _sprite) : LiteGameObject(_x_start, _y_start, _sprite) constructor
{
    image_num = sprite_get_number(_sprite);
    image_ind = 0;
    animation_speed = 1;
    xscale = 1;
    yscale = 1;
    rotation = 0;
    alpha = 1;
    
    static set_sprite = function(_spr) { sprite_ind = _spr; image_num = sprite_get_number(_spr); }
    static set_subimage = function(_num) { image_ind = _num; }
    static set_animation_speed = function(_num) { animation_speed = _num; }
    static set_xscale = function(_num) { xscale = _num; }
    static set_yscale = function(_num) { yscale = _num; }
    static set_scale = function(_num) { xscale = _num; yscale = _num; }
    static set_rotation = function(_num) { rotation = _num; }
    static set_alpha = function(_num) { alpha = _num; }
    
    static animate = function(_delta)
    {
        image_ind = (image_ind + (animation_speed * _delta)) % image_num;
    }
    
    static draw = function()
    {
        if (sprite_index < 0) return;
        draw_sprite_ext(sprite_index, image_ind, x, y, xscale, yscale, rotation, zdata, alpha);
    }
}


function LiteGameObject(_x_start, _y_start, _sprite) constructor
{
    x = _x_start;
    y = _y_start;
    sprite_ind = _sprite;
    array_push(ACTIVE_LITE_OBJECTS, self);
    
    static set_sprite = function(_spr) { sprite_ind = _spr; }
    
    // Override the update and draw when implementing new LiteGameObject ancestor, if needed.
    static update = function(_delta) { }
    static draw = function()
    {
        if (sprite_ind < 0) return;
        draw_sprite_ext(sprite_ind, 0, x, y, 1, 1, 0, c_white, 1.0);
    }
    
    static destroy = function()
    {
        var _i = array_get_index(ACTIVE_LITE_OBJECTS, self);
        if (_i >= 0) array_delete(ACTIVE_LITE_OBJECTS, _i, 1);
        _i = array_get_index(INACTIVE_LITE_OBJECTS, self);
        if (_i >= 0) array_delete(INACTIVE_LITE_OBJECTS, _i, 1);
    }
}