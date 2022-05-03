switch (current_state) {
	case 0:
		// fade in 
		image_alpha += 1/45;
		if image_alpha >= 1 {
			current_state = 1;
			image_speed = 1;
		}
		break;
	case 1:
		if keyboard_check_pressed(vk_anykey){
			current_state = 2;
		}
		break;
	case 2:
		if keyboard_check_pressed(global.keybind_jump) || gamepad_button_check_pressed(0,gp_face3) {
			current_state = 3;
		} else if keyboard_check_pressed(ord("B")) || gamepad_button_check_pressed(0,gp_face2) {
			room_goto(Menu);
		}
		break;
	case 3:
		image_alpha -= 1/45;
		if image_alpha <= 0 {
			obj_player.current_state = PlayerState.REVIVING;
			instance_destroy(id);
		}
		break;
}
