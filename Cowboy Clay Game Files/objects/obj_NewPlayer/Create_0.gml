/// @description Code to be executed when player is created

//Master variables
paused = false;

// State variables
facing = Direction.RIGHT;
grounded = false;
armed = startArmed;

gravityAccel = 1;
gravityMax = 20;

// Full right is when walkingSlider/timeToFullSpeed == 1
// Full left is when walkingSlider/timeToFullSpeed == -1
walkingSlider = 0;
timeToFullSpeed = .5;
walkingSpeedCurve = animcurve_get_channel(WalkingSpeedCurve, 0);
fullspeedMulti = 10;
walkingFrictionMulti = .85;

enum PlayerAnimationState { IDLE, RUN };
animationState = PlayerAnimationState.IDLE;
frameCounter = 0;
currentFPI = 1;
// Idle animations
armedIdleAnim = spr_SwordIdle;
disarIdleAnim = spr_Idle
idleFPI = 1;
// Run animations
armedRunAnim = spr_Run;
disarRunAnim = spr_RunDisarmed;
runFPI = 7;

function Walk()
{
	// Left movement
	if keyboard_check(vk_left) && !keyboard_check(vk_right)
	{
		facing = Direction.LEFT;
		if walkingSlider > 0 && grounded walkingSlider *= walkingFrictionMulti;
		walkingSlider -= delta_time /1000000;
	}
	// Right movement
	else if keyboard_check(vk_right) && !keyboard_check(vk_left)
	{
		facing = Direction.RIGHT;
		if walkingSlider < 0 && grounded walkingSlider *= walkingFrictionMulti;
		walkingSlider += delta_time / 1000000;
	}
	// No movement
	else if grounded
	{
		walkingSlider *= walkingFrictionMulti;
	}
	
	hspeed = sign(walkingSlider) * animcurve_channel_evaluate(walkingSpeedCurve, abs(walkingSlider / timeToFullSpeed)) * fullspeedMulti;
}

function UpdateAnimationState()
{
	if facing == Direction.RIGHT image_xscale = 1;
	else image_xscale = -1;
	
	switch animationState
	{
		case PlayerAnimationState.IDLE:
			if abs(hspeed) > 3 && grounded ToRunAnim();
			break;
		case PlayerAnimationState.RUN:
			if abs(hspeed) < 3 && grounded ToIdleAnim();
			break;
	}
}

function ToRunAnim()
{
	animationState = PlayerAnimationState.RUN;
	frameCounter = 0;
	currentFPI = runFPI;
	if armed sprite_index = armedRunAnim;
	else sprite_index = disarRunAnim;
}

function ToIdleAnim()
{
	animationState = PlayerAnimationState.IDLE;
	frameCounter = 0;
	currentFPI = idleFPI;
	if armed sprite_index = armedIdleAnim;
	else sprite_index = disarIdleAnim;
}

function PlayAnimation()
{
	frameCounter++;
	if frameCounter >= currentFPI
	{
		frameCounter = 0;
		image_index ++;
		if image_index >= sprite_get_number(sprite_index)
		{
			image_index = 0;
		}
	}
}