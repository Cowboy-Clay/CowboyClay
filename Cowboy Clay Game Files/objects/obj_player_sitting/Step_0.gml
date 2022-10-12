/// @description Insert description here
// You can write your code in this editor
			
// Physics
Friction(friction_get());
Gravity(gravity_get(), global.player_gravityMax, spr_clay_n_collision, collision_mask);

collision_check_player(spr_clay_n_collision, collision_mask, false, false);

animation_update();
animation_play();
SetPlayerFacingDirection();