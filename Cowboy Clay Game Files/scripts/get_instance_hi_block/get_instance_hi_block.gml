// Checks if the instance that called this is hi blocking.
// Compares the instance's object_index to a list of objects and compares its sprite to a list of applicable sprites.
// Returns true if hi blocking and false if not.
function get_instance_hi_block(inst){
	with (inst) {
		return get_hi_block();
	}
}