function micro_to_milli(val)
{
    return val / 1000;
}

function Profiler( profiling_points ) constructor
{
    points = { };
    if (is_struct(profiling_points)) points = profiling_points;
    else if (is_array(profiling_points))
    {
        for (var i = 0; i < array_length(profiling_points); ++i)
        {
            if (!is_string(profiling_points[i])) throw("Advanced Profiler setup failure");
            variable_struct_set(points, profiling_points[i], new ProfilingPoint());
        }
    }
    
    static update = function()
    {
        var arr = variable_struct_get_names(points);
        for (var i = 0; i < array_length(arr); ++i)
        {
            variable_struct_get(points, arr[i]).update();
        }
    }
    
    static destroy = function()
    {
        points = { };
    }
}

function ProfilingPoint( sample_points ) constructor
{
    _sample_points = 120;
    if (!is_undefined( sample_points )) _sample_points = argument[0];
    _values = array_create(_sample_points, 0);
    _index = 0;
    _average = 0;
    _min = 0;
    _max = 0;
    _old = 0;
    
    static start = function()
    {
        _old = get_timer();    
    }
    
    static stop = function()
    {
        var _now = get_timer();
        add_measure( _now - _old );
        _old = _now;
    }
    
    static add_measure = function( value )
    {
        _values[_index++] = value;
        _index = _index % _sample_points;
    }
    
    static update = function()
    {
        var sum = 0, lmin = 9999999999, lmax = 0;
        for (var i = 0; i < _sample_points; ++i)
        {
            var v = _values[i];
            lmin = min(lmin, v);
            lmax = max(lmax, v);
            sum += v;
        }
        _min = lmin;
        _max = lmax;
        _average = sum / _sample_points;
    }
    
    static get_average = function()
    {
        return _average;
    }
    
    static get_min = function()
    {
        return _min;
    }
    
    static get_max = function()
    {
        return _max;
    }
}