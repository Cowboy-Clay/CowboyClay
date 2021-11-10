// @description All code run each frame

if !paused
{
	UpdateState();
	StateBasedMethods();
	
	
	hspeed = sign(walkingSlider) * animcurve_channel_evaluate(walkingSpeedCurve, abs(walkingSlider / timeToFullSpeed)) * fullspeedMulti;
	
	// Physics
	Gravity(gravityAccel, gravityMax);
	
	// States
	UpdateAnimationState();
	PlayAnimation();
}
CheckEnvironCollisions(spr_Guy);