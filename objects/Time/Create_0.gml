IS_SINGLETON
sprite_index = -1;
receiver = new Receiver(["system"]);

dt      = 0;
dt_ms   = 0;
real_dt = 0;

delta = 0;
delta_in_ms = 0;
gamespeed_target = 60;
gamespeed = gamespeed_target;

profiler = new Profiler({
    frames: new ProfilingPoint(120),
    cpu: new ProfilingPoint(120)
});

receiver.on(MESSAGES.GAME_PAUSE, function() {
    gamespeed_target = 0;
});

receiver.on(MESSAGES.GAME_UNPAUSE, function() {
    gamespeed_target = 60;
});
