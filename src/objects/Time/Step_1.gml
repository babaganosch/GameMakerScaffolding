// Correct delta between frames
delta = min(delta_time / (1000000 / gamespeed), 3); // Delta in frames (1 +/- diff)
delta_in_ms = delta_time / 1000;                    // Delta in ms     (16ms +/- diff)

// Delta in frames, not modified by pause
real_dt = min(delta_time / (1000000 / game_get_speed(gamespeed_fps)), 3);

// Slowed down with gamespeed
gamespeed  = lerp(gamespeed, gamespeed_target, 0.2);

dt = delta;
dt_ms = delta_in_ms;

profiler.points.frames.add_measure( fps );
profiler.points.cpu.add_measure( fps_real );
profiler.update();