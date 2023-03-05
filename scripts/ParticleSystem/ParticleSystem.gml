global.__ParticleSystems = ds_list_create();
global.__Particles = ds_map_create();

function ParticleController() constructor
{
    framebuffer = 0;
    
    function destroy() {
        // Destroy all particle types
        if (!is_undefined(global.__Particles) && ds_exists(global.__Particles, ds_type_map)) {
            for (var k = ds_map_find_first(global.__Particles); !is_undefined(k); k = ds_map_find_first(global.__Particles)) {
                part_type_destroy(global.__Particles[? k]);
                ds_map_delete(global.__Particles, k);
            }
        }
        // Destroy all systems
        if (!is_undefined(global.__ParticleSystems) && ds_exists(global.__ParticleSystems, ds_type_list)) {
            for (var _i = ds_list_size(global.__ParticleSystems)-1; _i >= 0; _i--)
            {
                global.__ParticleSystems[| _i].destroy();
            }
        }
    }
    destroy();
    
    function update(delta) {
        framebuffer = min(framebuffer + delta, 3);
        var _frames = floor(framebuffer);
        framebuffer -= _frames;
        
        var _size = ds_list_size(global.__ParticleSystems);
        for (var _i = 0; _i < _size; _i++)
        {
            global.__ParticleSystems[| _i].check_active();
            for (var _j = 0; _j < _frames; _j++)
                global.__ParticleSystems[| _i].update();
        }
    }
    
    function add_particle(particle) {
		var _name = particle[0];
        var _exists = ds_map_find_value(global.__Particles, _name);
        if (!is_undefined(_exists)) show_error("Particle under key '" + string(_name) + "' already exists!", true);
        
        ds_map_add(global.__Particles, _name, particle[1]);
    }
    
}

function load_particle(name) {
    var _particle = ds_map_find_value(global.__Particles, name);
    if (is_undefined(_particle)) show_error("Particle '" + string(name) + "' does not exist!", true);
    return _particle;
}

function ParticleSystem(depth) constructor {
    
    // System
    index  = part_system_create();
    active = true;
    parent = other;
    if (is_string(depth)) {
        part_system_layer(index, depth);
    } else {
        part_system_depth(index, depth);
    }
    part_system_automatic_update(index, false);
    
    // Emitters
    emitters = [];
    
    // Functions
    static update = function() {
        if (active) part_system_update(index);
    }
    
    static set_depth = function(depth) {
        part_system_depth(index, depth);
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
        var _g_index = ds_list_find_index(global.__ParticleSystems, self);
        part_system_destroy(index);
        ds_list_delete(global.__ParticleSystems, _g_index);
        for (var i = 0; i < array_length(emitters); ++i) {
            delete emitters[i];
        }
    }
    
    static remove_deleted_emitters = function() {
        for (var i = 0; i < array_length(emitters); ++i) {
            if (!emitters[i]._valid) array_delete(emitters, i--, 1);
        }
    }
    
    static create_emitter = function(x1, y1, x2, y2, shape, distribution) {
        var _emitter = new ParticleEmitter(index, x1, y1, x2, y2, shape, distribution);
        array_push(emitters, _emitter);
        return _emitter;
    }
    
    static spawn_particle = function(x, y, particle, quantity)
    {
        part_particles_create(index, x, y, particle, quantity);
    }
    
    ds_list_add(global.__ParticleSystems, self);
}

function ParticleEmitter(particle_system, x1, y1, x2, y2, shape, distribution) constructor
{
    _x1 = x1; _y1 = y1; _x2 = x2; _y2 = y2;
    _shape = shape; _distribution = distribution;
    _emitter_ref = part_emitter_create(particle_system);
    _ps_ref = particle_system;
    _valid = true;
    part_emitter_region(_ps_ref, _emitter_ref, _x1, _x2, _y1, _y2, _shape, _distribution);
    
    static move = function(x1, y1, x2, y2)
    {
        part_emitter_region(_ps_ref, _emitter_ref, x1, x2, y1, y2, _shape, _distribution);
    }
    
    static set_region = function(x1, y1, x2, y2, shape, distribution)
    {
        part_emitter_region(_ps_ref, _emitter_ref, x1, x2, y1, y2, shape, distribution);
    }
    
    static burst = function(particle, quantity)
    {
        part_emitter_burst(_ps_ref, _emitter_ref, particle, quantity);
    }
    
    static set_stream = function(particle, quantity)
    {
        part_emitter_stream(_ps_ref, _emitter_ref, particle, quantity);
    }
    
    static spawn_particle_color = function(x, y, color, particle, quantity)
    {
        part_particles_create_color(_ps_ref, x, y, particle, color, quantity);
    }
    
    static destroy = function()
    {
        part_emitter_destroy(_ps_ref, _emitter_ref);
        _valid = false;
    }
}










