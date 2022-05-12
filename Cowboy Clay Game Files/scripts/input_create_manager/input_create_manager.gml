function input_create_manager(){
	if instance_exists(obj_input_manager) return;
	instance_create_depth(0,0,0,obj_input_manager);
}