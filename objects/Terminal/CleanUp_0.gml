PERSISTENT_CLEANUP
unsubscribe();
delete receiver;

font_delete(terminal_font);

if (surface_exists(surface)) surface_free(surface);