function Camera(x, y, w, h) constructor
{
    pos   = [x, y];
    size  = [w, h];
    edges = [x, y, x+w, y+h];
    ref   = camera_create_view(pos[0], pos[1], size[0] + 1, size[1] + 1);
    buffer = [50, 50];
    
    static update = function()
    {
        pos[X] = clamp(pos[X], CELL_W, room_width - size[X] - CELL_W);
        pos[Y] = clamp(pos[Y], CELL_H, room_height - size[Y] - CELL_H);
        edges = [ pos[X], pos[Y], pos[X] + size[X], pos[Y] + size[Y] ];
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
    
    function move(x, y)
    {
        pos[X] = x;
        pos[Y] = y;
        update();
    }
    
    function move_center(x, y)
    {
        pos[X] = x - (size[X] div 2);
        pos[Y] = y - (size[Y] div 2);
        update();
    }
    
    function move_relative(x, y)
    {
        pos[X] += x;
        pos[Y] += y;
        update();
    }
    
    function approach(x, y, spd)
    {
        pos[X] = global.smooth_approach(pos[X], x, spd);
        pos[Y] = global.smooth_approach(pos[Y], y, spd);
        update();
    }
    
    function approach_center(x, y, spd)
    {
        pos[X] = global.smooth_approach(pos[X], x - (size[X] div 2), spd);
        pos[Y] = global.smooth_approach(pos[Y], y - (size[Y] div 2), spd);
        update();
    }
    
    function resize(w, h)
    {
        size = [w, h];
        camera_set_view_size(ref, size[X] + 1, size[Y] + 1);
    }
    
    if (false)
    {
        move_center(0, 0);
        move_relative(0, 0);
        resize(0, 0);
    }
}