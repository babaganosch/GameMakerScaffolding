IS_SINGLETON
sprite_index = -1;
receiver = new Receiver(["system"]);
active = false;
alpha = 0;

// §: 10 on mac, 220 on windows
if (os_type == os_macosx) open_close_button = 10;
else open_close_button = 220;

input_string = "";
input_index = 0;
input_marker_flag = false;
input_xanchor = 14;
prompt_character = "$";
c_special = 0xE89120;
c_time = 0xBFD9F5;
c_error = 0x1C34E8;
c_success = 0x6DB38B;

var _font_characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" +
                      "abcdefghijklmnopqrstuvwxyz" +
                      "1234567890" +
                      "?!/\\-_+=*.,:;~()[]{}^⌄<>" +
                      "'\"@%&|#$";
terminal_font = font_add_sprite_ext(spr_font_terminal, _font_characters, true, 1);

history = [];
prompt_history = [];
history_max = 50;
history_index = -1;

sys_alarms.add(milliseconds(500), function() {
    input_marker_flag = !input_marker_flag;
    if (active) render_terminal_surface();
}, true);

bot_y = display_get_gui_height() div 3;
draw_set_font(terminal_font);
letter_h = string_height("A");
draw_set_font(-1);
surface = surface_create(display_get_gui_width(), bot_y);
pane_anchor_y = -bot_y;
open_close_speed = bot_y div 10;

function prompt(_color, _text_string) constructor
{
    timestamp = date_current_datetime();
    timestamp_string = string("[{0}:{1}] ", 
        string_replace(string_format(date_get_hour(timestamp), 2, 0), " ", "0"), 
        string_replace(string_format(date_get_minute(timestamp), 2, 0), " ", "0"));
    color = _color;
    str = _text_string;
}

function term_print(_prompt)
{
    array_insert(history, 0, _prompt);
    if (array_length(history) > history_max) 
        array_delete(history, history_max, 1);
}

function execute(_prompt)
{
    term_print(_prompt);
    var _list = string_split(_prompt.str, " ", true, 999);
    if (array_length(_list) > 0) {
        var _command = variable_struct_get(commands, string_lower(_list[0]));
        if (!is_undefined(_command))
        {
            try {
                _command(_list);
            } catch (_e) { 
                term_print(new prompt(c_error, _e.message ));
            }
        }
    }
    if (string_trim(_prompt.str) != "")
    {
        array_insert(prompt_history, 0, _prompt);
        if (array_length(prompt_history) > history_max) 
            array_delete(prompt_history, history_max, 1);
    }
}

function render_terminal_history_prompt(_yy, _cmnd)
{
    var _timestamp_len = string_width(_cmnd.timestamp_string);
    var _xx = 5;
    draw_set_color(c_time);
    draw_text(_xx, _yy, _cmnd.timestamp_string);
    _xx += _timestamp_len;
    draw_set_color(_cmnd.color);
    draw_text(_xx, _yy, _cmnd.str);
    draw_set_color(c_white);
}

function render_terminal_surface()
{
    if (!surface_exists(surface)) surface = surface_create(display_get_gui_width(), bot_y);
    surface_set_target(surface);
    draw_clear_alpha(c_black, 0);
    draw_set_font(terminal_font);

    draw_set_alpha(0.75);
    draw_set_color(c_black);
    draw_rectangle(0, 0, display_get_gui_width(), bot_y, false);

    draw_set_alpha(0.1);
    draw_rectangle(0, bot_y - letter_h, display_get_gui_width(), bot_y, false);

    draw_set_alpha(1);
    draw_set_color(c_special);
    draw_set_valign(fa_bottom);

    draw_text(5, bot_y, prompt_character);
    
    draw_set_color(c_white);
    draw_text(input_xanchor, bot_y, input_string);
    
    if (input_marker_flag) 
    {
        var _substr = "";
        for (var _i = 0; _i < input_index; ++_i) {
            _substr += string_char_at(input_string, _i+1);
        }
        draw_text(input_xanchor + string_width(_substr) - 1, bot_y, "|");
    }
    
    for (var _i = 0; _i < array_length(history); ++_i)
    {
        var _yy = (_i+1) * letter_h;
        if ( _yy > bot_y) break;
        render_terminal_history_prompt(bot_y - _yy, history[_i]);
    }

    /// RESET
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_set_font(-1);
    draw_set_alpha(1);


    surface_reset_target();
}

receiver.on(MESSAGES.GUI_SIZE_CHANGED, function() {
    bot_y = display_get_gui_height() div 3;
    if (surface_exists(surface)) surface_free(surface);
    surface = surface_create(display_get_gui_width(), bot_y);
    render_terminal_surface();
});

render_terminal_surface();

commands = {
    "echo": function(_args) {
        var _str = "> ";
        for (var _i = 1; _i < array_length(_args); ++_i)
        {
            _str += _args[_i] + " ";
        }
        Terminal.term_print(new Terminal.prompt(c_teal, _str));
    },
    "clear": function() {
        Terminal.history = [];
    },
    "fullscreen": function(_args) {
        var _flag = !window_get_fullscreen();
        if (array_length(_args) > 1)
        {
            switch (string_lower(_args[1])) {
                case ("1"): 
                case ("true"): 
                case ("on"): {
                    _flag = true;
                } break;
                case ("0"):
                case ("false"):
                case ("off"): {
                    _flag = false;
                } break;
            }
        }
        window_set_fullscreen(_flag);
        Terminal.term_print(new Terminal.prompt(c_lime, string("Fullscreen {0}", _flag)));
    },
    "restart": function() {
        game_restart();
    },
    "exit": function() {
        game_end();
    },
    "spawn": function(_args) {
        var _xx = mouse_x, _yy = mouse_y;
        instance_create(asset_get_index(_args[1]), _xx, _yy, 0); 
        var _str = string("{0} spawned at {1} {2}", _args[1], _xx, _yy);
        Terminal.term_print(new Terminal.prompt(Terminal.c_success, _str));
    },
    "pause": function() {
        broadcast(MESSAGES.GAME_PAUSE);
        Terminal.term_print(new Terminal.prompt(c_yellow, "Game paused"));
    },
    "unpause": function() {
        broadcast(MESSAGES.GAME_UNPAUSE);
        Terminal.term_print(new Terminal.prompt(c_yellow, "Game unpaused"));
    }
}
