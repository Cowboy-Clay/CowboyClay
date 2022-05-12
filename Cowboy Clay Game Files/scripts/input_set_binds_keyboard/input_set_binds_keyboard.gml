function input_set_binds_keyboard(){
	show_debug_message("Switching to keyboard controls");
	
	global.input_current_setting = input_setting.keyboard;
	
	input_set_bind(input_action.left, true, input_type.key, vk_left);
	input_set_bind_unbind(input_action.left, false);
	
	input_set_bind(input_action.right, true, input_type.key, vk_right);
	input_set_bind_unbind(input_action.right, false);
	
	input_set_bind(input_action.up, true, input_type.key, vk_up);
	input_set_bind_unbind(input_action.up, false);
	
	input_set_bind(input_action.down, true, input_type.key, vk_down);
	input_set_bind_unbind(input_action.down, false);
	
	input_set_bind(input_action.attack, true, input_type.key, ord("Z"));
	input_set_bind_unbind(input_action.attack, false);
	
	input_set_bind(input_action.jump, true, input_type.key, ord("X"));
	input_set_bind_unbind(input_action.jump, false);
	
	input_set_bind(input_action.block, true, input_type.key, ord("C"));
	input_set_bind_unbind(input_action.block, false);
	
	input_set_bind(input_action.sling, true, input_type.key, ord("A"));
	input_set_bind_unbind(input_action.sling, false);
	
	input_set_bind(input_action.kick, true, input_type.key, ord("S"));
	input_set_bind_unbind(input_action.kick, false);
	
	input_set_bind(input_action.face, true, input_type.key, vk_shift);
	input_set_bind_unbind(input_action.face, false);	
}