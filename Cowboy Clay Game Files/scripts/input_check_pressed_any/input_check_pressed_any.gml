function input_check_pressed_any(){
	// Key
	if keyboard_check_pressed(vk_anykey) return true;
	
	// controllers
	var _gp_count = gamepad_get_device_count();
	for(var i = 0; i < _gp_count; i ++) {
		// Buttons
		var _button_count = gamepad_button_count(i);
		for(var j = 0; j < _button_count; j++) {
			if gamepad_button_check_pressed(i,j) return true;
		}
		
		// Hats
		var _hat_count = gamepad_hat_count(i);
		for(var j = 0; j < _hat_count; j++) {
			if gamepad_hat_value(i,j) > 0 return true;
		}
		
		// sticks
		var _axis_count = gamepad_axis_count(i);
		for(var j = 0; j < _axis_count; j++) {
			if abs(gamepad_axis_value(i,j)) > 0.25 return true;
		}
	}
	
	return false;
}