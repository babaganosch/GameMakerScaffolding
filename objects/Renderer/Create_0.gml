IS_SINGLETON
sprite_index = -1;
receiver = new Receiver(["system"]);

application_surface_draw_enable(false);
gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);

gpu_set_texfilter(false);
gpu_set_texrepeat(false);

window_set_size( global.screen_width, global.screen_height );
display_set_gui_size( global.game_width, global.game_height );
gui_size = [ global.game_width, global.game_height ];
surface_resize( application_surface, global.game_width + 1, global.game_height + 1 );

#macro previous_frame 2
surface_buffer = array_create(3);
surface_buffer[0] = surface_create( global.game_width + 1, global.game_height + 1 );
surface_buffer[1] = surface_create( global.game_width + 1, global.game_height + 1 );
surface_buffer[previous_frame] = surface_create( global.game_width + 1, global.game_height + 1 );
surface_flag = 0;

fullscreen_flag = window_get_fullscreen();

/// CAMERA
#macro CAMERA global.camera
CAMERA = new Camera(0, 0, global.game_width, global.game_height);
CAMERA.activate();

/// SHADERS
debug_shader = new ShaderProgram(DEBUG_SHADER);
chromatic_shader = new ShaderProgram(shd_chromatic_abr);

#region RENDER_FUNCTIONS

function render_to_target(this, surface, callback)
{
    surface_set_target(surface);
        method(this, callback)();
    surface_reset_target();
}

/* Post FX in low-res resolution */
function post_fx_pass(shd, func)
{
    if (shd != -1) shd.set();
    func();
    render_to_target(self, surface_buffer[surface_flag], function() {
        draw_surface(surface_buffer[!surface_flag], 0, 0);
    });
    if (shd != -1) shd.reset();
    surface_flag = !surface_flag;
}

/* Final render call to screen */
function render_to_screen(shd, correction_x, correction_y, scale, func)
{
    if (shd != -1) shd.set();
        func();
        gpu_set_blendenable(true);
        if (!view_enabled) { correction_x = 0; correction_y = 0; }
        draw_surface_ext(surface_buffer[!surface_flag], -frac(correction_x) * scale, 
            -frac(correction_y) * scale, scale, scale, 0, c_white, 1.0);
        gpu_set_blendenable(true);
    if (shd != -1) shd.reset();
}

#endregion
