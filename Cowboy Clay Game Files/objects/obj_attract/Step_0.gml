if keyboard_check_pressed(vk_f11){
	window_set_fullscreen(!window_get_fullscreen());
}

if input_check_pressed(input_action.jump) || input_check_pressed(input_action.attack) ||
input_check_pressed(input_action.block) || input_check_pressed(input_action.face) ||
input_check_pressed(input_action.kick) || input_check_pressed(input_action.sling) {
	var _l = layer_get_id("Wipe");
	instance_create_layer(0,0,_l,obj_wipe_in);
	instance_create_layer(x,y,layer,obj_menu_title);
	instance_destroy(id);
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
