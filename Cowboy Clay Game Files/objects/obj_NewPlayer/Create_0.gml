/// @description Code to be executed when player is created

//Master variables
paused = false;
showDebugMessages = false;

// State variables
enum PlayerState { IDLE, WALKING, JUMPING, FALLING };
currentState = PlayerState.IDLE;
facing = Direction.RIGHT;
grounded = false;
armed = startArmed;

gravityAccel = 3;
gravityMax = 20;

// Walking
frictionValue = .67;
walkAccel = 1;
maxWalkSpeed = 12;

//walkingSlider = 0;
//timeToFullSpeed = .6;
//walkingSpeedCurve = animcurve_get_channel(bumpy_trot, 0);
//fullspeedMulti = 6;
//walkingFrictionMulti = 0.85;

//walkingSlider = 0;
//timeToFullSpeed = 0.3;
//walkingSpeedCurve = animcurve_get_channel(WalkingSpeedCurve, 0);
//fullspeedMulti = 18;
//walkingFrictionMulti = 0.92;

// Jumping
jumpFlag = false;
jumpWindupFlag = false;
jumpTimer = 0;
jumpWindupTime = 0;
minJumpTime = 0.1;
maxJumpTime = .5;
initialJumpForce = 20;
extendedJumpForce = 4;
jumpSpeedCurve = animcurve_get_channel(PlayerJumpCurve, 0);

// Animation
enum PlayerAnimationState { IDLE, RUN };
animationState = PlayerAnimationState.IDLE;
currentAnimType = AnimationType.LOOP;
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

#region  State Machine
function UpdateState()
{
	switch currentState
	{
		case PlayerState.IDLE:
			if keyboard_check_pressed(ord("X")) GoToJumping();
			else if OneWalkKeyHeld() GoToWalking();
			break;
		case PlayerState.WALKING:
			if keyboard_check_pressed(ord("X")) GoToJumping();
			else if !OneWalkKeyHeld() GoToIdle();
			break;
		case PlayerState.JUMPING:
			if grounded
			{
				if jumpFlag && !jumpWindupFlag jumpFlag = false;
				else if !jumpFlag && !jumpWindupFlag
				{
					if OneWalkKeyHeld() GoToWalking();
					else GoToIdle();
				}
			}
			else if jumpTimer >= maxJumpTime || (jumpTimer > minJumpTime && !keyboard_check(ord("X")))
			{
				GoToFalling();
			}
			break;
		case PlayerState.FALLING:
			if grounded
			{
				if OneWalkKeyHeld() GoToWalking();
				else GoToIdle();
			}
			break;
	}
}

function StateBasedMethods()
{
	switch currentState
	{
		case PlayerState.IDLE:
			break;
		case PlayerState.WALKING:
			Walk();
			break;
		case PlayerState.JUMPING:
			Jump();
			Walk();
			break;
		case PlayerState.FALLING:
			Walk();
			break;
	}
}

function GoToIdle()
{
	if showDebugMessages show_debug_message("Player going to idle state");
	currentState = PlayerState.IDLE;
}
function GoToJumping()
{
	if showDebugMessages show_debug_message("Player going to jumping state");
	jumpFlag = true;
	jumpWindupFlag = true;
	jumpTimer = 0;
	currentState = PlayerState.JUMPING;
}
function GoToWalking()
{
	if showDebugMessages show_debug_message("Player going to walking state");
	currentState = PlayerState.WALKING;
}
function GoToFalling()
{
	if showDebugMessages show_debug_message("Player going to falling state");
	currentState = PlayerState.FALLING;
}
#endregion

#region Actions
function Walk()
{
	// Left movement
	if keyboard_check(vk_left) && !keyboard_check(vk_right)
	{
		hspeed -= walkAccel;
	}
	// Right movement
	else if keyboard_check(vk_right) && !keyboard_check(vk_left)
	{
		hspeed += walkAccel;
	}
	
	if hspeed > 0 facing = Direction.RIGHT;
	else if hspeed < 0 facing = Direction.LEFT;
	
	if abs(hspeed) > maxWalkSpeed
	{
		hspeed = sign(hspeed) * maxWalkSpeed;
	}
}

function Jump()
{
	show_debug_message("Counting jump");
	jumpTimer += delta_time / 1000000;
	if jumpWindupFlag && jumpTimer >= jumpWindupTime
	{
		jumpWindupFlag = false;
		jumpTimer = 0;
		vspeed -= initialJumpForce;
	}
	else if !jumpWindupFlag
		vspeed -= extendedJumpForce * animcurve_channel_evaluate(jumpSpeedCurve, jumpTimer/maxJumpTime);
}
#endregion

#region Animation Controlls
function UpdateAnimationState()
{
	if facing == Direction.RIGHT image_xscale = 1;
	else image_xscale = -1;
	
	switch animationState
	{
		case PlayerAnimationState.IDLE:
			if currentState == PlayerState.WALKING ToRunAnim();
			break;
		case PlayerAnimationState.RUN:
			if currentState == PlayerState.IDLE ToIdleAnim();
			break;
	}
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
			if currentAnimType == AnimationType.LOOP image_index = 0;
			else if currentAnimType == AnimationType.HOLD image_index = sprite_get_number(sprite_index) - 1;
		}
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
#endregion





