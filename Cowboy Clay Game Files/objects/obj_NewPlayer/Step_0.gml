// @description All code run each frame

if !paused
{
	UpdateState();
	StateBasedMethods();
	
	Friction(frictionValue);
	
	// Physics
	Gravity(gravityAccel, gravityMax);
	
	// States
	UpdateAnimationState();
	PlayAnimation();
}
CheckEnvironCollisions(spr_Guy);