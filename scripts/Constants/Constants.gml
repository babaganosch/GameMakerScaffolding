#macro VERSION_MAJOR 0
#macro VERSION_MINOR 0
#macro VERSION_PATCH 1

/// Debug | Release
#macro DEBUG false
#macro DEBUG_STRESS_TEST false
#macro Debug:DEBUG true
#macro StressTest:DEBUG true
#macro StressTest:DEBUG_STRESS_TEST true
#macro StressTest:DEBUG_STRESS_TEST_FRAMES_TILL_REBOOT 5

/// World
#macro CELL_W     8
#macro CELL_H     8

/// Time
#macro dt         global._dt
#macro dt_ms      global._dt_ms
#macro real_dt    global._real_dt

/// Alarms
#macro game_alarms global.__game_alarms
#macro sys_alarms  global.__system_alarms

/// Vector indexing
#macro X 0
#macro Y 1
#macro X1 0
#macro Y1 1
#macro X2 2
#macro Y2 3

/// Notification messages
enum MESSAGES {
	MESSAGE_TEST,				// 0
    
    FULLSCREEN_TOGGLED,         // 1
    GUI_SIZE_CHANGED,           // 2
    
    GAME_PAUSE,
    GAME_UNPAUSE
}

if (__NOTIFICATIONS_DEBUG) global.MESSAGES_DEBUG_LOOKUP = [
    "MESSAGE_TEST",
    
    "FULLSCREEN_TOGGLED",
    "GUI_SIZE_CHANGED",
    
    "GAME_PAUSE",
    "GAME_UNPAUSE"
];
