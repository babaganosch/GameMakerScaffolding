
// Perform the GC EVENTS for this frame
for (var i = 0; i < array_length(frame_events[global.frame_index]); ++i) {
    var events_this_frame = frame_events[global.frame_index];
    event_user(events_this_frame[i]);
}
global.frame_index = ++global.frame_index % array_length(frame_events);
