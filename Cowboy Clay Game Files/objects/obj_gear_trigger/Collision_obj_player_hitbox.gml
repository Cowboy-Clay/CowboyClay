if obj_player_fighting.current_state == PlayerState.BASIC_ATTACK_SWING && !used {
	used = true
	if instance_exists(obj_moose_puppet) {
		// obj_moose_puppet.activated = true;
		//if instance_exists(obj_music_controller) obj_music_controller.switch_track(Ferrymans_Fumble);
	}
}
