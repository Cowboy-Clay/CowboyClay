ideal_x = obj_player.x;
ideal_y = obj_player.y;

if instance_exists(obj_cam_anchor)
{
	if place_meeting(ideal_x,ideal_y,obj_cam_anchor)
	{
		var a = instance_nearest(ideal_x,ideal_y,obj_cam_anchor);
		ideal_x = a.x;
		ideal_y = a.y;
		

		var ww = lerp(camera_get_view_width(cam), cam_width*a.vport_multi, 0.1);
		var hh = lerp(camera_get_view_height(cam), cam_height*a.vport_multi, 0.1);
		camera_set_view_size(cam,ww,hh);
	}
}

x = lerp(x,ideal_x,0.1);
y = lerp(y,ideal_y,0.1);

camera_set_view_pos(cam,x-camera_get_view_width(cam)/2,y-camera_get_view_height(cam)/2);
audio_listener_set_position(0,x-camera_get_view_width(cam)/2,y-camera_get_view_height(cam)/2,0);