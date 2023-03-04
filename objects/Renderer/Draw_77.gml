#region setup
var game_width  = global.game_width;
var game_height = global.game_height;
var scale = window_get_width() / CAMERA.size[0];

for (var i = 0; i < array_length(surface_buffer); ++i)
{
    if (!surface_exists(surface_buffer[i]))
    {
        surface_free(surface_buffer[i]);
        surface_buffer[i] = surface_create( game_width + 1, game_height + 1 );
    }
    else
    {
        if (surface_get_width(surface_buffer[i])  != game_width  + 1 ||
            surface_get_height(surface_buffer[i]) != game_height + 1)
        {
            surface_resize(surface_buffer[i], game_width + 1, game_height + 1);        
        }
    }
}
#endregion

#region rendering


// Render game to frame buffer
render_to_target(self, surface_buffer[!surface_flag], function() {
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
render_to_screen(-1, CAMERA.pos[0], CAMERA.pos[1], scale, function() {
    
});

// Save old frame
surface_copy(surface_buffer[previous_frame], 0, 0, surface_buffer[!surface_flag]);

#endregion
