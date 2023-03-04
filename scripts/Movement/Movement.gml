
function UpdateVelocities(object_physics, delta) 
{
    var ACCELERATION = object_physics.acceleration * delta;
    var FRICTION = object_physics.friction * delta;
    var xforce = object_physics.force[X];
    var yforce = object_physics.force[Y];
    
    if (abs(object_physics.velocity[X]) < abs(xforce))
        object_physics.velocity[X] += xforce * ACCELERATION;
    else
        object_physics.velocity[X] = lerp(object_physics.velocity[X], 0, FRICTION);
        
    if (abs(object_physics.velocity[Y]) < abs(yforce))
        object_physics.velocity[Y] += yforce * ACCELERATION;
    else
        object_physics.velocity[Y] = lerp(object_physics.velocity[Y], 0, FRICTION);
}

/****
 * If velocity is greater than the CELL dimensions break down the collision checks
 * into multiple checks, to prevent moving through narrow walls on high velocity
 */
function MoveAndCollide(object_physics, delta)
{
    var object_velocity = [ object_physics.velocity[X] * delta, object_physics.velocity[Y] * delta ];
    object_physics.collision = false;

    var left_offset   = round(x - bbox_left);
    var right_offset  = round(bbox_right - x);
    var top_offset    = round(y - bbox_top);
    var bottom_offset = round(bbox_bottom - y);
    
    var signed_sub_steps = object_velocity[X] div CELL_W;
    var sub_steps = abs(signed_sub_steps) + 1;
    repeat (sub_steps--) {
        var hspd = sub_steps > 0 ? sign(signed_sub_steps) * CELL_W : object_velocity[X] % CELL_W;
        if (CURRENT_LEVEL.check_collision_square(bbox_left + hspd, bbox_top, bbox_right + hspd + 1, bbox_bottom))
        {
            // Horizontal wall-collision, snap to the wall
            if (hspd > 0) 
            {
                var cell = CURRENT_LEVEL.get_cell_coordinates(bbox_right + hspd, y);
                if (bbox_right <  cell[X1])
                {
                    x = cell[X1] - right_offset - 1;
                }
                else
                {
                    x = cell[X1] - right_offset - 1 + CELL_W;
                }
            }
            else if (hspd < 0)
            {
                var cell = CURRENT_LEVEL.get_cell_coordinates(bbox_left + hspd, y);
                if (bbox_right > cell[X2]) 
                {
                    x = cell[X2] + left_offset;
                }
                else
                {
                    x = cell[X2] + left_offset + CELL_W;
                }
            }
            hspd = 0;
            object_physics.velocity[X] = 0;
            object_physics.collision = true;
            break;
        }
        x += hspd;
    }

    if (CURRENT_LEVEL.check_collision_square(bbox_left, bbox_top, bbox_right - 1, bbox_bottom - 1))
    { // Bad movement
        x = xprevious;
    }

    signed_sub_steps = object_velocity[Y] div CELL_H;
    sub_steps = abs(signed_sub_steps) + 1;
    repeat (sub_steps--) {
        var vspd = sub_steps > 0 ? sign(signed_sub_steps) * CELL_H : object_velocity[Y] % CELL_H;
        if (CURRENT_LEVEL.check_collision_square(bbox_left, bbox_top + vspd, bbox_right, bbox_bottom + vspd + 1))
        {
            // Vertical wall-collision, snap to the wall
            if (vspd > 0)
            {
                var cell = CURRENT_LEVEL.get_cell_coordinates(x, bbox_bottom + vspd);
                if (bbox_bottom < cell[Y1]) 
                {
                    y = cell[Y1] - bottom_offset - 1;
                }
                else
                {
                    y = cell[Y1] - bottom_offset - 1 + CELL_H;
                }
            }
            else if (vspd < 0)
            {
                var cell = CURRENT_LEVEL.get_cell_coordinates(x, bbox_top + vspd);
                if (bbox_bottom > cell[Y2])
                {
                    y = cell[Y2] + top_offset;
                }
                else
                {
                    y = cell[Y2] + top_offset + CELL_H;
                }
            }
            vspd = 0;
            object_physics.velocity[Y] = 0;
            object_physics.collision = true;
            break;
        }
        y += vspd;
    }

    if (CURRENT_LEVEL.check_collision_square(bbox_left, bbox_top, bbox_right, bbox_bottom))
    { // Bad movement
        y = yprevious;
    }
    
}



