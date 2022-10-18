if (place_meeting(x,y,obj_player_hitbox) && obj_player_fighting.current_state == PlayerState.BASIC_ATTACK_SWING && current_state == grass_state.long) {
	current_state = grass_state.cut;
} else if (current_state == grass_state.cut) {
	cut_time --;
	if cut_time < 0 {
		current_state = grass_state.short;
	}
}

switch(current_state) {
	case grass_state.long:
		sprite_index = spr_tall;
		break;
	case grass_state.cut:
		sprite_index = spr_cut;
		break;
	case grass_state.short:
		sprite_index = spr_short;
		break;
}
