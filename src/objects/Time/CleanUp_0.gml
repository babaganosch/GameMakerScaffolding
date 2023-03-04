PERSISTENT_CLEANUP
unsubscribe();
delete receiver;

game_alarms.cleanup();
sys_alarms.cleanup();

profiler.destroy();
delete profiler;