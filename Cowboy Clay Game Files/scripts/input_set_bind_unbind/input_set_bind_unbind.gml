// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function input_set_bind_unbind(_input_action, _primary){
	input_create_manager();
	switch _input_action {
		case input_action.up:
			if _primary {
				global.input_up_primary = noone;
			}else {
				global.input_up_secondary = noone;
			}
			break;
		case input_action.down:
			if _primary {
				global.input_down_primary = noone;
			}else {
				global.input_down_secondary = noone;
			}
			break;
		case input_action.left:
			if _primary {
				global.input_left_primary = noone;
			}else {
				global.input_left_secondary = noone;
			}
			break;
		case input_action.right:
			if _primary {
				global.input_right_primary = noone;
			}else {
				global.input_right_secondary = noone;
			}
			break;
		case input_action.attack:
			if _primary {
				global.input_attack_primary = noone;
			}else {
				global.input_attack_secondary = noone;
			}
			break;
		case input_action.jump:
			if _primary {
				global.input_jump_primary = noone;
			}else {
				global.input_jump_secondary = noone;
			}
			break;
		case input_action.sling:
			if _primary {
				global.input_sling_primary = noone;
			}else {
				global.input_sling_secondary = noone;
			}
			break;
		case input_action.face:
			if _primary {
				global.input_face_primary = noone;
			}else {
				global.input_face_secondary = noone;
			}
			break;
		case input_action.block:
			if _primary {
				global.input_block_primary = noone;
			}else {
				global.input_block_secondary = noone;
			}
			break;
		case input_action.kick:
			if _primary {
				global.input_kick_primary = noone;
			}else {
				global.input_kick_secondary = noone;
			}
			break;
	}
}