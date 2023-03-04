global.__game_alarms = new AlarmSystem();
global.__system_alarms = new AlarmSystem();

function AlarmEntry(duration, callback, periodic) constructor
{
    time = duration;
    cb = callback;
    per = periodic == true ? duration : false;
}

function AlarmSystem() constructor
{
	alarm_list = [];
	
	function add(duration, callback, periodic) {
        var _id = new AlarmEntry(duration, callback, periodic);
		array_push(alarm_list, _id);
        return instance_id_get(_id);
	}
    
    function abort(alrm) {
        if (is_undefined(alrm)) return false;
        for (var _i = 0; _i < array_length(alarm_list); ++_i) {
            if (instance_id_get(alarm_list[_i]) == alrm) {
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
	
	function tick(delta) {
		for (var _i = 0; _i < array_length(alarm_list); ++_i) {
			alarm_list[_i].time -= delta;
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
