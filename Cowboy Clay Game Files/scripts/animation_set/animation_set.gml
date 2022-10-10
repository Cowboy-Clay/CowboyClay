// [sprite, animation_type, fps]
function animation_set(animation_array){
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
	
	if sprite_index == animation_array[0] &&
	animation_fps_current == animation_array[1] &&
	animation_type_current == animation_array[2] {
		return;
	}
	
	sprite_index = animation_array[0];
	animation_fps_current = animation_array[1];
	animation_type_current = animation_array[2];
	animation_frame_counter = 0;
}