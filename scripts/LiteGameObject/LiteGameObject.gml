
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


function AnimatedLiteGameObject(x_start, y_start, sprite) : LiteGameObject(x_start, y_start, sprite) constructor
{
    image_number = sprite_get_number(sprite);
    image_index = 0;
    animation_speed = 1;
    xscale = 1;
    yscale = 1;
    rotation = 0;
    blend = c_white;
    alpha = 1;
    
    static set_sprite = function(spr) { sprite_index = spr; image_number = sprite_get_number(spr); }
    static set_subimage = function(num) { image_index = num; }
    static set_animation_speed = function(num) { animation_speed = num; }
    static set_xscale = function(num) { xscale = num; }
    static set_yscale = function(num) { yscale = num; }
    static set_scale = function(num) { xscale = num; yscale = num; }
    static set_rotation = function(num) { rotation = num; }
    static set_blend = function(col) { blend = col; }
    static set_alpha = function(num) { alpha = num; }
    
    static animate = function(delta)
    {
        image_index = (image_index + (animation_speed * delta)) % image_number;
    }
    
    static draw = function()
    {
        if (sprite_index < 0) return;
        draw_sprite_ext(sprite_index, image_index, x, y, xscale, yscale, rotation, blend, alpha);
    }
}


function LiteGameObject(start_x, start_y, sprite) constructor
{
    x = start_x;
    y = start_y;
    sx = x;
    sy = y;
    sprite_index = sprite;
    array_push(ACTIVE_LITE_OBJECTS, self);
    
    static set_sprite = function(spr) { sprite_index = spr; }
    
    // Override the update and draw when implementing new LiteGameObject ancestor, if needed.
    static update = function(delta) { x = sx + cos(current_time * 0.005) * 8; y = sy + sin(current_time * 0.005) * 8; }
    static draw = function()
    {
        if (sprite_index < 0) return;
        draw_sprite(sprite_index, 0, x, y);
    }
}