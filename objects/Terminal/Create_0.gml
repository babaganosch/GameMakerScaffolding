IS_SINGLETON
sprite_index = -1;
receiver = new Receiver(["system"]);
active = false;
alpha = 0;

input_string = "";
input_index = 0;
input_marker_flag = false;
input_xanchor = 14;
prompt_character = "$";
c_special = 0xE89120;
c_time = 0xBFD9F5;
c_error = 0x1C34E8;

var font_characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" +
                      "abcdefghijklmnopqrstuvwxyz" +
                      "1234567890" +
                      "?!/\\-_+=*.,:;~()[]{}^⌄<>" +
                      "'\"@%&|#$";
terminal_font = font_add_sprite_ext(spr_font_terminal, font_characters, true, 1);

history = [];
prompt_history = [];
history_max = 50;
history_index = -1;

sys_alarms.add(milliseconds(500), function() {
    input_marker_flag = !input_marker_flag;
    if (active) RenderTerminalSurface();
}, true);

bot_y = display_get_gui_height() div 3;
draw_set_font(terminal_font);
letter_h = string_height("A");
draw_set_font(-1);
surface = surface_create(display_get_gui_width(), bot_y);
pane_anchor_y = -bot_y;
open_close_speed = bot_y div 10;

function Prompt(color, text_string) constructor
{
    _timestamp = date_current_datetime();
    _timestamp_string = string("[{0}:{1}] ", 
        string_replace(string_format(date_get_hour(_timestamp), 2, 0), " ", "0"), 
        string_replace(string_format(date_get_minute(_timestamp), 2, 0), " ", "0"));
    _color = color;
    _string = text_string;
}

function Print(prompt)
{
    array_insert(history, 0, prompt);
    if (array_length(history) > history_max) 
        array_delete(history, history_max, 1);
}

function Execute(prompt)
{
    Print(prompt);
    var list = string_split(prompt._string, " ", true, 999);
    if (array_length(list) > 0) {
        var command = variable_struct_get(commands, string_lower(list[0]));
        if (!is_undefined(command))
        {
            try {
                command(list);
            } catch (e) { 
                Print(new Prompt(c_error, e.message ));
            }
        }
    }
    if (string_trim(prompt._string) != "")
    {
        array_insert(prompt_history, 0, prompt);
        if (array_length(prompt_history) > history_max) 
            array_delete(prompt_history, history_max, 1);
    }
}

function RenderTerminalHistoryPrompt(yy, cmnd)
{
    var _timestamp_len = string_width(cmnd._timestamp_string);
    var xx = 5;
    draw_set_color(c_time);
    draw_text(xx, yy, cmnd._timestamp_string);
    xx += _timestamp_len;
    draw_set_color(cmnd._color);
    draw_text(xx, yy, cmnd._string);
    draw_set_color(c_white);
}

function RenderTerminalSurface()
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
        var substr = "";
        for (var i = 0; i < input_index; ++i) {
            substr += string_char_at(input_string, i+1);
        }
        draw_text(input_xanchor + string_width(substr) - 1, bot_y, "|");
    }
    
    for (var i = 0; i < array_length(history); ++i)
    {
        var yy = (i+1) * letter_h;
        if ( yy > bot_y) break;
        RenderTerminalHistoryPrompt(bot_y - yy, history[i]);
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
    RenderTerminalSurface();
});

RenderTerminalSurface();

commands = {
    "echo": function(args) {
        var str = "> ";
        for (var i = 1; i < array_length(args); ++i)
        {
            str += args[i] + " ";
        }
        Terminal.Print(new Terminal.Prompt(c_teal, str));
    },
    "clear": function() {
        Terminal.history = [];
    },
    "fullscreen": function(args) {
        var flag = !window_get_fullscreen();
        if (array_length(args) > 1)
        {
            switch (string_lower(args[1])) {
                case ("1"): 
                case ("true"): 
                case ("on"): {
                    flag = true;
                } break;
                case ("0"):
                case ("false"):
                case ("off"): {
                    flag = false;
                } break;
            }
        }
        window_set_fullscreen(flag);
        Terminal.Print(new Terminal.Prompt(c_lime, string("Fullscreen {0}", flag)));
    },
    "restart": function() {
        game_restart();
    },
    "exit": function() {
        game_end();
    },
    "spawn": function(args) {
        var xx = mouse_x, yy = mouse_y;
        instance_create(asset_get_index(args[1]), xx, yy, 0); 
        var str = string("{0} spawned at {1} {2}", args[1], xx, yy);
        Terminal.Print(new Terminal.Prompt(0x6DB38B, str));
    },
    "pause": function() {
        broadcast(MESSAGES.GAME_PAUSE);
        Terminal.Print(new Terminal.Prompt(c_yellow, "Game paused"));
    },
    "unpause": function() {
        broadcast(MESSAGES.GAME_UNPAUSE);
        Terminal.Print(new Terminal.Prompt(c_yellow, "Game unpaused"));
    }
}
