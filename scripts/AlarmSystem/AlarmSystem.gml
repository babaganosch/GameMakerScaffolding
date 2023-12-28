game_alarms = new AlarmSystem();
sys_alarms = new AlarmSystem();

function AlarmEntry(_handle, _duration, _callback, _periodic) constructor
{
	handle = _handle;
    time = _duration;
    cb = _callback;
    per = _periodic == true ? _duration : false;
}

function AlarmSystem() constructor
{
	alarm_list = [];
	static next_id = 0;
	
	function add(_duration, _callback, _periodic) {
		var _handle = next_id++;
        var _alrm = new AlarmEntry(_handle, _duration, _callback, _periodic);
		array_push(alarm_list, _alrm);
        return _handle;
	}
    
    function abort(_handle) {
        for (var _i = 0; _i < array_length(alarm_list); ++_i) {
            if (alarm_list[_i].handle == _handle) {
                array_delete(alarm_list, _i, 1);
                return true;
            }
        }
        return false;
    }
    
    function cleanup() {
        for (var _i = 0; _i < array_length(alarm_list); ++_i) {
            delete alarm_list[_i];
        }
        alarm_list = [];
    }
	
	function tick(_delta) {
		for (var _i = 0; _i < array_length(alarm_list); ++_i) {
			alarm_list[_i].time -= _delta;
			if (alarm_list[_i].time <= 0) {
				alarm_list[_i].cb();
                if (alarm_list[_i].per != false) {
                    alarm_list[_i].time = alarm_list[_i].per;
                } else {
                    array_delete(alarm_list, _i, 1);
				    --_i;
                }
			}
		}
	}
}
