function gamepad_button_check_pressed_anypad(_button){
	var _gp_count = gamepad_get_device_count();
	for(var i = 0; i<_gp_count; i++) {
		if gamepad_button_check_pressed(i,_button) return true;
	}
	return false;
}