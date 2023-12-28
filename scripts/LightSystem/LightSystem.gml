#macro LIGHTS global.__light_sprites__
global.__light_system__ = new LightingSystem();

// If LIGHTSYSTEM_COMPATIBILITY_MODE is true, sprites created with ConstructLightSprite()
// will always have a size that is of a power of two, which might be required for some
// specific targets.
#macro LIGHTSYSTEM_COMPATIBILITY_MODE true

//////////////////////////  LIGHT SPRITES  //////////////////////////

LIGHTS = {
    debug: construct_light_sprite(32)
}


/////////////////////////////  METHODS  /////////////////////////////

function set_light_ambient(_color, _brightness) {
    global.__light_system__.set_ambient_light(_color, _brightness);
}

function set_light_blurring(_strength) {
    global.__light_system__.set_blur(_strength);
}

function get_light_blurring() {
    return global.__light_system__.blurring_amount;
}

function draw_lights() {
    global.__light_system__.draw();
}

function update_lights(_delta) {
    if (is_undefined(argument[0])) _delta = 1;
    global.__light_system__.update(_delta);
}

function cleanup_light_system(_active_only) {
    global.__light_system__.clean(_active_only);
}

function set_surface_format(_format) {
    global.__light_system__.surface_format = _format;
}

/////////////////////////////  SYSTEM  //////////////////////////////

function LightingSystem() constructor {

    light_sources = ds_list_create();
    vivid = true;
    blur = true;
    lightmap = -1;
    blurmap = -1;
    surface_format = surface_format_is_supported(surface_rgba16float) ? surface_rgba16float : surface_rgba8unorm;

    ambient_color = make_color_rgb(1, 16, 32);
    ambient_alpha = 0.9;
    blurring_amount = 3.0; // Higher blurring is good for bigger sprites

    uniform_resolution_hoz  = shader_get_uniform(sh_gaussian_horizontal, "resolution");
    uniform_resolution_vert = shader_get_uniform(sh_gaussian_vertical,   "resolution");

    static add_lightsource = function(_ls) {
        ds_list_add(light_sources, _ls);
    }

    static set_ambient_light = function(_color, _brightness) {
        ambient_color = _color;
        ambient_alpha = _brightness;
    }

    static set_blur = function(_strength) {
        if (_strength <= 0) blur = false;
        else blur = true;
        blurring_amount = _strength;
    }

    static draw = function() {
        
        var _cam = view_get_camera(view_current);
        
        // Prepare lightmap
        if (!surface_exists(lightmap)) {
            lightmap = surface_create(camera_get_view_width(_cam), camera_get_view_height(_cam), surface_format);
        }
        
        surface_set_target(lightmap);

            // Draw ambience
            draw_clear(c_black);
            draw_set_alpha(ambient_alpha);
            draw_set_color(ambient_color);
            draw_rectangle(0, 0, surface_get_width(lightmap), surface_get_height(lightmap), false);

            // Draw lights
            draw_set_alpha(1);
            gpu_set_blendmode(bm_add);
            var _amt_lights = ds_list_size(light_sources);
            var _cam_x = camera_get_view_x(_cam);
            var _cam_y = camera_get_view_y(_cam);
            for (var _i = 0; _i < _amt_lights; ++_i) {
                light_sources[| _i].draw(_cam_x, _cam_y);
            }

        surface_reset_target();
        draw_set_colour(c_white);
        gpu_set_blendmode(bm_normal);

        if (blur) {

            // Prepare blurmap
            if (!surface_exists(blurmap)) {
                blurmap = surface_create(camera_get_view_width(_cam), camera_get_view_height(_cam));
            }

            var _resolution_x = camera_get_view_width(_cam)  / blurring_amount;
            var _resolution_y = camera_get_view_height(_cam) / blurring_amount;

            surface_set_target(blurmap);

                draw_clear(c_black);
                gpu_set_blendmode(bm_add);

                shader_set(sh_gaussian_horizontal);
                shader_set_uniform_f(uniform_resolution_hoz, _resolution_x, _resolution_y);
                draw_surface(lightmap, 0, 0);
                shader_reset();

            surface_reset_target();

            surface_set_target(lightmap);

                draw_clear(c_black);

                shader_set(sh_gaussian_vertical);
                shader_set_uniform_f(uniform_resolution_vert, _resolution_x, _resolution_y);
                draw_surface(blurmap, 0, 0);
                shader_reset();

            surface_reset_target();
            draw_set_colour(c_white);
            gpu_set_blendmode(bm_normal);
        }
        
        // Draw vivid lightmap
        if (vivid) {
            gpu_set_blendmode(bm_add);
            draw_surface_ext(lightmap, camera_get_view_x(_cam), camera_get_view_y(_cam), 1, 1, 0, c_white, 0.25);
        }

        // Draw standard lightmap
        gpu_set_blendmode_ext(bm_dest_color, bm_zero);
        draw_surface(lightmap, camera_get_view_x(_cam), camera_get_view_y(_cam));
        gpu_set_blendmode(bm_normal);
            
    }

    static update = function(_delta) {

        var _amt_lights = ds_list_size(light_sources);
        for (var _i = 0; _i < _amt_lights; ++_i) {
            light_sources[| _i].update(_delta);
        }

    }

    static delete_lightsource = function(_ls) {
        ds_list_delete(light_sources, ds_list_find_index(light_sources, _ls));
    }

    static free = function() {
        if (surface_exists(lightmap)) surface_free(lightmap);
        if (surface_exists(blurmap)) surface_free(blurmap);

        var _amt = ds_list_size(light_sources);
        for (var _i = _amt-1; _i >= 0; --_i) {
            light_sources[| _i].free();
        }
        ds_list_destroy(light_sources);
    }

    static clean = function(_active_only) {
        var _amt = ds_list_size(light_sources);
        for (var _i = _amt-1; _i >= 0; --_i) {
            if (!_active_only || !light_sources[| _i]._active)
                light_sources[| _i].free();
        }
    }

}

