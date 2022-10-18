hspeed += wind_accel;
if abs(hspeed) > max_hspeed && hspeed < 0
	hspeed = lerp(hspeed, sign(hspeed) * abs(max_hspeed), 0.2);

vspeed += grav_accel;
if collision_check_edge(x, y+vspeed, spr_envi_tumbleweed, Direction.DOWN, collision_mask) {
	vspeed = -1 * abs(vspeed);
	hspeed *= 0.6;
}

var angular_velocity = sqrt(sqr(hspeed) + sqr(vspeed));
image_angle += lerp(rotation_min, rotation_max, angular_velocity / 5);

if place_meeting(x+hspeed, y+vspeed, obj_player_hitbox) {
	hspeed = sign(x-obj_player_fighting.x) * max_hspeed * 2;
}
