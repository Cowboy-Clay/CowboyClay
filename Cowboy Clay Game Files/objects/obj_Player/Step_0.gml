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
	
	// Animation
	SwitchPlayerArmedAnims();
	PlayPlayerAnimation();
	SetPlayerFacingDirection();
}
CheckEnvironCollisions(spr_player_collision);