//show_debug_message(instance_number(id));

while instance_number(obj_input_manager) > 1 {
	instance_destroy(obj_input_manager);
}

input_update();
