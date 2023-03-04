/// @desc OBJECT_SORTING

/* Sort objects by Y-value
 * Currently sorts primarly on Y-value, and secondarily
 * on object ID. This is very unoptimal and should
 * probably be looked over if performance is an issue.
 */
var active_game_objects = ACTIVE_GAME_OBJECTS;
array_sort(active_game_objects, function(e1, e2) {
    var order = e1.y - e2.y;
    if (order == 0) order = e1.sorting_identifier - e2.sorting_identifier;
    return order;
});
ACTIVE_GAME_OBJECTS = active_game_objects;