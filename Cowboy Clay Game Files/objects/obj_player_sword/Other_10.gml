/// @description Pause
if global.paused {
	// show_debug_message("hspeed before pause: " + string(hspeed));
	// show_debug_message("vspeed before pause: " + string(vspeed));
	_hspeed_mem = hspeed;
	hspeed = 0;
	_vspeed_mem = vspeed;
	vspeed = 0;
	_image_speed_mem = image_speed;
	image_speed = 0;
	//show_debug_message("hspeed after pause: " + string(hspeed));
	//show_debug_message("vspeed after pause: " + string(vspeed));
	//show_debug_message("hspeed_mem after pause: " + string(_hspeed_mem));
	//show_debug_message("vspeed_mem after pause: " + string(_vspeed_mem));
} else {
	hspeed = _hspeed_mem;
	vspeed = _vspeed_mem;
	image_speed = _image_speed_mem;
}
