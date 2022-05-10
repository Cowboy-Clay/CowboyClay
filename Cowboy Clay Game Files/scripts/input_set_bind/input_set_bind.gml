// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function input_set_bind(_input_action, _primary, _input_type, _input_value){
	input_create_manager();
	switch _input_action {
		case input_action.up:
			if _primary {
				global.input_up_primary = [_input_type, _input_value];
			}else {
				global.input_up_secondary = [_input_type, _input_value];
			}
			break;
		case input_action.down:
			if _primary {
				global.input_down_primary = [_input_type, _input_value];
			}else {
				global.input_down_secondary = [_input_type, _input_value];
			}
			break;
		case input_action.left:
			if _primary {
				global.input_left_primary = [_input_type, _input_value];
			}else {
				global.input_left_secondary = [_input_type, _input_value];
			}
			break;
		case input_action.right:
			if _primary {
				global.input_right_primary = [_input_type, _input_value];
			}else {
				global.input_right_secondary = [_input_type, _input_value];
			}
			break;
		case input_action.attack:
			if _primary {
				global.input_attack_primary = [_input_type, _input_value];
			}else {
				global.input_attack_secondary = [_input_type, _input_value];
			}
			break;
		case input_action.jump:
			if _primary {
				global.input_jump_primary = [_input_type, _input_value];
			}else {
				global.input_jump_secondary = [_input_type, _input_value];
			}
			break;
		case input_action.sling:
			if _primary {
				global.input_sling_primary = [_input_type, _input_value];
			}else {
				global.input_sling_secondary = [_input_type, _input_value];
			}
			break;
		case input_action.face:
			if _primary {
				global.input_face_primary = [_input_type, _input_value];
			}else {
				global.input_face_secondary = [_input_type, _input_value];
			}
			break;
		case input_action.block:
			if _primary {
				global.input_block_primary = [_input_type, _input_value];
			}else {
				global.input_block_secondary = [_input_type, _input_value];
			}
			break;
		case input_action.kick:
			if _primary {
				global.input_kick_primary = [_input_type, _input_value];
			}else {
				global.input_kick_secondary = [_input_type, _input_value];
			}
			break;
	}
}