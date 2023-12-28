function micro_to_milli(_val)
{
    return _val / 1000;
}

function Profiler( _profiling_points ) constructor
{
    points = { };
    if (is_struct(_profiling_points)) points = _profiling_points;
    else if (is_array(_profiling_points))
    {
        for (var _i = 0; _i < array_length(_profiling_points); ++_i)
        {
            if (!is_string(_profiling_points[_i])) throw("Advanced Profiler setup failure");
            variable_struct_set(points, _profiling_points[_i], new ProfilingPoint());
        }
    }
    
    static update = function()
    {
        var _arr = variable_struct_get_names(points);
        for (var _i = 0; _i < array_length(_arr); ++_i)
        {
            variable_struct_get(points, _arr[_i]).update();
        }
    }
    
    static destroy = function()
    {
        points = { };
    }
}

function ProfilingPoint( _sample_points ) constructor
{
    sample_points = 120;
    if (!is_undefined( _sample_points )) sample_points = argument[0];
    values = array_create(sample_points, 0);
    index = 0;
    average = 0;
    min_v = 0;
    max_v = 0;
    old = 0;
    
    static start = function()
    {
        old = get_timer();    
    }
    
    static stop = function()
    {
        var _now = get_timer();
        add_measure( _now - old );
        old = _now;
    }
    
    static add_measure = function( _value )
    {
        values[index++] = _value;
        index = index % sample_points;
    }
    
    static update = function()
    {
        var _sum = 0, _lmin = 9999999999, _lmax = 0;
        for (var _i = 0; _i < sample_points; ++_i)
        {
            var _v = values[_i];
            _lmin = min(_lmin, _v);
            _lmax = max(_lmax, _v);
            _sum += _v;
        }
        min_v = _lmin;
        max_v = _lmax;
        average = _sum / sample_points;
    }
    
    static get_average = function()
    {
        return average;
    }
    
    static get_min = function()
    {
        return min_v;
    }
    
    static get_max = function()
    {
        return max_v;
    }
}