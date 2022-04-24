// @description All code run each frame

if sling_attack_charge_timer > 0 || current_state == PlayerState.SLING_ANTI {
	if(audio_is_playing(sfx_clay_sling) == false) {
		audio_play_sound(sfx_clay_sling, 5, true);
	}
} else {
	audio_stop_sound(sfx_clay_sling);
}

if !global.paused
{	
	// Physics
	Friction(PickPlayerFrict());
	Gravity(PickPlayerGravi(), global.player_gravityMax, spr_player_collision, collision_mask);
	
	jump_buffer--;
	
	if current_state != PlayerState.LOCK && current_state != PlayerState.DEAD
	{
		// State system
		PlayerStateBasedMethods();
		PlayerPickupSword();
		PlayerInvulnerability();
	}
	else if current_state == PlayerState.LOCK
	{
		GoToPlayerIdle();
	}
	else if current_state == PlayerState.DEAD obj_Moose.current_state = MooseState.LOCK;
	
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
	PlayPlayerAnimation();
	SetPlayerFacingDirection();
}

if instance_exists(obj_Moose){
	if place_meeting(x,y,obj_Moose) {
		if jump_buffer > 0 {
			knock_away_from(id,obj_Moose.x, obj_Moose.y, 20);
		} else {
			knock_away_from(id,obj_Moose.x, obj_Moose.y, 10);
		}
	}
}
collision_check_player(spr_player_collision, collision_mask, false, false);