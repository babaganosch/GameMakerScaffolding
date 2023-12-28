
// Perform the GC EVENTS for this frame
for (var _i = 0; _i < array_length(frame_events[global.frame_index]); ++_i) {
    var _events_this_frame = frame_events[global.frame_index];
    event_user(_events_this_frame[_i]);
}
global.frame_index = ++global.frame_index % array_length(frame_events);
