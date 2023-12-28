#macro GAME_VERSION  global.game_version
#macro VERSION_MAJOR 0
#macro VERSION_MINOR 0
#macro VERSION_PATCH 1

/// Debug | Release (handled by build config)
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
#macro dt          global.__dt
#macro dt_ms       global.__dt_ms
#macro real_dt     global.__real_dt

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
	WINDOW_SIZE_CHANGED,		// 2
    GUI_SIZE_CHANGED,           // 3
    
    GAME_PAUSE,                 // 4
    GAME_UNPAUSE                // 5
}