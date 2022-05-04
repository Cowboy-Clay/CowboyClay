if keyboard_check_pressed(ord("X")) || gamepad_button_check_pressed(0,gp_face3) {
	if array_length(sequence) == 0 {
		room_goto(FinalLevelDesign);
		return;
	}
	audio_play_sound(sfx_start,0,false);
	sprite_index = sequence[0];
	image_index = 0;
}

if sprite_index != last_sprite || floor(image_index) != last_image {
	show_debug_message(sprite_get_name(sprite_index));
	show_debug_message(floor(image_index));
	
	if sprite_index == Shot6 && floor(image_index) == 23 {
		audio_play_sound(sfx_gun_cock, 0, false);
	}
	if sprite_index == Shot4 {
		if floor(image_index) == 1 {
			audio_play_sound(sfx_moose_knife_plant,10,false);
		} else if floor(image_index) == 8 {
			audio_play_sound(sfx_moose_crash,10,false);
		} else if floor(image_index) == 16 {
			audio_play_sound(sfx_clay_block,10,false);
		}
	}
	
	last_sprite = sprite_index;
	last_image = floor(image_index);
}
