target = noone;
if instance_exists(obj_player_neutral) target = obj_player_neutral;
else if instance_exists(obj_player_sitting) target = obj_player_sitting;
else if instance_exists(obj_player_fighting) target = obj_player_fighting;
else return;

ideal_x = target.x + offset_x;
ideal_y = target.y + offset_y;

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
if instance_exists(obj_cam_bound) {
	if place_meeting(ideal_x,ideal_y,obj_cam_bound) {
		var a = instance_nearest(ideal_x,ideal_y,obj_cam_bound);
		ideal_x = clamp(ideal_x,a.min_x, a.max_x);
		ideal_y = clamp(ideal_y,a.min_y, a.max_y);
		
		var ww = lerp(camera_get_view_width(cam), cam_width*a.vport_multi, 0.1);
		var hh = lerp(camera_get_view_height(cam), cam_height*a.vport_multi, 0.1);
		camera_set_view_size(cam,ww,hh);
	}
}

x = lerp(x,ideal_x,0.1);
y = lerp(y,ideal_y,0.1);

if x > max_x && max_x != 0 {
	x = max_x;
}
if x < min_x && min_x != 0 {
	x = min_x;
}
if y > max_y && max_y != 0 {
	y = max_y;
}
if y < min_y && min_y != 0 {
	y = min_y;
}
var xx = x;
var yy = y;

if shake >= 0 {
	xx += sign(random_range(-1,1)) * random_range(min_mag,max_mag);
	yy += sign(random_range(-1,1)) * random_range(min_mag,max_mag);
	shake --;
}

camera_set_view_pos(cam,xx-camera_get_view_width(cam)/2,yy-camera_get_view_height(cam)/2);
audio_listener_set_position(0,camera_get_view_x(cam),camera_get_view_y(cam),0);