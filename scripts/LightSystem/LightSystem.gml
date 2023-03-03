#macro LIGHTS global.__light_sprites__
global.__light_system__ = new LightingSystem();

// If LIGHTSYSTEM_COMPATIBILITY_MODE is true, sprites created with ConstructLightSprite()
// will always have a size that is of a power of two, which might be required for some
// specific targets.
#macro LIGHTSYSTEM_COMPATIBILITY_MODE true

//////////////////////////  LIGHT SPRITES  //////////////////////////

LIGHTS = {
    debug: ConstructLightSprite(32)
}


/////////////////////////////  METHODS  /////////////////////////////

function SetLightAmbient(color, brightness) {
    global.__light_system__.set_ambient_light(color, brightness);
}

function SetLightBlurring(strength) {
    global.__light_system__.set_blur(strength);
}

function GetLightBlurring() {
    return global.__light_system__._blurring_amount;
}

function DrawLights() {
    global.__light_system__.draw();
}

function UpdateLights(delta) {
    if (is_undefined(argument[0])) delta = 1;
    global.__light_system__.update(delta);
}

function CleanupLightSystem(active_only) {
    global.__light_system__.clean(active_only);
}


/////////////////////////////  SYSTEM  //////////////////////////////

function LightingSystem() constructor {

    _light_sources = ds_list_create();
    _vivid = true;
    _blur = true;
    _lightmap = -1;
    _blurmap = -1;

    _ambient_color = make_color_rgb(1, 16, 32);
    _ambient_alpha = 0.9;
    _blurring_amount = 3.0; // Higher blurring is good for bigger sprites

    _uniform_resolution_hoz  = shader_get_uniform(shd_gaussian_horizontal, "resolution");
    _uniform_resolution_vert = shader_get_uniform(shd_gaussian_vertical,   "resolution");

    static add_lightsource = function(ls) {
        ds_list_add(_light_sources, ls);
    }

    static set_ambient_light = function(color, brightness) {
        _ambient_color = color;
        _ambient_alpha = brightness;
    }

    static set_blur = function(strength) {
        if (strength <= 0) _blur = false;
        else _blur = true;
        _blurring_amount = strength;
    }

    static draw = function() {
        
        var cam = view_get_camera(view_current);
        
        // Prepare lightmap
        if (!surface_exists(_lightmap)) {
            _lightmap = surface_create(camera_get_view_width(cam), camera_get_view_height(cam));
        }
        
        surface_set_target(_lightmap);

            // Draw ambience
            draw_clear(c_black);
            draw_set_alpha(_ambient_alpha);
            draw_set_color(_ambient_color);
            draw_rectangle(0, 0, surface_get_width(_lightmap), surface_get_height(_lightmap), false);

            // Draw lights
            draw_set_alpha(1);
            gpu_set_blendmode(bm_add);
            var amt_lights = ds_list_size(_light_sources);
            var cam_x = camera_get_view_x(cam);
            var cam_y = camera_get_view_y(cam);
            for (var i = 0; i < amt_lights; ++i) {
                _light_sources[| i].draw(cam_x, cam_y);
            }

        surface_reset_target();
        draw_set_colour(c_white);
        gpu_set_blendmode(bm_normal);

        if (_blur) {

            // Prepare blurmap
            if (!surface_exists(_blurmap)) {
                _blurmap = surface_create(camera_get_view_width(cam), camera_get_view_height(cam));
            }

            var resolution_x = camera_get_view_width(cam)  / _blurring_amount;
            var resolution_y = camera_get_view_height(cam) / _blurring_amount;

            surface_set_target(_blurmap);

                draw_clear(c_black);
                gpu_set_blendmode(bm_add);

                shader_set(shd_gaussian_horizontal);
                shader_set_uniform_f(_uniform_resolution_hoz, resolution_x, resolution_y);
                draw_surface(_lightmap, 0, 0);
                shader_reset();

            surface_reset_target();

            surface_set_target(_lightmap);

                draw_clear(c_black);

                shader_set(shd_gaussian_vertical);
                shader_set_uniform_f(_uniform_resolution_vert, resolution_x, resolution_y);
                draw_surface(_blurmap, 0, 0);
                shader_reset();

            surface_reset_target();
            draw_set_colour(c_white);
            gpu_set_blendmode(bm_normal);
        }
        
        // Draw vivid lightmap
        if (_vivid) {
            gpu_set_blendmode(bm_add);
            draw_surface_ext(_lightmap, camera_get_view_x(cam), camera_get_view_y(cam), 1, 1, 0, c_white, 0.25);
        }

        // Draw standard lightmap
        gpu_set_blendmode_ext(bm_dest_color, bm_src_color);
        draw_surface(_lightmap, camera_get_view_x(cam), camera_get_view_y(cam));
        gpu_set_blendmode(bm_normal);
            
    }

    static update = function(delta) {

        var amt_lights = ds_list_size(_light_sources);
        for (var i = 0; i < amt_lights; ++i) {
            _light_sources[| i].update(delta);
        }

    }

    static delete_lightsource = function(ls) {
        ds_list_delete(_light_sources, ds_list_find_index(_light_sources, ls));
    }

    static free = function() {
        if (surface_exists(_lightmap)) surface_free(_lightmap);
        if (surface_exists(_blurmap)) surface_free(_blurmap);

        var amt = ds_list_size(_light_sources);
        for (var i = amt-1; i >= 0; --i) {
            _light_sources[| i].free();
        }
        ds_list_destroy(_light_sources);
    }

    static clean = function(active_only) {
        var amt = ds_list_size(_light_sources);
        for (var i = amt-1; i >= 0; --i) {
            if (!active_only || !_light_sources[| i]._active)
                _light_sources[| i].free();
        }
    }

}

