#region setup
var _game_width  = global.game_size[X];
var _game_height = global.game_size[Y];
var _window_width = window_get_width();
var _window_height = window_get_height();
var _scale = global.zoom;

for (var _i = 0; _i < array_length(surface_buffer.lo_res); ++_i)
{
    if (!surface_exists(surface_buffer.lo_res[_i]))
    {
        surface_free(surface_buffer.lo_res[_i]);
        surface_buffer.lo_res[_i] = surface_create( _game_width + 1, _game_height + 1 );
    }
    else
    {
        if (surface_get_width(surface_buffer.lo_res[_i])  != _game_width  + 1 ||
            surface_get_height(surface_buffer.lo_res[_i]) != _game_height + 1)
        {
            surface_resize(surface_buffer.lo_res[_i], _game_width + 1, _game_height + 1);        
        }
    }
}
if (!surface_exists(surface_buffer.hi_res))
{
    surface_free(surface_buffer.hi_res);
    surface_buffer.hi_res = surface_create( _window_width, _window_height );
}
else
{
    if (surface_get_width(surface_buffer.hi_res)  != _window_width ||
        surface_get_height(surface_buffer.hi_res) != _window_height)
    {
        surface_resize(surface_buffer.hi_res, _window_width, _window_height);        
    }
}
#endregion

#region rendering


// Render game to frame buffer
render_to_target(self, surface_buffer.lo_res[!surface_flag], function() {
    draw_surface(application_surface, 0, 0);
});

//// Post FX (low-res)
// Post FX passes are drawn ping-pong between the two
// frame buffers. Just run the post_fx_pass with 
// desired shader program, and setup necessary stuff in
// the callback function

/*
post_fx_pass(-1, function() {
    
});

post_fx_pass(-1, function() {
    
});

post_fx_pass(-1, function() {
    
});*/

// Final rendering to screen (hi-res)
render_to_hires(self, CAMERA.pos[0], CAMERA.pos[1], _scale, function() {
	// Do nothing..
});

render_to_screen(self, -1, function() {
	draw_surface(surface_buffer.hi_res, 0, 0);
});

// Save old frame
surface_copy(surface_buffer.lo_res[PREVIOUS_FRAME], 0, 0, surface_buffer.lo_res[!surface_flag]);

#endregion