function construct_light_sprite(_size) {
    if (LIGHTSYSTEM_COMPATIBILITY_MODE) {
        _size -= 1;
        _size |= _size >> 1;
        _size |= _size >> 2;
        _size |= _size >> 4;
        _size |= _size >> 8;
        _size |= _size >> 16;
        _size += 1;
    }
    var _surf;
    var _radius = _size div 2;
    _surf = surface_create(_size, _size);

    surface_set_target(_surf);
        draw_clear(c_black);
        draw_set_alpha(1);
        draw_circle_color(_radius, _radius, _radius, c_white, c_black, false);
    surface_reset_target();

    var _spr = sprite_create_from_surface(_surf, 0, 0, _size, _size, true, true, _radius, _radius);
    surface_free(_surf);
    return _spr;
}

function LightFlicker(_attributes) constructor {

    static _pi2 = pi * 2;
    amplitude = variable_struct_exists(_attributes, "amplitude") ? _attributes.amplitude : 0.1;
    speed = variable_struct_exists(_attributes, "speed") ? _attributes.speed : 0.02;
    angle = variable_struct_exists(_attributes, "angle") ? _attributes.angle : random(_pi2);
    value = 0;

    static update = function(_delta) {
        angle = (angle + speed * _delta) % _pi2;
        value = sin(angle);
        return value * amplitude;
    }
}

function LightSource(_spr, _attributes) constructor {

    global.__light_system__.add_lightsource(self);
    if (is_undefined(argument[1])) _attributes = {};

    sprite = _spr;
    active = true;
    owner = other;
    alive = true;
    scale = variable_struct_exists(_attributes, "scale") ? _attributes.scale : 1.0;
    color = variable_struct_exists(_attributes, "color") ? _attributes.color : c_white;
    alpha = variable_struct_exists(_attributes, "alpha") ? _attributes.alpha : 1.0;
    if (variable_struct_exists(_attributes, "size")) scale = _attributes.size / sprite_get_height(sprite);
    x = owner.x;
    y = owner.y;
    ox = variable_struct_exists(_attributes, "x") ? _attributes.x : 0;
    oy = variable_struct_exists(_attributes, "y") ? _attributes.y : 0;

    flicker = variable_struct_exists(_attributes, "flicker") ? true : false;
    flicker_struct = flicker ? new LightFlicker(_attributes.flicker) : undefined;
    flicker_val = 0;

    static free = function() {
        active = false;
        if (!alive) return;
        alive = false;
        global.__light_system__.delete_lightsource(self);
    }

    static activate = function() {
        active = true;
        if (!alive) { alive = true; global.__light_system__.add_lightsource(self); }
    }
    static deactivate = function() { active = false; }
    static get_active = function() { return active; }
    static set_active = function(_value) { active = _value; }

    static get_flicker = function() { return flicker; }
    static set_flicker = function(_params) {
        if (is_bool(_params) && !_params) flicker = false;
        else { flicker = true; flicker_struct = new LightFlicker(_params); }
    }
    
    static move = function(_dx, _dy) { ox += _dx; oy += _dy; }
    static set_offset = function(_x, _y) { ox = _x; oy = _y; }
    static set_color_ext = function(_color, _alpha) { color = _color; alpha = _alpha; }
    static set_color = function(_color) { color = _color; }
    static set_alpha = function(_alpha) { alpha = _alpha; }
    static set_scale = function(_scale) { scale = _scale; }
    static set_size = function(_size) { scale = _size / sprite_get_height(sprite); }
    static get_offset = function() { return [ox, oy]; }
    static get_color = function() { return color; }
    static get_alpha = function() { return alpha; }
    static get_scale = function() { return scale; }

    static update = function(_delta) {
        if (!instance_exists(owner)) { active = false; return; }
        if (!active) return;
        if (flicker) flicker_val = flicker_struct.update(_delta);
        
        x = owner.x + ox;
        y = owner.y + oy;
    }
    
    static draw = function(_cam_x, _cam_y) {
        if (!active) return;
        draw_sprite_ext(sprite, 0, x - _cam_x, y - _cam_y, scale, scale, 0, color, alpha + flicker_val);
    }

}