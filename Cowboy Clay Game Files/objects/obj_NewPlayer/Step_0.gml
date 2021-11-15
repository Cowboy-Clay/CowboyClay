// @description All code run each frame

if !paused
{
	// Physics
	Friction(frictionValue);
	Gravity(gravityAccel, gravityMax);
	
	// State system
	UpdateState();
	StateBasedMethods();
	
	// Animation
	UpdateAnimationState();
	SwitchArmedAnims();
	PlayAnimation();
	
	obj_PlayerAttackEffect.x = x;
	obj_PlayerAttackEffect.y = y;
}
CheckEnvironCollisions(spr_Guy);