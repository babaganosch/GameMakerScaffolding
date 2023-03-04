if (active) {
    pane_anchor_y = clamp(pane_anchor_y + real_dt * open_close_speed, -bot_y, 0);
    alpha = lerp(alpha, 1, real_dt * 0.1);
} else {
    pane_anchor_y = clamp(pane_anchor_y - real_dt * open_close_speed, -bot_y, 0);
    alpha = lerp(alpha, 0, real_dt * 0.1);
}
