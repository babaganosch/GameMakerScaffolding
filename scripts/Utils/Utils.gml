#macro PERSISTENT_CLEANUP { persistent = false; if(!variable_instance_get(self, "__clean__")) \
{ variable_instance_set(self, "__clean__", true); } else { return; } }

if (DEBUG_STRESS_TEST) { global.game_iteration = 0; time_source_start(time_source_create(time_source_game, DEBUG_STRESS_TEST_FRAMES_TILL_REBOOT, 
time_source_units_frames, function() { game_restart(); print("Iteration: ", global.game_iteration++); }, [], -1)); }

global.game_version = string(VERSION_MAJOR)+"."+string(VERSION_MINOR)+"."+string(VERSION_PATCH);
if (DEBUG) { global.game_version += "-DEBUG"; } else { randomize(); }

#macro OBJECT_Z_SORT ((room_height - bbox_bottom) / room_height * 255)

#macro LOG __empty_func
#macro Debug:LOG __log_func

#macro LOG_T __empty_func
#macro Debug:LOG_T __log_terminal_func

#macro print __empty_func
#macro Debug:print __print

#macro printf __empty_func
#macro Debug:printf show_debug_message

function enocde_image_blend(a, b, c) { gml_pragma("forceinline"); image_blend = make_color_rgb(a, b, c); }

function __empty_func() { gml_pragma("forceinline"); return; __empty_func(argument[0]); }

function __log_func() {
    gml_pragma("forceinline");
    var str = "";
    for (var i = 0; i < argument_count; ++i)
    {
        str += " " + string(argument[i]);
    }
    show_debug_message("[{0} {1}]: {2}", object_get_name(object_index), id, str);
}

function __log_terminal_func() {
    gml_pragma("forceinline");
    var str = "";
    for (var i = 0; i < argument_count; ++i)
    {
        str += " " + string(argument[i]);
    }
    Terminal.Print(new Terminal.Prompt(
        Terminal.c_success, string("[{0} {1}]:{2}", object_get_name(object_index), id, str)
    ));
}

#macro IS_SINGLETON { if (!AssertSingleton()) return; }
function AssertSingleton() 
{
	if (instance_number(object_index) > 1) 
    {
		instance_destroy();
		return false;
	}
	return true;
}

function seconds(amount) {
    return game_get_speed(gamespeed_fps) * amount;
}

function milliseconds(amount) {
    return game_get_speed(gamespeed_fps) * (amount / 1000);
}

function __print()
{
	gml_pragma("forceinline");
    var str = "";
    for (var i = 0; i < argument_count; ++i)
    {
        str += " " + string(argument[i]);
    }
    show_debug_message(str);
    return str;
}

function instance_create(instance, x, y, where)
{
	gml_pragma("forceinline");
    var ins = -1;
    if (!is_undefined(where))
    {
        if (is_string(argument[3])) 
        	ins = instance_create_layer(x, y, argument[3], instance);
        else if (is_numeric(argument[3]))
        	ins = instance_create_depth(x, y, argument[3], instance);
        else throw "Invalid depth or layer name";
    }
    else ins = instance_create_layer(x, y, "Instances", instance);
    return ins;
}

function approach(a, b, c)
{
	gml_pragma("forceinline");
    if (a < b) return min(a + c, b); 
    else return max(a - c, b);
}

function smooth_approach(current, target, speed) {
	gml_pragma("forceinline");
	var diff = target-current;
	if ( abs(diff) < 0.0005 ) return target;
	else return current+sign(diff)*abs(diff)*speed;
}

function plusminus(value) {
    gml_pragma("forceinline");
    return random_range(-value, value);
}

function iplusminus(value) {
    gml_pragma("forceinline");
    return irandom_range(-value, value);
}

function ds_list_to_array(ds_list) {
    var _array = [];
    var _list_size = ds_list_size(ds_list);
    for (var _i = 0; _i < _list_size; ++_i)
    {
        array_push(_array, ds_list[|_i]);  
    }
    return _array;
}

if (false)
{   // REMOVE WARNINGS
    LOG();
    __log_function();
    seconds(0);
    milliseconds(0);
    print();
    __print();
    printf();
    plusminus(0);
    iplusminus(0);
    ds_list_to_array(0);
}