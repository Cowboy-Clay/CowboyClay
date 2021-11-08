// @description All code run each frame

if !paused
{
	Walk();
	Gravity(gravityAccel, gravityMax);
	UpdateAnimationState();
	PlayAnimation();
}
CheckEnvironCollisions();