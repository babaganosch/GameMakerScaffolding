// Inherit the parent event
event_inherited();
sprite_index = -1;

light = new LightSource( LIGHTS.debug, {
    x: 8,
    y: 8,
    color: make_color_rgb(irandom(255), irandom(255), irandom(255)),
    alpha: 0.9,
    flicker: {
        amplitude: 0.1,
		speed: random_range(0.08, 0.12)
    }
});
