// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function animation_play(){	
	// create variables if they do not exist
	if variable_instance_exists(id, "animation_type_current") == false {
		animation_type_current = animation_type.first_frame;
	}
	if variable_instance_exists(id, "animation_fps_current") == false {
		animation_fps_current = 60;
	}
	if variable_instance_exists(id,"animation_frame_counter") == false {
		animation_frame_counter = 0;
	}
	
	// Ignore if animation should hold first frame
	if animation_type_current == animation_type.first_frame
	{
		image_index = 0;
		return;
	}
	
	// add to the counter
	animation_frame_counter ++;
	var game_fps = 60;
	// check if animation has reached loop point
	if (animation_frame_counter >= game_fps / animation_fps_current)
	{
		animation_frame_counter = 0;
		if animation_type_current == animation_type.loop_reverse {
			image_index--;
			if image_index < 0 {
				image_index = sprite_get_number(sprite_index) - 1;
			}
			return;
		}
		image_index ++;
		if image_index >= sprite_get_number(sprite_index)
		{
			if animation_type_current == animation_type.loop image_index = 0;
			else if animation_type_current == animation_type.hold image_index = sprite_get_number(sprite_index) - 1;
		}
	}
}