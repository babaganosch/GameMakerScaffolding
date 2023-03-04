enum U_TYPE {
    FLOAT,
    INT,
    F_VEC,
    I_VEC
}

function ShaderProgram(shader) constructor
{
    program = shader;
    uniforms = {};
    
    { // Clear warnings
        var texture = -1; texture = -1;
        var index = -1; index = -1;
        var uniform = -1; uniform = -1;
    }
    
    add_uniform = function(name, u_type) {
        var u = shader_get_uniform(program, name);
        switch (u_type) {
            case U_TYPE.FLOAT: {
                variable_struct_set(uniforms, name, {
                    uniform: u,
                    set: function(value) { shader_set_uniform_f( uniform, value ); }
                });
            } break;
            case U_TYPE.INT: {
                variable_struct_set(uniforms, name, {
                    uniform: u,
                    set: function(value) { shader_set_uniform_i( uniform, value ); }
                });
            } break;
            case U_TYPE.F_VEC: {
                variable_struct_set(uniforms, name, {
                    uniform: u,
                    set: function(value) { shader_set_uniform_f_array( uniform, value ); }
                });
            } break;
            case U_TYPE.I_VEC: {
                variable_struct_set(uniforms, name, {
                    uniform: u,
                    set: function(value) { shader_set_uniform_i_array( uniform, value ); }
                });
            } break;
            default: {
                throw "Called add_uniform without specifying type";
            } break;
        }
    }
    
    add_sampler = function(name, texture) {
        // TODO: Allow sprites baked into non-empty texture groups
        var sampler_index = shader_get_sampler_index(program, name);
        var text = sprite_get_texture(texture, 0);
        variable_struct_set(uniforms, name, {
            index: sampler_index,
            texture: text,
            bind: function() {
                texture_set_stage(index, texture);
            }
        });
        if (false) { bind(); }
    }
    
    set = function() {
        shader_set(program);
    }
    
    reset = function() {
        shader_reset();
    }
    
    if (false)
    {
        add_uniform(0, 0);  
        add_sampler(0, 0);
    }
}