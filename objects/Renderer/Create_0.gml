IS_SINGLETON
sprite_index = -1;
receiver = new Receiver(["system"]);

application_surface_draw_enable(false);
gpu_set_texfilter(false);
gpu_set_texrepeat(false);

window_set_size( global.game_size[X] * global.zoom, global.game_size[Y] * global.zoom );
display_set_gui_size( global.game_size[X], global.game_size[Y] );
gui_size = [ global.game_size[X], global.game_size[Y] ];
window_size = [ window_get_width(), window_get_height() ];
surface_resize( application_surface, global.game_size[X] + 1, global.game_size[Y] + 1 );
fullscreen_flag = window_get_fullscreen();

#macro PREVIOUS_FRAME 2
surface_buffer = {
	lo_res: array_create(3, -1),
	hi_res: -1
};
surface_flag = 0;

/// CAMERA
#macro CAMERA global.camera
CAMERA = new Camera(0, 0, global.game_size[X], global.game_size[Y]);
CAMERA.activate();
view_wport[0] = window_size[X] + global.zoom;
view_hport[0] = window_size[Y] + global.zoom;

/// SHADERS
tv_screen_shader = new ShaderProgram(sh_tv_screen);
tv_screen_shader.add_uniform("u_resolution", U_TYPE.F_VEC);
tv_screen_shader.add_uniform("u_offset", U_TYPE.F_VEC);

#region RENDER_FUNCTIONS

function render_to_target(_this, _surface, _setup)
{
    surface_set_target(_surface);
        method(_this, _setup)();
    surface_reset_target();
}

/* Post FX in low-res resolution */
function post_fx_pass(_shd, _setup)
{
    if (_shd != -1) _shd.set();
    _setup();
    render_to_target(self, surface_buffer.lo_res[surface_flag], function() {
        draw_surface(surface_buffer.lo_res[!surface_flag], 0, 0);
    });
    if (_shd != -1) _shd.reset();
    surface_flag = !surface_flag;
}

/* Final render call to screen */
function render_to_hires(_this, _correction_x, _correction_y, _scale, _setup)
{
	surface_set_target(surface_buffer.hi_res);
        method(_this, _setup)();
		if (!view_enabled) { _correction_x = 0; _correction_y = 0; }
		draw_surface_ext(surface_buffer.lo_res[!surface_flag], -frac(_correction_x) * _scale, 
            -frac(_correction_y) * _scale, _scale, _scale, 0, c_white, 1.0);
    surface_reset_target();
}

/// @param {Id.Instance} _this
/// @param {any} _shd
/// @param {Function} _setup
function render_to_screen(_this, _shd, _setup)
{
    if (_shd != -1) _shd.set();
        method(_this, _setup)();
    if (_shd != -1) _shd.reset();
}

#endregion
