/// @description Insert description here
// You can write your code in this editor

if current_state == player_neutral_states.idle or current_state == player_neutral_states.walking {
	walk();
}

if abs(hspeed) > 0.1 && current_state == player_neutral_states.idle{
	current_state = player_neutral_states.walking;
} else if abs(hspeed) <= 0.1 && current_state == player_neutral_states.walking {
	current_state = player_neutral_states.idle;
}
			
// Physics
Friction(friction_get());
Gravity(gravity_get(), global.player_gravityMax, spr_clay_n_collision, collision_mask);

collision_check_player(spr_clay_n_collision, collision_mask, false, false);

animation_update();
animation_play();
SetPlayerFacingDirection();