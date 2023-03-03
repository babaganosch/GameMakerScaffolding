if (alpha < 0.1) return;
if (!surface_exists(surface)) {
    RenderTerminalSurface();
}
draw_set_alpha(alpha);
draw_surface(surface, 0, pane_anchor_y);
draw_set_alpha(1);
