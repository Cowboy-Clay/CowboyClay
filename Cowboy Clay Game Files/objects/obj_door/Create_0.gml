open = false;
global.door_open_frames_per_image = 30;
global.door_close_frames_per_image = 5;
timer = 0;

total_frames = sprite_get_number(sprite_index);

if test_door {
	open = true;
}

function open_door()
{
	if open return;
	timer = 0;
	open = true;
}
function close_door()
{
	if !open return;
	timer = 0;
	open = false;
}

function animate_door()
{
	if open && image_index == total_frames - 1 return;
	if !open && image_index == 0 return;
	timer++;
	if open && timer >= global.door_open_frames_per_image && image_index < total_frames
	{
		timer = 0;
		image_index ++;
	}
	else if !open && timer >= global.door_close_frames_per_image && image_index > 0
	{
		timer = 0;
		image_index --;
	}
}