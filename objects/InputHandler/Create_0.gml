IS_SINGLETON
sprite_index = -1;

receiver = new Receiver(["system"]);
active = true;

receiver.on(MESSAGES.GAME_PAUSE, function() {
    active = false;  
});

receiver.on(MESSAGES.GAME_UNPAUSE, function() {
    active = true;
});