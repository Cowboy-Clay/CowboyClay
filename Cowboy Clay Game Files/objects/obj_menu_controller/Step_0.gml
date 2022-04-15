if keyboard_check_pressed(ord("X")) && !flash_flag {
	flash_flag = true;
	timer = global.menu_flash_time;
}

if !flash_flag && !fade_flag {
	timer++;
	if timer >= global.menu_flash_frames_per {
		obj_menu_title.image_index = obj_menu_title.image_index == 0 ? 1 : 0;
		timer = 0;
	}
} else if flash_flag && !fade_flag {
	timer--;
	if timer % global.menu_flash_frames_per_fast == 0 {
		obj_menu_title.image_index = obj_menu_title.image_index == 0 ? 1 : 0;
	}
	if timer <= 0 fade_flag = true;
} else if fade_flag {
	room_goto(global.menu_scene_to_load);
}