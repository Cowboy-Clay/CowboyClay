// @description All code run each frame

if !global.paused
{
	if keyboard_check_pressed(ord("F"))
	{
		PlayerGetHit();
	}
	
	// Physics
	Friction(PickPlayerFrict());
	Gravity(PickPlayerGravi(), global.player_gravityMax);
	
	// State system
	PlayerPickupSword();
	UpdatePlayerState();
	PlayerStateBasedMethods();
	PlayerInvulnerability();
	
	// Animation
	SwitchPlayerArmedAnims();
	PlayPlayerAnimation();
	SetPlayerFacingDirection();
}
CheckEnvironCollisions(spr_player_collision);