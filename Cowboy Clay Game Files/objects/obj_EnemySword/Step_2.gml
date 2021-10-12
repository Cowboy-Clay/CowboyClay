/// @description Insert description here
// You can write your code in this editor
x = obj_Enemy.x + offset;
y = obj_Enemy.y;

if obj_Enemy.x < obj_Player.x {
	offset = default_offset;
	image_xscale = default_image_scale;
}
else if obj_Enemy.x > obj_Player.x{
	offset = (default_offset * -1);
	image_xscale = (default_image_scale * -1);
}

//show_debug_message("Enemy X " + string(obj_Enemy.x))
//show_debug_message("Player X " + string(obj_Player.x))

//image_xscale = obj_Enemy.image_xscale;
