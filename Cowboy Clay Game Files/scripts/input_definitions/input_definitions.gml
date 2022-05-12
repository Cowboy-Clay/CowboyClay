enum input_type {key, button, hat, axis};
enum input_action {up, down, left, right, attack, jump, sling, face, block, kick};

enum input_setting {keyboard, xbox_controller, playstation_controller, custom};
global.input_current_setting = input_setting.keyboard;

global.input_up_primary = [input_type.key, vk_up];
global.input_up_secondary = noone;
global.input_up_value = false;
global.input_up_pressed_value = false;
global.input_up_released_value = false;

global.input_down_primary = [input_type.key, vk_down];
global.input_down_secondary = noone;
global.input_down_value = false;
global.input_down_pressed_value = false;
global.input_down_released_value = false;

global.input_left_primary = [input_type.key, vk_left];
global.input_left_secondary = noone;
global.input_left_value = false;
global.input_left_pressed_value = false;
global.input_left_released_value = false;

global.input_right_primary = [input_type.key, vk_right];
global.input_right_secondary = noone;
global.input_right_value = false;
global.input_right_pressed_value = false;
global.input_right_released_value = false;

global.input_attack_primary = [input_type.key, ord("Z")];
global.input_attack_secondary = noone;
global.input_attack_value = false;
global.input_attack_pressed_value = false;
global.input_attack_released_value = false;

global.input_jump_primary = [input_type.key, ord("X")];
global.input_jump_secondary = noone;
global.input_jump_value = false;
global.input_jump_pressed_value = false;
global.input_jump_released_value = false;

global.input_sling_primary = [input_type.key, ord("A")];
global.input_sling_secondary = noone;
global.input_sling_value = false;
global.input_sling_pressed_value = false;
global.input_sling_released_value = false;

global.input_face_primary = [input_type.key, vk_shift];
global.input_face_secondary = noone;
global.input_face_value = false;
global.input_face_pressed_value = false;
global.input_face_released_value = false;

global.input_block_primary = [input_type.key, ord("C")];
global.input_block_secondary = noone;
global.input_block_value = false;
global.input_block_pressed_value = false;
global.input_block_released_value = false;

global.input_kick_primary = [input_type.key, ord("S")];
global.input_kick_secondary = noone;
global.input_kick_value = false;
global.input_kick_pressed_value = false;
global.input_kick_released_value = false;
