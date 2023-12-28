
function update_velocities(_object_physics, _delta) 
{
    var _acceleration = _object_physics.acceleration * _delta;
    var _friction = _object_physics.friction * _delta;
    var _x_force = _object_physics.force[X];
    var _y_force = _object_physics.force[Y];
    
    if (abs(_object_physics.velocity[X]) < abs(_x_force))
        _object_physics.velocity[X] += _x_force * _acceleration;
    else
        _object_physics.velocity[X] = lerp(_object_physics.velocity[X], 0, _friction);
        
    if (abs(_object_physics.velocity[Y]) < abs(_y_force))
        _object_physics.velocity[Y] += _y_force * _acceleration;
    else
        _object_physics.velocity[Y] = lerp(_object_physics.velocity[Y], 0, _friction);
}

/****
 * If velocity is greater than the CELL dimensions break down the collision checks
 * into multiple checks, to prevent moving through narrow walls on high velocity
 */
function move_with_collision(_object_physics, _delta)
{
    var _object_velocity = [ _object_physics.velocity[X] * _delta, _object_physics.velocity[Y] * _delta ];
    _object_physics.collision = false;

    var _left_offset   = round(x - bbox_left);
    var _right_offset  = round(bbox_right - x);
    var _top_offset    = round(y - bbox_top);
    var _bottom_offset = round(bbox_bottom - y);
    
    var _signed_sub_steps = _object_velocity[X] div CELL_W;
    var _sub_steps = abs(_signed_sub_steps) + 1;
    repeat (_sub_steps--) {
        var _hspd = _sub_steps > 0 ? sign(_signed_sub_steps) * CELL_W : _object_velocity[X] % CELL_W;
        if (CURRENT_LEVEL.check_collision_square(bbox_left + _hspd, bbox_top, bbox_right + _hspd + 1, bbox_bottom))
        {
            // Horizontal wall-collision, snap to the wall
            if (_hspd > 0) 
            {
                var _cell = CURRENT_LEVEL.get_cell_coordinates(bbox_right + _hspd, y);
                if (bbox_right <  _cell[X1])
                {
                    x = _cell[X1] - _right_offset - 1;
                }
                else
                {
                    x = _cell[X1] - _right_offset - 1 + CELL_W;
                }
            }
            else if (_hspd < 0)
            {
                var _cell = CURRENT_LEVEL.get_cell_coordinates(bbox_left + _hspd, y);
                if (bbox_right > _cell[X2]) 
                {
                    x = _cell[X2] + _left_offset;
                }
                else
                {
                    x = _cell[X2] + _left_offset + CELL_W;
                }
            }
            _hspd = 0;
            _object_physics.velocity[X] = 0;
            _object_physics.collision = true;
            break;
        }
        x += _hspd;
    }

    if (CURRENT_LEVEL.check_collision_square(bbox_left, bbox_top, bbox_right - 1, bbox_bottom - 1))
    { // Bad movement
        x = xprevious;
    }

    _signed_sub_steps = _object_velocity[Y] div CELL_H;
    _sub_steps = abs(_signed_sub_steps) + 1;
    repeat (_sub_steps--) {
        var _vspd = _sub_steps > 0 ? sign(_signed_sub_steps) * CELL_H : _object_velocity[Y] % CELL_H;
        if (CURRENT_LEVEL.check_collision_square(bbox_left, bbox_top + _vspd, bbox_right, bbox_bottom + _vspd + 1))
        {
            // Vertical wall-collision, snap to the wall
            if (_vspd > 0)
            {
                var _cell = CURRENT_LEVEL.get_cell_coordinates(x, bbox_bottom + _vspd);
                if (bbox_bottom < _cell[Y1]) 
                {
                    y = _cell[Y1] - _bottom_offset - 1;
                }
                else
                {
                    y = _cell[Y1] - _bottom_offset - 1 + CELL_H;
                }
            }
            else if (_vspd < 0)
            {
                var _cell = CURRENT_LEVEL.get_cell_coordinates(x, bbox_top + _vspd);
                if (bbox_bottom > _cell[Y2])
                {
                    y = _cell[Y2] + _top_offset;
                }
                else
                {
                    y = _cell[Y2] + _top_offset + CELL_H;
                }
            }
            _vspd = 0;
            _object_physics.velocity[Y] = 0;
            _object_physics.collision = true;
            break;
        }
        y += _vspd;
    }

    if (CURRENT_LEVEL.check_collision_square(bbox_left, bbox_top, bbox_right, bbox_bottom))
    { // Bad movement
        y = yprevious;
    }
    
}



