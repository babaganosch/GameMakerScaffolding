var _old_flag = fullscreen_flag;
var _old_gui_size = gui_size;
var _old_window_size = window_size;
fullscreen_flag = window_get_fullscreen();
gui_size = [ display_get_gui_width(), display_get_gui_height() ];
window_size = [ window_get_width(), window_get_height() ];

// Notify others if render settings has changed
if (_old_flag != fullscreen_flag)
{
    broadcast_channel(MESSAGES.FULLSCREEN_TOGGLED, "system", fullscreen_flag);
}

if (_old_window_size[X] != window_size[X] || _old_window_size[Y] != window_size[Y])
{
	var _game_width  = window_get_width() div global.zoom;
	var _game_height = window_get_height() div global.zoom;
	global.game_size = [ _game_width, _game_height ];
	CAMERA.resize(_game_width, _game_height);
	view_wport[0] = window_size[X] + global.zoom;
	view_hport[0] = window_size[Y] + global.zoom;
	surface_resize( application_surface, _game_width + 1, _game_height + 1 );
	display_set_gui_size( global.game_size[X], global.game_size[Y] );
	gui_size = [ global.game_size[X], global.game_size[Y] ];
	
    broadcast_channel(MESSAGES.WINDOW_SIZE_CHANGED, "system", window_size);
}

if (_old_gui_size[X] != gui_size[X] || _old_gui_size[Y] != gui_size[Y])
{
    broadcast_channel(MESSAGES.GUI_SIZE_CHANGED, "system", gui_size);
}
