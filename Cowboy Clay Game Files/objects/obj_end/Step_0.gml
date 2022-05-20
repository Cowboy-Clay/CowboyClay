if keyboard_check_pressed(vk_f11){
	window_set_fullscreen(!window_get_fullscreen());
}

image_alpha = clamp(image_alpha + 1/60, 0,1);

if keyboard_check_pressed(ord("X")) || keyboard_check_pressed(ord("B")) || gamepad_button_check_pressed(0,gp_face3) || gamepad_button_check_pressed(0,gp_face2)  || gamepad_button_check_pressed(0,gp_face4) || gamepad_button_check_pressed(0,gp_face1) {
	room_goto(Menu);
}
