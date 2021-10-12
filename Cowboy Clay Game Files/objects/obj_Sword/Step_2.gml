/// @description Insert description here
// You can write your code in this editor

if my_sword_state == sword_state.neutral
{
	x = obj_Player.x + offset;
	y = obj_Player.y;

	if obj_Player.hspeed < 0 && offset > 0 {
		offset *= -1;
	}
	else if obj_Player.hspeed > 0 && offset < 0 {
		offset *= -1;
	}

	image_xscale = obj_Player.image_xscale;
}