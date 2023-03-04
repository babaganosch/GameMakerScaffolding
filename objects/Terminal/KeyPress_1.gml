if (keyboard_lastkey == open_close_button) {
    active = !active;
    if (!active) broadcast(MESSAGES.GAME_UNPAUSE);
    else broadcast(MESSAGES.GAME_PAUSE);
    keyboard_lastchar = "";
}

if (!active) return;
switch (keyboard_lastkey)
{
    case (vk_backspace): {
        input_string = string_delete(input_string, input_index, 1);
        input_index = clamp(input_index - 1, 0, string_length(input_string)); 
    } break;
    case (vk_enter): {
        Execute(new Prompt(c_white, input_string));
        input_string = "";
        input_index = 0;
        history_index = -1;
    } break;
    case (vk_up): {
        history_index = clamp(history_index + 1, -1, array_length(prompt_history) - 1);
        if (history_index == -1 || history_index > array_length(prompt_history)) break; 
        input_string = prompt_history[history_index]._string;
    } break;
    case (vk_down): {
        history_index = clamp(history_index - 1, -1, array_length(prompt_history) - 1);
        if (history_index == -1 || history_index > array_length(prompt_history)) {
            input_string = ""; break; 
        }
        input_string = prompt_history[history_index]._string;
    } break;
    case (vk_left): {
        input_index = clamp(input_index - 1, 0, string_length(input_string));   
    } break;
    case (vk_right): {
        input_index = clamp(input_index + 1, 0, string_length(input_string));    
    } break;
    default: {
        if (keyboard_lastchar != "") {
            input_string = string_insert(keyboard_lastchar, input_string, input_index + 1);
            input_index++;
        }
    } break;
}

keyboard_lastchar = "";
keyboard_lastkey  = 0;

RenderTerminalSurface();













