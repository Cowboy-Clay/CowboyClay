// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function gamepad_axis_check(_axis_string){
	if typeof(_axis) != "string" return false;
	
	var _sign = string_char_at(_axis_string, 0) == "-" ? -1 : 1;
	var _axis = real(string_char_at(_axis_string,1));
	
	var _gp_count = gamepad_get_device_count();
	for(var i = 0; i < _gp_count; i ++) {
		if gamepad_axis_value(i,_axis) > 0.5 * _sign return true;
	}
	
	return false;
}