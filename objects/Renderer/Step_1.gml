var _old_flag = fullscreen_flag;
var _old_gui_size = gui_size;
fullscreen_flag = window_get_fullscreen();
gui_size = [ display_get_gui_width(), display_get_gui_height() ];

// Notify others if render settings has changed
if (_old_flag != fullscreen_flag)
{
    broadcast_channel(MESSAGES.FULLSCREEN_TOGGLED, "system", fullscreen_flag);
}

if (_old_gui_size[X] != gui_size[X] || _old_gui_size[Y] != gui_size[Y])
{
    broadcast_channel(MESSAGES.GUI_SIZE_CHANGED, "system", gui_size);
}