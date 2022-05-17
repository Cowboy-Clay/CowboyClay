function input_check(_input_action){
	input_create_manager();
	
	switch(_input_action) {
		case input_action.up:
			var _up_primary_value = false;
			var _up_secondary_value = false;
			if global.input_up_primary != noone {
				var _up_primary_type = global.input_up_primary[0];
				// Get the value of the primary input
				switch(_up_primary_type) {
					case input_type.key:
						_up_primary_value = keyboard_check(global.input_up_primary[1]);
						break;
					case input_type.button:
						_up_primary_value = gamepad_button_check_anypad(global.input_up_primary[1]);
						break;
					case input_type.hat:
						_up_primary_value = gamepad_hat_check(global.input_up_primary[1]);
						break;
					case input_type.axis:
						_up_primary_value = gamepad_axis_check(global.input_up_primary[1]);
				}
			}
			if global.input_up_secondary != noone {
				var _up_secondary_type = global.input_up_secondary[0];
				// Get the value of the secondary input
				switch(_up_secondary_type) {
					case input_type.key:
						_up_secondary_value = keyboard_check(global.input_up_secondary[1]);
						break;
					case input_type.button:
						_up_secondary_value = gamepad_button_check_anypad(global.input_up_secondary[1]);
						break;
					case input_type.hat:
						_up_secondary_value = gamepad_hat_check(global.input_up_secondary[1]);
						break;
					case input_type.axis:
						_up_secondary_value = gamepad_axis_check(global.input_up_secondary[1]);
				}
			}
			
			if _up_primary_value || _up_secondary_value return true;
			return false;
			break;
		case input_action.down:
			var _down_primary_value = false;
			var _down_secondary_value = false;
			if global.input_down_primary != noone {
				var _down_primary_type = global.input_down_primary[0];
				// Get the value of the primary input
				switch(_down_primary_type) {
					case input_type.key:
						_down_primary_value = keyboard_check(global.input_down_primary[1]);
						break;
					case input_type.button:
						_down_primary_value = gamepad_button_check_anypad(global.input_down_primary[1]);
						break;
					case input_type.hat:
						_down_primary_value = gamepad_hat_check(global.input_down_primary[1]);
						break;
					case input_type.axis:
						_down_primary_value = gamepad_axis_check(global.input_down_primary[1]);
				}
			}
			if global.input_down_secondary != noone {
				// Get the value of the secondary input
				var _down_secondary_type = global.input_down_secondary[0];
				switch(_down_secondary_type) {
					case input_type.key:
						_down_secondary_value = keyboard_check(global.input_down_secondary[1]);
						break;
					case input_type.button:
						_down_secondary_value = gamepad_button_check_anypad(global.input_down_secondary[1]);
						break;
					case input_type.hat:
						_down_secondary_value = gamepad_hat_check(global.input_down_secondary[1]);
						break;
					case input_type.axis:
						_down_secondary_value = gamepad_axis_check(global.input_down_secondary[1]);
				}
			}
			if _down_primary_value || _down_secondary_value return true;
			return false;
			break;
		case input_action.left:
			var _left_primary_value = false;
			var _left_secondary_value = false;
			if global.input_left_primary != noone {
				var _left_primary_type = global.input_left_primary[0];
				// Get the value of the primary input
				switch(_left_primary_type) {
					case input_type.key:
						_left_primary_value = keyboard_check(global.input_left_primary[1]);
						break;
					case input_type.button:
						_left_primary_value = gamepad_button_check_anypad(global.input_left_primary[1]);
						break;
					case input_type.hat:
						_left_primary_value = gamepad_hat_check(global.input_left_primary[1]);
						break;
					case input_type.axis:
						_left_primary_value = gamepad_axis_check(global.input_left_primary[1]);
				}
			}
			if global.input_left_secondary != noone {
				// Get the value of the secondary input
				var _left_secondary_type = global.input_left_secondary[0];
				switch(_left_secondary_type) {
					case input_type.key:
						_left_secondary_value = keyboard_check(global.input_left_secondary[1]);
						break;
					case input_type.button:
						_left_secondary_value = gamepad_button_check_anypad(global.input_left_secondary[1]);
						break;
					case input_type.hat:
						_left_secondary_value = gamepad_hat_check(global.input_left_secondary[1]);
						break;
					case input_type.axis:
						_left_secondary_value = gamepad_axis_check(global.input_left_secondary[1]);
				}
			}
			if _left_primary_value || _left_secondary_value return true;
			return false;
			break;
		case input_action.right:
			var _right_primary_value = false;
			var _right_secondary_value = false;
			if global.input_right_primary != noone {
				var _right_primary_type = global.input_right_primary[0];
				// Get the value of the primary input
				switch(_right_primary_type) {
					case input_type.key:
						_right_primary_value = keyboard_check(global.input_right_primary[1]);
						break;
					case input_type.button:
						_right_primary_value = gamepad_button_check_anypad(global.input_right_primary[1]);
						break;
					case input_type.hat:
						_right_primary_value = gamepad_hat_check(global.input_right_primary[1]);
						break;
					case input_type.axis:
						_right_primary_value = gamepad_axis_check(global.input_right_primary[1]);
				}
			}
			if global.input_right_secondary != noone {
				// Get the value of the secondary input
				var _right_secondary_type = global.input_right_secondary[0];
				switch(_right_secondary_type) {
					case input_type.key:
						_right_secondary_value = keyboard_check(global.input_right_secondary[1]);
						break;
					case input_type.button:
						_right_secondary_value = gamepad_button_check_anypad(global.input_right_secondary[1]);
						break;
					case input_type.hat:
						_right_secondary_value = gamepad_hat_check(global.input_right_secondary[1]);
						break;
					case input_type.axis:
						_right_secondary_value = gamepad_axis_check(global.input_right_secondary[1]);
				}
			}
			if _right_primary_value || _right_secondary_value return true;
			return false;
			break;
		case input_action.attack:
			var _attack_primary_value = false;
			var _attack_secondary_value = false;
			if global.input_attack_primary != noone {
				var _attack_primary_type = global.input_attack_primary[0];
				// Get the value of the primary input
				switch(_attack_primary_type) {
					case input_type.key:
						_attack_primary_value = keyboard_check(global.input_attack_primary[1]);
						break;
					case input_type.button:
						_attack_primary_value = gamepad_button_check_anypad(global.input_attack_primary[1]);
						break;
					case input_type.hat:
						_attack_primary_value = gamepad_hat_check(global.input_attack_primary[1]);
						break;
					case input_type.axis:
						_attack_primary_value = gamepad_axis_check(global.input_attack_primary[1]);
				}
			}
			if global.input_attack_secondary != noone {
				var _attack_secondary_type = global.input_attack_secondary[0];
				// Get the value of the secondary input
				switch(_attack_secondary_type) {
					case input_type.key:
						_attack_secondary_value = keyboard_check(global.input_attack_secondary[1]);
						break;
					case input_type.button:
						_attack_secondary_value = gamepad_button_check_anypad(global.input_attack_secondary[1]);
						break;
					case input_type.hat:
						_attack_secondary_value = gamepad_hat_check(global.input_attack_secondary[1]);
						break;
					case input_type.axis:
						_attack_secondary_value = gamepad_axis_check(global.input_attack_secondary[1]);
				}
			}
			if _attack_primary_value || _attack_secondary_value return true;
			return false;
			break;
		case input_action.jump:
			var _jump_primary_value = false;
			var _jump_secondary_value = false;
			if global.input_jump_primary != noone {
				var _jump_primary_type = global.input_jump_primary[0];
				// Get the value of the primary input
				switch(_jump_primary_type) {
					case input_type.key:
						_jump_primary_value = keyboard_check(global.input_jump_primary[1]);
						break;
					case input_type.button:
						_jump_primary_value = gamepad_button_check_anypad(global.input_jump_primary[1]);
						break;
					case input_type.hat:
						_jump_primary_value = gamepad_hat_check(global.input_jump_primary[1]);
						break;
					case input_type.axis:
						_jump_primary_value = gamepad_axis_check(global.input_jump_primary[1]);
				}
			}
			if global.input_jump_secondary != noone {
				var _jump_secondary_type = global.input_jump_secondary[0];
				// Get the value of the secondary input
				switch(_jump_secondary_type) {
					case input_type.key:
						_jump_secondary_value = keyboard_check(global.input_jump_secondary[1]);
						break;
					case input_type.button:
						_jump_secondary_value = gamepad_button_check_anypad(global.input_jump_secondary[1]);
						break;
					case input_type.hat:
						_jump_secondary_value = gamepad_hat_check(global.input_jump_secondary[1]);
						break;
					case input_type.axis:
						_jump_secondary_value = gamepad_axis_check(global.input_jump_secondary[1]);
				}
			}
			if _jump_primary_value || _jump_secondary_value return true;
			return false;
			break;
		case input_action.sling:
			var _sling_primary_value = false;
			var _sling_secondary_value = false;
			if global.input_sling_primary != noone {
				var _sling_primary_type = global.input_sling_primary[0];
				// Get the value of the primary input
				switch(_sling_primary_type) {
					case input_type.key:
						_sling_primary_value = keyboard_check(global.input_sling_primary[1]);
						break;
					case input_type.button:
						_sling_primary_value = gamepad_button_check_anypad(global.input_sling_primary[1]);
						break;
					case input_type.hat:
						_sling_primary_value = gamepad_hat_check(global.input_sling_primary[1]);
						break;
					case input_type.axis:
						_sling_primary_value = gamepad_axis_check(global.input_sling_primary[1]);
				}
			}
			if global.input_sling_secondary != noone {
				var _sling_secondary_type = global.input_sling_secondary[0];
				// Get the value of the secondary input
				switch(_sling_secondary_type) {
					case input_type.key:
						_sling_secondary_value = keyboard_check(global.input_sling_secondary[1]);
						break;
					case input_type.button:
						_sling_secondary_value = gamepad_button_check_anypad(global.input_sling_secondary[1]);
						break;
					case input_type.hat:
						_sling_secondary_value = gamepad_hat_check(global.input_sling_secondary[1]);
						break;
					case input_type.axis:
						_sling_secondary_value = gamepad_axis_check(global.input_sling_secondary[1]);
				}
			}
			if _sling_primary_value || _sling_secondary_value return true;
			return false;
			break;
		case input_action.face:
			var _face_primary_value = false;
			var _face_secondary_value = false;
			if global.input_face_primary != noone {
				var _face_primary_type = global.input_face_primary[0];
				// Get the value of the primary input
				switch(_face_primary_type) {
					case input_type.key:
						_face_primary_value = keyboard_check(global.input_face_primary[1]);
						break;
					case input_type.button:
						_face_primary_value = gamepad_button_check_anypad(global.input_face_primary[1]);
						break;
					case input_type.hat:
						_face_primary_value = gamepad_hat_check(global.input_face_primary[1]);
						break;
					case input_type.axis:
						_face_primary_value = gamepad_axis_check(global.input_face_primary[1]);
				}
			}
			if global.input_face_secondary != noone {
				var _face_secondary_type = global.input_face_secondary[0];
				// Get the value of the secondary input
				switch(_face_secondary_type) {
					case input_type.key:
						_face_secondary_value = keyboard_check(global.input_face_secondary[1]);
						break;
					case input_type.button:
						_face_secondary_value = gamepad_button_check_anypad(global.input_face_secondary[1]);
						break;
					case input_type.hat:
						_face_secondary_value = gamepad_hat_check(global.input_face_secondary[1]);
						break;
					case input_type.axis:
						_face_secondary_value = gamepad_axis_check(global.input_face_secondary[1]);
				}
			}
			if _face_primary_value || _face_secondary_value return true;
			return false;
			break;
		case input_action.block:
			var _block_primary_value = false;
			var _block_secondary_value = false;
			if global.input_block_primary != noone {
				var _block_primary_type = global.input_block_primary[0];
				// Get the value of the primary input
				switch(_block_primary_type) {
					case input_type.key:
						_block_primary_value = keyboard_check(global.input_block_primary[1]);
						break;
					case input_type.button:
						_block_primary_value = gamepad_button_check_anypad(global.input_block_primary[1]);
						break;
					case input_type.hat:
						_block_primary_value = gamepad_hat_check(global.input_block_primary[1]);
						break;
					case input_type.axis:
						_block_primary_value = gamepad_axis_check(global.input_block_primary[1]);
				}
			}
			if global.input_block_secondary != noone {
				var _block_secondary_type = global.input_block_secondary[0];
				// Get the value of the secondary input
				switch(_block_secondary_type) {
					case input_type.key:
						_block_secondary_value = keyboard_check(global.input_block_secondary[1]);
						break;
					case input_type.button:
						_block_secondary_value = gamepad_button_check_anypad(global.input_block_secondary[1]);
						break;
					case input_type.hat:
						_block_secondary_value = gamepad_hat_check(global.input_block_secondary[1]);
						break;
					case input_type.axis:
						_block_secondary_value = gamepad_axis_check(global.input_block_secondary[1]);
				}
			}
			if _block_primary_value || _block_secondary_value return true;
			return false;
			break;
		case input_action.kick:
			var _kick_primary_value = false;
			var _kick_secondary_value = false;
			if global.input_kick_primary != noone {
				var _kick_primary_type = global.input_kick_primary[0];
				// Get the value of the primary input
				switch(_kick_primary_type) {
					case input_type.key:
						_kick_primary_value = keyboard_check(global.input_kick_primary[1]);
						break;
					case input_type.button:
						_kick_primary_value = gamepad_button_check_anypad(global.input_kick_primary[1]);
						break;
					case input_type.hat:
						_kick_primary_value = gamepad_hat_check(global.input_kick_primary[1]);
						break;
					case input_type.axis:
						_kick_primary_value = gamepad_axis_check(global.input_kick_primary[1]);
				}
			}
			if global.input_kick_secondary != noone {
				var _kick_secondary_type = global.input_kick_secondary[0];
				// Get the value of the secondary input
				switch(_kick_secondary_type) {
					case input_type.key:
						_kick_secondary_value = keyboard_check(global.input_kick_secondary[1]);
						break;
					case input_type.button:
						_kick_secondary_value = gamepad_button_check_anypad(global.input_kick_secondary[1]);
						break;
					case input_type.hat:
						_kick_secondary_value = gamepad_hat_check(global.input_kick_secondary[1]);
						break;
					case input_type.axis:
						_kick_secondary_value = gamepad_axis_check(global.input_kick_secondary[1]);
				}
			}
			if _kick_primary_value || _kick_secondary_value return true;
			return false;
			break;
		case input_action.menu:
			var _menu_primary_value = false;
			var _menu_secondary_value = false;
			if global.input_menu_primary != noone {
				var _menu_primary_type = global.input_menu_primary[0];
				// Get the value of the primary input
				switch(_menu_primary_type) {
					case input_type.key:
						_menu_primary_value = keyboard_check(global.input_menu_primary[1]);
						break;
					case input_type.button:
						_menu_primary_value = gamepad_button_check_anypad(global.input_menu_primary[1]);
						break;
					case input_type.hat:
						_menu_primary_value = gamepad_hat_check(global.input_menu_primary[1]);
						break;
					case input_type.axis:
						_menu_primary_value = gamepad_axis_check(global.input_menu_primary[1]);
				}
			}
			if global.input_menu_secondary != noone {
				var _menu_secondary_type = global.input_menu_secondary[0];
				// Get the value of the secondary input
				switch(_menu_secondary_type) {
					case input_type.key:
						_menu_secondary_value = keyboard_check(global.input_menu_secondary[1]);
						break;
					case input_type.button:
						_menu_secondary_value = gamepad_button_check_anypad(global.input_menu_secondary[1]);
						break;
					case input_type.hat:
						_menu_secondary_value = gamepad_hat_check(global.input_menu_secondary[1]);
						break;
					case input_type.axis:
						_menu_secondary_value = gamepad_axis_check(global.input_menu_secondary[1]);
				}
			}
			if _menu_primary_value || _menu_secondary_value return true;
			return false;
			break;
	}
}