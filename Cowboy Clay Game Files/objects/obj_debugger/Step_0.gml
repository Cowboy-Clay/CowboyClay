var _maxpad = gamepad_get_device_count();

for (var i = 0; i < _maxpad; i++) {
	if gamepad_is_connected(i) {
		for(var j = 0; j < gamepad_button_count(i); j++) {
			if gamepad_button_check(i,j) show_debug_message("Controller #" + string(i) + " reads button #" + string(j) + " being pushed at frame " + string(current_time) + ".");
		}
		
		for(var j = 0; j < gamepad_axis_count(i); j++) {
			show_debug_message("Axis #" + string(j) + " is reading as " + string(gamepad_axis_value(i,j)) + ".");
		}
	}
}
