if obj_player.current_state == PlayerState.BASIC_ATTACK_SWING && !used {
	used = true
	if instance_exists(obj_moose_puppet) {
		obj_moose_puppet.activated = true;
	}
}
