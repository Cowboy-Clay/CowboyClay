function input_check_pressed(_input_action){
	input_create_manager();
	switch _input_action {
		case input_action.up:
			return global.input_up_pressed_value;
			break;
		case input_action.down:
			return global.input_down_pressed_value;
			break;
		case input_action.left:
			return global.input_left_pressed_value;
			break;
		case input_action.right:
			return global.input_right_pressed_value;
			break;
		case input_action.attack:
			return global.input_attack_pressed_value;
			break;
		case input_action.jump:
			return global.input_jump_pressed_value;
			break;
		case input_action.sling:
			return global.input_sling_pressed_value;
			break;
		case input_action.face:
			return global.input_face_pressed_value;
			break;
		case input_action.block:
			return global.input_block_pressed_value;
			break;
		case input_action.kick:
			return global.input_kick_pressed_value;
			break;
	}
	return false;
}