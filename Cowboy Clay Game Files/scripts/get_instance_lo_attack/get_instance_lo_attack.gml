// Checks if the instance that called this is lo attacking.
// Compares the instance's object_index to a list of objects and compares its sprite to a list of applicable sprites.
// Returns true if lo attacking and false if not.
function get_instance_lo_attack(inst){
	with (inst) {
		return get_lo_attack();
	}
}