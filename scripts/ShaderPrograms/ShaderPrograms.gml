enum U_TYPE {
    FLOAT,
    INT,
    F_VEC,
    I_VEC
}

function ShaderProgram(_shader) constructor
{
    program = _shader;
    uniforms = {};
	
    add_uniform = function(_name, _u_type) {
        var _u = shader_get_uniform(program, _name);
        switch (_u_type) {
            case U_TYPE.FLOAT: {
                variable_struct_set(uniforms, _name, {
                    uniform: _u,
                    set: function(_value) { shader_set_uniform_f( uniform, _value ); }
                });
            } break;
            case U_TYPE.INT: {
                variable_struct_set(uniforms, _name, {
                    uniform: _u,
                    set: function(_value) { shader_set_uniform_i( uniform, _value ); }
                });
            } break;
            case U_TYPE.F_VEC: {
                variable_struct_set(uniforms, _name, {
                    uniform: _u,
                    set: function(_value) { shader_set_uniform_f_array( uniform, _value ); }
                });
            } break;
            case U_TYPE.I_VEC: {
                variable_struct_set(uniforms, _name, {
                    uniform: _u,
                    set: function(_value) { shader_set_uniform_i_array( uniform, _value ); }
                });
            } break;
            default: {
                throw "Called add_uniform without specifying type";
            } break;
        }
    }
	
	set_uniform = function(_name, _value) {
		struct_get(uniforms, _name).set(_value);
	}
    
    add_sampler = function(_name, _texture) {
        // TODO: Allow sprites baked into non-empty texture groups
        var _sampler_index = shader_get_sampler_index(program, _name);
        var _text = sprite_get_texture(_texture, 0);
        variable_struct_set(uniforms, _name, {
            index: _sampler_index,
            texture: _text,
            bind: function() {
                texture_set_stage(index, texture);
            }
        });
    }
    
    set = function() {
        shader_set(program);
    }
    
    reset = function() {
        shader_reset();
    }
}