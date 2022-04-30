global.keybind_left = vk_left;
global.keybind_right = vk_right;
global.keybind_up = vk_up;
global.keybind_down = vk_down;

global.keybind_attack = ord("Z");
global.keybind_jump = ord("X");
global.keybind_sling = ord("A");
global.keybind_face = vk_shift;
global.keybind_block = ord("C");
global.keybind_kick = ord("S");

enum control_scheme {keyboard_and_mouse, playstation, xbox};
enum buttons {left, right, up, down, attack, jump, sling, strafe, block, kick, reset};

global.controls_keyboard_and_mouse = [vk_left, vk_right, vk_up, vk_down, ord("Z"), ord("X"), ord("A"), vk_shift, ord("C"), ord("S"), ord("T")];
global.controls_xbox_controller = [gp_padl, gp_padr, gp_padu, gp_padd, gp_shoulderrb, gp_face1, gp_face3, gp_shoulderl, gp_face2, gp_shoulderr, gp_select];
global.controls_xbox_controller_mac = [];
global.controls_playstation_controller = [gp_padl, gp_padr, gp_padu, gp_padd, gp_shoulderrb, gp_face2, gp_face1, gp_shoulderl, gp_face3, gp_shoulderr, gp_select];

function button_check(button) {
	if keyboard_check(global.controls_keyboard_and_mouse[button]) return true;
	
	var _maxpads = gamepad_get_device_count();
	for (var i = 0; i < _maxpads; i++) {
		if gamepad_button_check(i, global.controls_xbox_controller[button]) return true;
		//var _gamepad_name = gamepad_get_description(i);
		//for (var j = 0; j < array_length(global._xbox_controllers); j ++) {
		//	if _gamepad_name == global._xbox_controllers[j] {
		//		if gamepad_button_check(i, global.controls_xbox_controller[button]) return true;
		//	}
		//}
		//for (var j = 0; j < array_length(global._playstation_controllers); j ++) {
		//	if _gamepad_name == global._playstation_controllers[j] {
		//		if gamepad_button_check(i, global.controls_playstation_controller[button]) return true;
		//	}
		//}
	}
	
	return false;
}

function button_check_pressed(button) {
	if keyboard_check_pressed(global.controls_keyboard_and_mouse[button]) return true;
	
	var _maxpads = gamepad_get_device_count();
	for (var i = 0; i < _maxpads; i++) {
		if gamepad_is_connected(i) {
			if gamepad_button_check_pressed(i, global.controls_xbox_controller[button]) return true;
			//var _gamepad_name = gamepad_get_description(i);
			//for (var j = 0; j < array_length(global._xbox_controllers); j ++) {
			//	if _gamepad_name == global._xbox_controllers[j] {
			//		if gamepad_button_check_pressed(i, global.controls_xbox_controller[button]) return true;
			//	}
			//}
			//for (var j = 0; j < array_length(global._playstation_controllers); j ++) {
			//	if _gamepad_name == global._playstation_controllers[j] {
			//		if gamepad_button_check_pressed(i, global.controls_playstation_controller[button]) return true;
			//	}
			//}
		}
	}
	
	return false;
}

function button_check_released(button) {
	if keyboard_check_released(global.controls_keyboard_and_mouse[button]) return true;
	
	var _maxpads = gamepad_get_device_count();
	for (var i = 0; i < _maxpads; i++) {
		if gamepad_is_connected(i) {
			if gamepad_button_check_released(i, global.controls_xbox_controller[button]) return true;
			//var _gamepad_name = gamepad_get_description(i);if gamepad_button_check_released(i, global.controls_xbox_controller[button]) return true;
			//for (var j = 0; j < array_length(global._xbox_controllers); j ++) {
			//	if _gamepad_name == global._xbox_controllers[j] {
			//		if gamepad_button_check_released(i, global.controls_xbox_controller[button]) return true;
			//	}
			//}
			//for (var j = 0; j < array_length(global._playstation_controllers); j ++) {
			//	if _gamepad_name == global._playstation_controllers[j] {
			//		if gamepad_button_check_released(i, global.controls_playstation_controller[button]) return true;
			//	}
			//}
		}
	}
	
	return false;
}

global._xbox_controllers = ["XInput STANDARD GAMEPAD", "Xbox Wireless Controller"];
global._playstation_controllers = ["Wireless Controller"];
