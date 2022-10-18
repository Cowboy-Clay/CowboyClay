/// @description Pause


if global.paused {
	_hspeed_mem = hspeed; hspeed = 0;
	_vspeed_mem = vspeed; vspeed = 0;
	_image_speed_mem = image_speed; image_speed = 0;
} else {
	hspeed = _hspeed_mem;
	vspeed = _vspeed_mem;
	image_speed = _image_speed_mem;
}
