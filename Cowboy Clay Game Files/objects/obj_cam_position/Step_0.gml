ideal_x = obj_player.x;
ideal_y = obj_player.y;

if instance_exists(obj_cam_anchor)
{
	if place_meeting(ideal_x,ideal_y,obj_cam_anchor)
	{
		a = instance_nearest(ideal_x,ideal_y,obj_cam_anchor);
		ideal_x = a.x;
		ideal_y = a.y;
	}
}

x = lerp(x,ideal_x,0.1);
y = lerp(y,ideal_y,0.1);

camera_set_view_pos(cam,x-camera_get_view_width(cam)/2,y-camera_get_view_height(cam)/2);