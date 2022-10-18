frames++;

//var _maxpad = gamepad_get_device_count();

//for (var i = 0; i < _maxpad; i++) {
//	if gamepad_is_connected(i) {
//		for(var j = 32769; j <= 32788; j++) {
//			if gamepad_button_check(i,j) show_debug_message("Controller #" + string(i) + " reads button #" + string(j) + " being pushed at frame " + string(current_time) + ".");
//		}
//	}
//}

//show_debug_message("Anypad is reading " + string(gamepad_button_check_anypad(gp_face1)) + " on gp_face1.");
//show_debug_message("Anypad is reading " + string(gamepad_button_check_anypad(gp_face2)) + " on gp_face2.");
//show_debug_message("Anypad is reading " + string(gamepad_button_check_anypad(gp_face3)) + " on gp_face3.");
//show_debug_message("Anypad is reading " + string(gamepad_button_check_anypad(gp_face4)) + " on gp_face4.");
//show_debug_message("Anypad is reading " + string(gamepad_button_check_anypad(gp_shoulderrb)) + " on gp_shoulderrb.");
//show_debug_message("Anypad is reading " + string(gamepad_button_check_anypad(gp_shoulderr)) + " on gp_shoulderr.");
//show_debug_message("Anypad is reading " + string(gamepad_button_check_anypad(gp_shoulderlb)) + " on gp_shoulderlb.");
//show_debug_message("Anypad is reading " + string(gamepad_button_check_anypad(gp_shoulderl)) + " on gp_shoulderl.");

//show_debug_message("Anypad is reading " + string(gamepad_hat_check(Direction.LEFT)) + " on gp_hat_left.");
//show_debug_message("Anypad is reading " + string(gamepad_hat_check(Direction.RIGHT)) + " on gp_hat_right.");
//show_debug_message("Anypad is reading " + string(gamepad_hat_check(Direction.UP)) + " on gp_hat_up.");
//show_debug_message("Anypad is reading " + string(gamepad_hat_check(Direction.DOWN)) + " on gp_hat_down.");

//show_debug_message("Anypad is reading " + string(gamepad_axis_check("-0")) + " on axis -0.");
//show_debug_message("Anypad is reading " + string(gamepad_axis_check("+0")) + " on axis +0.");
//show_debug_message("Anypad is reading " + string(gamepad_axis_check("-1")) + " on axis -1.");
//show_debug_message("Anypad is reading " + string(gamepad_axis_check("+1")) + " on axis +1.");

//show_debug_message("Left: " + string(input_check(input_action.left)));
//show_debug_message("Left_Pressed: " + string(input_check_pressed(input_action.left)));
//show_debug_message("Left_released: " + string(input_check_released(input_action.left)));

if keyboard_check_pressed(vk_f1) {
	if room_get_name(room) == "FinalLevelDesign" && frames> 30{
		obj_player_fighting.x = 7008;
		obj_player_fighting.y = 704;
	}
}