function ConstructLightSprite(size) {
    if (LIGHTSYSTEM_COMPATIBILITY_MODE) {
        size -= 1;
        size |= size >> 1;
        size |= size >> 2;
        size |= size >> 4;
        size |= size >> 8;
        size |= size >> 16;
        size += 1;
    }
    var surf;
    var radius = size div 2;
    surf = surface_create(size, size);

    surface_set_target(surf);
        draw_clear(c_black);
        draw_set_alpha(1);
        draw_circle_color(radius, radius, radius, c_white, c_black, false);
    surface_reset_target();

    var spr = sprite_create_from_surface(surf, 0, 0, size, size, true, true, radius, radius);
    surface_free(surf);
    return spr;
}

function __LightFlicker__(attributes) constructor {

    static _PI2 = pi * 2;
    _amplitude = variable_struct_exists(attributes, "amplitude") ? attributes.amplitude : 0.1;
    _speed = variable_struct_exists(attributes, "speed") ? attributes.speed : 0.02;
    _angle = variable_struct_exists(attributes, "angle") ? attributes.angle : random(_PI2);
    _value = 0;

    static update = function(delta) {
        _angle = (_angle + _speed * delta) % _PI2;
        _value = sin(_angle);
        return _value * _amplitude;
    }

    if (false) { // CLEAR "ONLY REFERENCED ONCE" WARNINGS
        attributes.amplitude = 0;
        attributes.angle = 0;
    }
}

function LightSource(spr, attributes) constructor {

    global.__light_system__.add_lightsource(self);
    if (is_undefined(argument[1])) attributes = {};

    _sprite = spr;
    _active = true;
    _owner = other;
    _alive = true;
    _scale = variable_struct_exists(attributes, "scale") ? attributes.scale : 1.0;
    _color = variable_struct_exists(attributes, "color") ? attributes.color : c_white;
    _alpha = variable_struct_exists(attributes, "alpha") ? attributes.alpha : 1.0;
    if (variable_struct_exists(attributes, "size")) _scale = attributes.size / sprite_get_height(_sprite);
    _x = _owner.x;
    _y = _owner.y;
    _ox = variable_struct_exists(attributes, "x") ? attributes.x : 0;
    _oy = variable_struct_exists(attributes, "y") ? attributes.y : 0;

    _flicker = variable_struct_exists(attributes, "flicker") ? true : false;
    _flicker_struct = _flicker ? new __LightFlicker__(attributes.flicker) : undefined;
    _flicker_val = 0;

    static free = function() {
        _active = false;
        if (!_alive) return;
        _alive = false;
        global.__light_system__.delete_lightsource(self);
    }

    static activate = function() {
        _active = true;
        if (!_alive) { _alive = true; global.__light_system__.add_lightsource(self); }
    }
    static deactivate = function() { _active = false; }
    static get_active = function() { return _active; }
    static set_active = function(value) { _active = value; }

    static get_flicker = function() { return _flicker; }
    static set_flicker = function(params) {
        if (is_bool(params) && !params) _flicker = false;
        else { _flicker = true; _flicker_struct = new __LightFlicker__(params); }
    }
    
    static move = function(dx, dy) { _ox += dx; _oy += dy; }
    static set_offset = function(x, y) { _ox = x; _oy = y; }
    static set_color_ext = function(color, alpha) { _color = color; _alpha = alpha; }
    static set_color = function(color) { _color = color; }
    static set_alpha = function(alpha) { _alpha = alpha; }
    static set_scale = function(scale) { _scale = scale; }
    static set_size = function(size) { _scale = size / sprite_get_height(_sprite); }
    static get_offset = function() { return [_ox, _oy]; }
    static get_color = function() { return _color; }
    static get_alpha = function() { return _alpha; }
    static get_scale = function() { return _scale; }
    
    static update = function(delta) {
        if (!instance_exists(_owner)) { _active = false; return; }
        if (!_active) return;
        if (_flicker) _flicker_val = _flicker_struct.update(delta);
        
        _x = _owner.x + _ox;
        _y = _owner.y + _oy;
    }
    
    static draw = function(cam_x, cam_y) {
        if (!_active) return;
        draw_sprite_ext(_sprite, 0, _x - cam_x, _y - cam_y, _scale, _scale, 0, _color, _alpha + _flicker_val);
    }
    
    if (false) { // CLEAR "ONLY REFERENCED ONCE" WARNINGS
        attributes.flicker = 0;
        activate();
        deactivate();
        get_active();
        set_active(0);
        get_flicker();
        set_flicker(0);
        move(0, 0);
        set_offset(0, 0);
        set_color_ext(0, 0);
        set_color(0);
        set_alpha(0);
        set_scale(0);
        set_size(0);
        get_offset();
        get_color();
        get_alpha();
        get_scale();
    }
}


if (false) { // CLEAR "ONLY REFERENCED ONCE" WARNINGS
    SetLightAmbient(0, 0);
    SetLightBlurring(0);
    GetLightBlurring();
    DrawLights();
    UpdateLights();
    CleanupLightSystem(false);
    var a = new LightSource(0, 0);
    delete a;
}