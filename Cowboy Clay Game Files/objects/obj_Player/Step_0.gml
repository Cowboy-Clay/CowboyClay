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
	
	obj_player_attackEffect.x = x;
	obj_player_attackEffect.y = y;
	obj_player_attackEffect.image_xscale = image_xscale;
	obj_player_hitbox.image_xscale = image_xscale;
	obj_player_hitbox.x = x;
	obj_player_hitbox.y = y;
}
CheckEnvironCollisions(spr_player_collision);