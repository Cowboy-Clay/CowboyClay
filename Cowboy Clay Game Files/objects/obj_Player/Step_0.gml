// @description All code run each frame

if !paused
{
	// Physics
	Friction(PickFrict());
	Gravity(PickGravi(), gravityMax);
	
	// State system
	PickupSword();
	UpdateState();
	StateBasedMethods();
	
	// Animation
	SwitchArmedAnims();
	PlayAnimation();
	SetFacingDirection();
	
	obj_PlayerAttackEffect.x = x;
	obj_PlayerAttackEffect.y = y;
	obj_PlayerAttackEffect.image_xscale = image_xscale;
	obj_PlayerHitBox.image_xscale = image_xscale;
	obj_PlayerHitBox.x = x;
	obj_PlayerHitBox.y = y;
	
	if place_meeting(x,y,obj_EnemyHitbox) && obj_EnemyHitbox.hitting PlayerGetHit();
}
CheckEnvironCollisions(spr_Guy);