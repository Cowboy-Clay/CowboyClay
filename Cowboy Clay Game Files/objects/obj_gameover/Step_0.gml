switch (current_state) {
	// wipe
	case 0:
		
		break;
	// game over text appears
	case 1:
		if keyboard_check_pressed(vk_anykey){
			current_state = 2;
		}
		break;
	// waiting for end
	case 2:
		timer --;;
	
		if input_check_pressed (input_action.jump)|| 
		input_check_pressed (input_action.attack) || 
		input_check_pressed (input_action.sling) || 
		input_check_pressed (input_action.menu) || 
		input_check_pressed (input_action.face) || 
		input_check_pressed (input_action.block) {
			current_state = 3;
		} 
		if timer <= 0 room_goto(Menu);
		break;
	// respawning
	case 3:
		image_alpha -= 1/45;
		if image_alpha <= 0 {
			obj_player_fighting.current_state = PlayerState.REVIVING;
			instance_destroy(id);
		}
		break;
}
