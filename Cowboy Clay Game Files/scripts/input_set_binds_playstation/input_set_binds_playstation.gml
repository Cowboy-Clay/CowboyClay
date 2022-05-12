function input_set_binds_playstation(){
	show_debug_message("Switching to Playstation controls");
	
	global.input_current_setting = input_setting.playstation_controller;
	
	//left
	input_set_bind(input_action.left, true, input_type.hat, Direction.LEFT);
	input_set_bind(input_action.left, false, input_type.axis, "-0");
	//right
	input_set_bind(input_action.right, true, input_type.hat, Direction.RIGHT);
	input_set_bind(input_action.right, false, input_type.axis, "+0");
	//up
	input_set_bind(input_action.up, true, input_type.hat, Direction.UP);
	input_set_bind(input_action.up, false, input_type.axis, "-1");
	//down
	input_set_bind(input_action.down, true, input_type.hat, Direction.DOWN);
	input_set_bind(input_action.down, false, input_type.axis, "+1");
	//attack
	input_set_bind(input_action.attack, true, input_type.button, gp_shoulderrb);
	input_set_bind_unbind(input_action.attack, false);
	//jump
	input_set_bind(input_action.jump, true, input_type.button, gp_face2);
	input_set_bind_unbind(input_action.jump, false);
	//block
	input_set_bind(input_action.block, true, input_type.button, gp_face3);
	input_set_bind_unbind(input_action.block, false);
	//sling
	input_set_bind(input_action.sling, true, input_type.button, gp_face1);
	input_set_bind_unbind(input_action.sling, false);
	//kick
	input_set_bind(input_action.kick, true, input_type.button, gp_shoulderr);
	input_set_bind_unbind(input_action.kick, false);
	//face
	input_set_bind(input_action.face, true, input_type.button, gp_shoulderl);
	input_set_bind_unbind(input_action.face, false);	
}