// @description All code run each frame

if !global.paused
{
	// Physics
	Friction(PickPlayerFrict());
	Gravity(PickPlayerGravi(), global.player_gravityMax);
	
	// State system
	PlayerPickupSword();
	UpdatePlayerState();
	PlayerStateBasedMethods();
	
	// Animation
	SwitchPlayerArmedAnims();
	PlayPlayerAnimation();
	SetPlayerFacingDirection();
}
CheckEnvironCollisions(spr_player_collision);