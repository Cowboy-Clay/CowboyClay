/// @description Insert description here
// You can write your code in this editor
if my_sword_state == sword_state.neutral
{
x = obj_Moose.x + offset;
y = obj_Moose.y;

if obj_Moose.x < obj_NewPlayer.x {
	offset = default_offset;
	image_xscale = default_image_scale;
}
else if obj_Moose.x > obj_NewPlayer.x{
	offset = (default_offset * -1);
	image_xscale = (default_image_scale * -1);
}
}
//show_debug_message("Enemy X " + string(obj_Enemy.x))
//show_debug_message("Player X " + string(obj_Player.x))

//image_xscale = obj_Enemy.image_xscale;

MoveInbounds();