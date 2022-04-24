active = false;
grav_accel = 1;
grav_max = 20;
rot_rate = 9;
dir = noone;

function activate(d) {
	hspeed = d == Direction.RIGHT ? 10 : -10;
	dir = d;
	vspeed = -20;
	active = true;
}
