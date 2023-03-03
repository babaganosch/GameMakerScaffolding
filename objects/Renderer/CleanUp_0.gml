PERSISTENT_CLEANUP
unsubscribe();
delete receiver;

// Cleanup surfaces
for (var i = 0; i < array_length(surface_buffer); ++i)
{
    surface_free(surface_buffer[i]);
}
surface_free(application_surface);

CAMERA.destroy();
delete CAMERA;