if keyboard_check_pressed(vk_f11){
	window_set_fullscreen(!window_get_fullscreen());
}

if ((keyboard_check_pressed(ord("X")) || gamepad_button_check_pressed_anypad(gp_face3)) || gamepad_button_check_pressed_anypad(gp_face2)) && sprite_index == CowboyClayTitle1 {
	if global.smart_control_detection == true {
		global.smart_control_detection = false;
		if keyboard_check_pressed(ord("X")) input_set_binds_keyboard();
		else if gamepad_button_check_pressed_anypad(gp_face3) input_set_binds_xbox();
		else if gamepad_button_check_pressed_anypad(gp_face2) input_set_binds_playstation();
	}
	
	if array_length(sequence) == 0 {
		room_goto(FinalLevelDesign);
		return;
	}
	if instance_exists(obj_music_controller) obj_music_controller.quiet();
	audio_play_sound(sfx_start,0,false);
	sprite_index = sequence[0];
	image_index = 0;
} else if (keyboard_check_pressed(ord("X")) && global.input_current_setting == input_setting.keyboard) || (gamepad_button_check_pressed_anypad(gp_face3) && global.input_current_setting == input_setting.xbox_controller) || (gamepad_button_check_pressed_anypad(gp_face2) && global.input_current_setting == input_setting.playstation_controller){
	room_goto(FinalLevelDesign);
	return;
}

if sprite_index != last_sprite || floor(image_index) != last_image {
	//show_debug_message(sprite_get_name(sprite_index));
	//show_debug_message(floor(image_index));
	
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
	
	if sprite_index == Shot3 && image_index == 1 {
		audio_play_sound(sfx_clay_sling,-1,true);
	} else if sprite_index != Shot3 && audio_is_playing(sfx_clay_sling) {
		audio_stop_sound(sfx_clay_sling);
	}
	
	if sprite_index == Shot5 && image_index == 1 {
		audio_play_sound(sfx_clay_sword_spin,-1,true);
	} else if sprite_index == Shot6 && image_index == 22 && audio_is_playing(sfx_clay_sword_spin) {
		audio_stop_sound(sfx_clay_sword_spin);
	}
	
	if sprite_index == Shot6_2 && image_index == 19 {
		audio_play_sound(sfx_gunshot,-1,false);
	}
	
	last_sprite = sprite_index;
	last_image = floor(image_index);
}
