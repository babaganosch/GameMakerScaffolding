visible = false;
active = true;
sorting_identifier = irandom(999999);
dont_deactivate = false;
array_push(ACTIVE_GAME_OBJECTS, id);
print(sprite_index);
function draw() { if (sprite_index < 0) return; draw_self(); }