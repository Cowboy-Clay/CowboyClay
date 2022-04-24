if active {
	vspeed = vspeed >= grav_max ? grav_max : vspeed + grav_accel;
	image_angle += dir == Direction.RIGHT ? rot_rate : -1 * rot_rate;
}
