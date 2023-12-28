global._particle_systems = ds_list_create();
global._particles = ds_map_create();

function ParticleController() constructor
{
    framebuffer = 0;
    
    function destroy() {
        // Destroy all particle types
        if (!is_undefined(global._particles) && ds_exists(global._particles, ds_type_map)) {
            for (var _k = ds_map_find_first(global._particles); !is_undefined(_k); _k = ds_map_find_first(global._particles)) {
                part_type_destroy(global._particles[? _k]);
                ds_map_delete(global._particles, _k);
            }
        }
        // Destroy all systems
        if (!is_undefined(global._particle_systems) && ds_exists(global._particle_systems, ds_type_list)) {
            for (var _i = ds_list_size(global._particle_systems)-1; _i >= 0; _i--)
            {
                global._particle_systems[| _i].destroy();
            }
        }
    }
    destroy();
    
    function update(_delta) {
        framebuffer = min(framebuffer + _delta, 3);
        var _frames = floor(framebuffer);
        framebuffer -= _frames;
        
        var _size = ds_list_size(global._particle_systems);
        for (var _i = 0; _i < _size; _i++)
        {
            global._particle_systems[| _i].check_active();
            for (var _j = 0; _j < _frames; _j++)
                global._particle_systems[| _i].update();
        }
    }
    
    function add_particle(_particle) {
		var _name = _particle[0];
        var _exists = ds_map_find_value(global._particles, _name);
        if (!is_undefined(_exists)) show_error("Particle under key '" + string(_name) + "' already exists!", true);
        
        ds_map_add(global._particles, _name, _particle[1]);
    }
    
}

function load_particle(_name) {
    var _particle = ds_map_find_value(global._particles, _name);
    if (is_undefined(_particle)) show_error("Particle '" + string(_name) + "' does not exist!", true);
    return _particle;
}

function ParticleSystem(_depth) constructor {
    
    // System
    index  = part_system_create();
    active = true;
    parent = other;
    if (is_string(_depth)) {
        part_system_layer(index, layer_get_id(_depth));
    } else {
        part_system_depth(index, _depth);
    }
    part_system_automatic_update(index, false);
    
    // Emitters
    emitters = array_create(0);
    
    // Functions
    static update = function() {
        if (active) part_system_update(index);
    }
    
    static set_depth = function(_depth) {
        part_system_depth(index, _depth);
    }
    
    static check_active = function() {
        if (active) {
            if (!instance_exists(parent)) {
                active = false;
                part_system_automatic_draw(index, false);
            }
        } else {
            if (instance_exists(parent)) {
                active = true;
                part_system_automatic_draw(index, true);
            }
        }
    }
    
    static destroy = function() {
        // Destroy emitters
        part_emitter_destroy_all(index);
        // Destroy system
        var _g_index = ds_list_find_index(global._particle_systems, self);
        part_system_destroy(index);
        ds_list_delete(global._particle_systems, _g_index);
        for (var _i = 0; _i < array_length(emitters); ++_i) {
            delete emitters[_i];
        }
    }
    
    static remove_deleted_emitters = function() {
        for (var _i = 0; _i < array_length(emitters); ++_i) {
            if (!emitters[_i].valid) array_delete(emitters, _i--, 1);
        }
    }
    
    static create_emitter = function(_x1, _y1, _x2, _y2, _shape, _distribution) {
        var _emitter = new ParticleEmitter(index, _x1, _y1, _x2, _y2, _shape, _distribution);
        array_push(emitters, _emitter);
        return _emitter;
    }
    
    static spawn_particle = function(_x, _y, _particle, _quantity)
    {
        part_particles_create(index, _x, _y, _particle, _quantity);
    }
    
    ds_list_add(global._particle_systems, self);
}

function ParticleEmitter(_particle_system, _x1, _y1, _x2, _y2, _shape, _distribution) constructor
{
	shape = _shape;
	distribution = _distribution;
    emitter_ref = part_emitter_create(_particle_system);
    ps_ref = _particle_system;
    valid = true;
    part_emitter_region(ps_ref, emitter_ref, _x1, _x2, _y1, _y2, _shape, _distribution);
    
    static move = function(_x1, _y1, _x2, _y2)
    {
        part_emitter_region(ps_ref, emitter_ref, _x1, _x2, _y1, _y2, shape, distribution);
    }
    
    static set_region = function(_x1, _y1, _x2, _y2, _shape, _distribution)
    {
		shape = _shape;
		distribution = _distribution;
        part_emitter_region(ps_ref, emitter_ref, _x1, _x2, _y1, _y2, shape, distribution);
    }
    
    static burst = function(_particle, _quantity)
    {
        part_emitter_burst(ps_ref, emitter_ref, _particle, _quantity);
    }
    
    static set_stream = function(_particle, _quantity)
    {
        part_emitter_stream(ps_ref, emitter_ref, _particle, _quantity);
    }
    
    static spawn_particle_color = function(_x, _y, _color, _particle, _quantity)
    {
        part_particles_create_color(ps_ref, _x, _y, _particle, _color, _quantity);
    }
    
    static destroy = function()
    {
        part_emitter_destroy(ps_ref, emitter_ref);
        valid = false;
    }
}










