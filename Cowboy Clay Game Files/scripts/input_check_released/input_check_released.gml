function input_check_released(_input_action){
	input_create_manager();
	switch _input_action {
		case input_action.up:
			return global.input_up_released_value;
			break;
		case input_action.down:
			return global.input_down_released_value;
			break;
		case input_action.left:
			return global.input_left_released_value;
			break;
		case input_action.right:
			return global.input_right_released_value;
			break;
		case input_action.attack:
			return global.input_attack_released_value;
			break;
		case input_action.jump:
			return global.input_jump_released_value;
			break;
		case input_action.sling:
			return global.input_sling_released_value;
			break;
		case input_action.face:
			return global.input_face_released_value;
			break;
		case input_action.block:
			return global.input_block_released_value;
			break;
		case input_action.kick:
			return global.input_kick_released_value;
			break;
		case input_action.menu:
			return global.input_menu_released_value;
			break;
	}
	return false;
}
