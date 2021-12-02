// @description All code run each frame

if !global.paused
{	
	// Physics
	Friction(PickPlayerFrict());
	Gravity(PickPlayerGravi(), global.player_gravityMax);
	
	if currentState != PlayerState.LOCK && currentState != PlayerState.DEAD
	{
		// State system
		PlayerPickupSword();
		UpdatePlayerState();
		PlayerStateBasedMethods();
		PlayerInvulnerability();
	}
	else if currentState == PlayerState.LOCK
	{
		GoToPlayerIdle();
	}
	else if currentState == PlayerState.DEAD obj_Moose.currentState = MooseState.LOCK;
	
	if keyboard_check_pressed(ord("R")) && (currentState == PlayerState.DEAD || obj_Moose.currentState == MooseState.DEAD)
	{
		room_restart();
	}
	
	// Animation
	SwitchPlayerArmedAnims();
	PlayPlayerAnimation();
	SetPlayerFacingDirection();
}
CheckEnvironCollisions(spr_player_collision);