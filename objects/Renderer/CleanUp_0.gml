PERSISTENT_CLEANUP
unsubscribe();
delete receiver;

// Cleanup surfaces
for (var _i = 0; _i < array_length(surface_buffer.lo_res); ++_i)
{
    surface_free(surface_buffer.lo_res[_i]);
}
surface_free(surface_buffer.hi_res);
surface_free(application_surface);

CAMERA.destroy();
delete CAMERA;