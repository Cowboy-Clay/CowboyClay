nearest_anchor = instance_nearest(obj_player.x, obj_player.y, obj_cam_anchor);

if nearest_anchor == noone
{
	x = obj_player.x + x_offset;
	y = obj_player.y + y_offset;
}
else if abs(obj_player.x - nearest_anchor.x) < nearest_anchor.x_distance &&
	abs(obj_player.y - nearest_anchor.y) < nearest_anchor.y_distance
{
		x = nearest_anchor.x;
		y = nearest_anchor.y;
}
else
{
	x = obj_player.x + x_offset;
	y = obj_player.y + y_offset;
}

camera_set_view_pos(view_camera[0],x,y);