// @description All code run each frame

if !global.paused
{	
	// Physics
	Friction(PickPlayerFrict());
	Gravity(PickPlayerGravi(), global.player_gravityMax, spr_player_collision, collision_mask);
	
	if currentState != PlayerState.LOCK && currentState != PlayerState.DEAD
	{
		// State system
		UpdatePlayerState();
		PlayerStateBasedMethods();
		PlayerPickupSword();
		PlayerInvulnerability();
	}
	else if currentState == PlayerState.LOCK
	{
		GoToPlayerIdle();
	}
	else if currentState == PlayerState.DEAD obj_Moose.currentState = MooseState.LOCK;
	
	if keyboard_check_pressed(ord("R"))
	{
		room_goto(asset_get_index("Menu"));
	}
	
	// Animation
	SwitchPlayerArmedAnims();
	PlayPlayerAnimation();
	SetPlayerFacingDirection();
}

collision_check(spr_player_collision, collision_mask);

if currentState == PlayerState.WALKING
{
	if armed
	{
		if audio_is_playing(sfx_player_run_armed) == false audio_play_sound(sfx_player_run_armed, 50,true);
		if audio_is_playing(sfx_player_run) audio_stop_sound(sfx_player_run);
	}
	else 
	{
		if audio_is_playing(sfx_player_run) == false audio_play_sound(sfx_player_run,50,true);
		if audio_is_playing(sfx_player_run_armed) audio_stop_sound(sfx_player_run_armed);
	}
}
else
{
	if audio_is_playing(sfx_player_run) audio_stop_sound(sfx_player_run);
	if audio_is_playing(sfx_player_run_armed) audio_stop_sound(sfx_player_run_armed);
}

if currentState == PlayerState.BASIC_ATTACK_ANTI
{
	if !audio_is_playing(sfx_sword_anti) audio_play_sound(sfx_sword_anti,50,false);
	if audio_is_playing(sfx_sword_swing) audio_stop_sound(sfx_sword_swing);
}
else if currentState == PlayerState.BASIC_ATTACK_SWING
{
	if !audio_is_playing(sfx_sword_swing) audio_play_sound(sfx_sword_swing,50,false);
	if audio_is_playing(sfx_sword_anti) audio_stop_sound(sfx_sword_anti);
}
else
{
	if audio_is_playing(sfx_sword_swing) audio_stop_sound(sfx_sword_swing);
	if audio_is_playing(sfx_sword_anti) audio_stop_sound(sfx_sword_anti);
}

CollideWithBox();