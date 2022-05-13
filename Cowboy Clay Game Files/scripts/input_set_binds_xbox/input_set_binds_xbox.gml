function input_set_binds_xbox(){
	show_debug_message("Switching to xBox controls");
	
	global.input_current_setting = input_setting.xbox_controller;
	
	input_set_bind(input_action.left, true, input_type.button, gp_padl);
	input_set_bind(input_action.left, false, input_type.axis, "-0");
	
	input_set_bind(input_action.right, true, input_type.button, gp_padr);
	input_set_bind(input_action.right, false, input_type.axis, "+0");
	
	input_set_bind(input_action.up, true, input_type.button, gp_padu);
	input_set_bind(input_action.up, false, input_type.axis, "+1");
	
	input_set_bind(input_action.down, true, input_type.button, gp_padd);
	input_set_bind(input_action.down, false, input_type.axis, "-1");
	
	input_set_bind(input_action.attack, true, input_type.button, gp_face3);
	input_set_bind_unbind(input_action.attack, false);
	
	input_set_bind(input_action.jump, true, input_type.button, gp_face1);
	input_set_bind_unbind(input_action.jump, false);
	
	input_set_bind(input_action.block, true, input_type.button, gp_shoulderr);
	input_set_bind_unbind(input_action.block, false);
	
	input_set_bind(input_action.sling, true, input_type.button, gp_shoulderrb);
	input_set_bind_unbind(input_action.sling, false);
	
	input_set_bind(input_action.kick, true, input_type.button, gp_face2);
	input_set_bind_unbind(input_action.kick, false);
	
	input_set_bind(input_action.face, true, input_type.button, gp_shoulderlb);
	input_set_bind_unbind(input_action.face, false);	
}