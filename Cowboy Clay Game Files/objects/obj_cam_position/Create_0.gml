//x_offset = -800;
//y_offset = -720;

cam = view_camera[0];

target = noone;
if instance_exists(obj_player_neutral) target = obj_player_neutral;
else if instance_exists(obj_player_sitting) target = obj_player_sitting;
else if instance_exists(obj_player_fighting) target = obj_player_fighting;
else return;

x = target.x;
y = target.y;

cam_width = camera_get_view_width(cam);
cam_height = camera_get_view_height(cam);

shake = -1;
min_mag = 0;
max_mag = 0;

if instance_exists(obj_cam_anchor)
{
	if place_meeting(x,y,obj_cam_anchor)
	{
		a = instance_nearest(x,y,obj_cam_anchor);
		x = a.x;
		y = a.y;
	}
}

camera_set_view_pos(cam,x-camera_get_view_width(cam)/2,y-camera_get_view_height(cam)/2);

function camera_shake(_time, _min_magnitude, _max_magnitude) {
	shake = _time;
	min_mag = _min_magnitude;
	max_mag = _max_magnitude;
}
