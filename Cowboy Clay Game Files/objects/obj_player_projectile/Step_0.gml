h += h_drag;
hspeed = facing == Direction.RIGHT ? h : -1 * h;
vspeed += v;

lifetime++;
if lifetime > global.player_projectile_max_frames || place_meeting_mask(x,y,collision_mask){
	instance_destroy(id);
}
