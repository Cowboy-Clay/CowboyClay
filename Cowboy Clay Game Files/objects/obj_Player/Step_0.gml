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

collision_check_player(spr_player_collision, collision_mask, false, false);