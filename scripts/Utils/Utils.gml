#macro PERSISTENT_CLEANUP { persistent = false; if(!variable_instance_get(self, "__clean__")) \
{ variable_instance_set(self, "__clean__", true); } else { return; } }

// feather disable GM2047
// feather disable GM2017
// feather disable GM1038

if (DEBUG_STRESS_TEST) { global.game_iteration = 0; time_source_start(time_source_create(time_source_game, DEBUG_STRESS_TEST_FRAMES_TILL_REBOOT, 
time_source_units_frames, function() { game_restart(); print("Iteration: ", global.game_iteration++); }, [], -1)); }

global.game_version = string(VERSION_MAJOR)+"."+string(VERSION_MINOR)+"."+string(VERSION_PATCH);
if (DEBUG) { global.game_version += "-DEBUG"; } else { randomize(); }

#macro LOG __empty_func
#macro Debug:LOG __log_func

#macro LOG_T __empty_func
#macro Debug:LOG_T __log_terminal_func

#macro print __empty_func
#macro Debug:print __print

#macro printf __empty_func
#macro Debug:printf show_debug_message

function __empty_func(_dump) {
	return; for (var _i = 0; _i < argument_count; ++_i) { var a = argument[_i]; }
}

function enocde_image_blend(_a, _b, _c) { gml_pragma("forceinline"); image_blend = make_color_rgb(_a, _b, _c); }

function __log_func() {
    gml_pragma("forceinline");
    var _str = "";
    for (var _i = 0; _i < argument_count; ++_i)
    {
        _str += " " + string(argument[_i]);
    }
    show_debug_message("[{0} {1}]: {2}", object_get_name(object_index), id, _str);
}

function __log_terminal_func() {
    gml_pragma("forceinline");
    var _str = "";
    for (var _i = 0; _i < argument_count; ++_i)
    {
        _str += " " + string(argument[_i]);
    }
    Terminal.term_print(new Terminal.prompt(
        Terminal.c_success, string("[{0} {1}]:{2}", object_get_name(object_index), id, _str)
    ));
}

#macro IS_SINGLETON { if (!assert_singleton()) return; }
function assert_singleton() 
{
	if (instance_number(object_index) > 1) 
    {
		instance_destroy();
		return false;
	}
	return true;
}

function seconds(_amount) {
    return game_get_speed(gamespeed_fps) * _amount;
}

function milliseconds(_amount) {
    return game_get_speed(gamespeed_fps) * (_amount / 1000);
}

function __print()
{
	gml_pragma("forceinline");
    var _str = "";
    for (var _i = 0; _i < argument_count; ++_i)
    {
        _str += " " + string(argument[_i]);
    }
    show_debug_message(_str);
    return _str;
}

function instance_create(_instance, _x, _y, _where)
{
	gml_pragma("forceinline");
    var _ins = -1;
    if (!is_undefined(_where))
    {
        if (is_string(argument[3])) 
        	_ins = instance_create_layer(_x, _y, argument[3], _instance);
        else if (is_numeric(argument[3]))
        	_ins = instance_create_depth(_x, _y, argument[3], _instance);
        else throw "Invalid depth or layer name";
    }
    else _ins = instance_create_layer(_x, _y, "Instances", _instance);
    return _ins;
}

function approach(_a, _b, _c)
{
	gml_pragma("forceinline");
    if (_a < _b) return min(_a + _c, _b); 
    else return max(_a - _c, _b);
}

function smooth_approach(_current, _target, speed) {
	gml_pragma("forceinline");
	var _diff = _target-_current;
	if ( abs(_diff) < 0.0005 ) return _target;
	else return _current+sign(_diff)*abs(_diff)*speed;
}

function plusminus(_value) {
    gml_pragma("forceinline");
    return random_range(-_value, _value);
}

function iplusminus(_value) {
    gml_pragma("forceinline");
    return irandom_range(-_value, _value);
}

function ds_list_to_array(_ds_list) {
    var _array = [];
    var _list_size = ds_list_size(_ds_list);
    for (var _i = 0; _i < _list_size; ++_i)
    {
        array_push(_array, _ds_list[|_i]);  
    }
    return _array;
}
