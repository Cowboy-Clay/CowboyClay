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
}
CheckEnvironCollisions(spr_Guy);