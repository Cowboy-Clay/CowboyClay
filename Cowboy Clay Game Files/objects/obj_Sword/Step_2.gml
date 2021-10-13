/// @description Insert description here
// You can write your code in this editor

if my_sword_state == sword_state.neutral
{
	x = obj_Player.x + (offset * sign(obj_Player.image_xscale));
	y = obj_Player.y;

	image_xscale = 6 * sign(obj_Player.image_xscale);
	image_yscale = 3;
}
if my_sword_state == sword_state.flung
{
	image_xscale = 1;
	image_yscale = 1;
}
if my_sword_state == sword_state.stuck
{
	image_xscale = 2;
	image_yscale = 2;
}