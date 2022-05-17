if global.paused return;

h += h_drag;
hspeed = facing == Direction.RIGHT ? h : -1 * h;
vspeed += v;

lifetime++;
if lifetime % 6 == 0 {
	image_index = image_index == sprite_get_number(sprite_index) ? 0 : image_index + 1;
}
if lifetime > global.player_projectile_max_frames || place_meeting_mask(x,y,collision_mask){
	instance_destroy(id);
}
