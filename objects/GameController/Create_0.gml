IS_SINGLETON
room_set_persistent(room, !DEBUG_STRESS_TEST);
sprite_index = -1;
receiver  = new Receiver(["system"]);

shader_zsort = new ShaderProgram(sh_zsort);

/* Make sure this enum corresponds to the User Event numbers (16 events max) */
enum GC_EVENT {
    OBJECT_CULLING = 0,
    LITE_OBJECT_CULLING = 1
}

/** Game Controller Events
 * Workload is balanced over 20 frames. Fill the array with
 * GC Events to state which frame an event should be performed.
 * Multiple events can occur on a frame. Try to keep some kind of
 * symmetry in the frame_events, for a balanced frame rate.
 *
 * Workload percentage based on about 6000 instances (~1000 objects active)
 * MacBook Pro 13" 2018 Intel
 *
 * Culling: 6-10 ms, Avg ~7ms
 */
global.frame_index  = 0;
frame_events = [];
frame_events[0 ] = [ GC_EVENT.OBJECT_CULLING ];
frame_events[1 ] = [ ];
frame_events[2 ] = [ GC_EVENT.LITE_OBJECT_CULLING ];
frame_events[3 ] = [ ];
frame_events[4 ] = [ GC_EVENT.OBJECT_CULLING ];
frame_events[5 ] = [ ];
frame_events[6 ] = [ GC_EVENT.LITE_OBJECT_CULLING ];
frame_events[7 ] = [ ];
frame_events[8 ] = [ GC_EVENT.OBJECT_CULLING ];
frame_events[9 ] = [ ];
frame_events[10] = [ GC_EVENT.LITE_OBJECT_CULLING ];
frame_events[11] = [ ];
frame_events[12] = [ GC_EVENT.OBJECT_CULLING ];
frame_events[13] = [ ];
frame_events[14] = [ GC_EVENT.LITE_OBJECT_CULLING ];
frame_events[15] = [ ];
frame_events[16] = [ GC_EVENT.OBJECT_CULLING ];
frame_events[17] = [ ];
frame_events[18] = [ GC_EVENT.LITE_OBJECT_CULLING ];
frame_events[19] = [ ];
