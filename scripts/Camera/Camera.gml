function Camera(_x, _y, _w, _h) constructor
{
    pos   = [_x, _y];
    size  = [_w, _h];
    edges = [_x, _y, _x+_w, _y+_h];
    ref   = camera_create_view(pos[0], pos[1], size[0] + 1, size[1] + 1);
    buffer = [75, 75];
    active_zone = [edges[X1] - buffer[X], edges[Y1] - buffer[Y],
                   edges[X2] + buffer[X], edges[Y2] + buffer[Y]];
    
    static update = function()
    {
        pos[X] = clamp(pos[X], CELL_W, room_width - size[X] - CELL_W);
        pos[Y] = clamp(pos[Y], CELL_H, room_height - size[Y] - CELL_H);
        edges = [ pos[X], pos[Y], pos[X] + size[X], pos[Y] + size[Y] ];
        active_zone = [edges[X1] - buffer[X], edges[Y1] - buffer[Y],
                       edges[X2] + buffer[X], edges[Y2] + buffer[Y]];
        camera_set_view_pos(ref, floor(pos[X]), floor(pos[Y]));
    }
    
    static activate = function()
    {
        view_enabled = true;
        view_camera[0] = ref;
        view_set_visible(0, true);
    }
    
    static destroy = function()
    {
        camera_destroy(ref);
    }
    
    function move(_x, _y)
    {
        pos[X] = _x;
        pos[Y] = _y;
        update();
    }
    
    function move_center(_x, _y)
    {
        pos[X] = _x - (size[X] div 2);
        pos[Y] = _y - (size[Y] div 2);
        update();
    }
    
    function move_relative(_x, _y)
    {
        pos[X] += _x;
        pos[Y] += _y;
        update();
    }
    
    function approach(_x, _y, _spd)
    {
        pos[X] = global.smooth_approach(pos[X], _x, _spd);
        pos[Y] = global.smooth_approach(pos[Y], _y, _spd);
        update();
    }
    
    function approach_center(_x, _y, _spd)
    {
        pos[X] = global.smooth_approach(pos[X], _x - (size[X] div 2), _spd);
        pos[Y] = global.smooth_approach(pos[Y], _y - (size[Y] div 2), _spd);
        update();
    }
    
    function resize(_w, _h)
    {
        size = [_w, _h];
        camera_set_view_size(ref, size[X] + 1, size[Y] + 1);
    }
}