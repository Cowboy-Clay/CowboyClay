if keyboard_check_pressed(ord("X")) || gamepad_button_check_pressed(0,gp_face3) {
	if array_length(sequence) == 0 {
		room_goto(FinalLevelDesign);
		return;
	}
	sprite_index = sequence[0];
	image_index = 0;
}
