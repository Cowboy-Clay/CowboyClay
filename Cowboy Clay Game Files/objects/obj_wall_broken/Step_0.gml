vspeed += grav;
if half == 1 {
	sprite_index = sprite_1;
} else {
	sprite_index = sprite_2;
}

image_angle += rot_speed;

lifetime--;
if lifetime < 0 {
	instance_destroy(id);
}
