// @description All code run each frame
if input_check_pressed(input_action.menu) && instance_exists(obj_gameover) == false{
	pause_flag = true;
}

if keyboard_check_pressed(vk_f11){
	window_set_fullscreen(!window_get_fullscreen());
}

if !global.paused {	
	if sprite_index == spr_player_resurrect && image_index == 1 && audio_is_playing(sfx_player_revive) == false {
		audio_play_sound(sfx_player_revive, -2, false);
	}

	if keyboard_check_pressed(ord("P")) GoToPlayerDead();
	
	if sling_attack_charge_timer > 0 || current_state == PlayerState.SLING_ANTI {
	if(audio_is_playing(sfx_clay_sling) == false) {
		audio_play_sound(sfx_clay_sling, 5, true);
	}
	} else {
		audio_stop_sound(sfx_clay_sling);
	}
	
	lock_on();
	
	// Physics
	Friction(PickPlayerFrict());
	Gravity(PickPlayerGravi(), global.player_gravityMax, spr_clay_n_collision, collision_mask);
	
	if current_state != PlayerState.LOCK
	{
		// State system
		PlayerStateBasedMethods();
		PlayerPickupSword();
		PlayerInvulnerability();
	}
	else if current_state == PlayerState.LOCK
	{
		to_idle();
	}
	
	if keyboard_check_pressed(ord("R"))
	{
		audio_stop_all();
		room_goto(asset_get_index("LevelDesignTest"));
	}
	if keyboard_check_pressed(ord("T"))
	{
		audio_stop_all();
		room_goto(asset_get_index("PlayerTestRoom"));
	}
	
	// Animation
	update_animation();
	animation_play();
	SetPlayerFacingDirection();

	if instance_exists(obj_Moose){
		if place_meeting(x,y,obj_Moose) {
			if jump_buffer > 0 {
				knock_away_from(id,obj_Moose.x, obj_Moose.y, 20);
			} else {
				knock_away_from(id,obj_Moose.x, obj_Moose.y, 10);
			}
		}
	}
	
	collision_check_player(spr_clay_n_collision, collision_mask, false, false);
}
