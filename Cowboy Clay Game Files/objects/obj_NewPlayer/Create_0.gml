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
// Full right is when walkingSlider/timeToFullSpeed == 1
// Full left is when walkingSlider/timeToFullSpeed == -1
walkingSlider = 0;
timeToFullSpeed = .5;
walkingSpeedCurve = animcurve_get_channel(WalkingSpeedCurve, 0);
fullspeedMulti = 20;
walkingFrictionMulti = .85;

// Jumping
jumpFlag = false;
jumpTimer = 0;
minJumpTime = 0.1;
maxJumpTime = .5;
initialJumpForce = 25;
extendedJumpForce = 5;
jumpSpeedCurve = animcurve_get_channel(PlayerJumpCurve, 0);

// Animation
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
		if walkingSlider > 0 && grounded Friction();
		walkingSlider -= delta_time /1000000;
		if collision_point(x-(sprite_get_width(spr_Guy)/2),y,obj_Wall,false,true) walkingSlider = 0;
	}
	// Right movement
	else if keyboard_check(vk_right) && !keyboard_check(vk_left)
	{
		facing = Direction.RIGHT;
		if walkingSlider < 0 && grounded Friction();
		walkingSlider += delta_time / 1000000;
		if collision_point(x+(sprite_get_width(spr_Guy)/2),y,obj_Wall,false,true) walkingSlider = 0;
	}
	// Friction if not walking
	else Friction();
	
	// Max out walkingSlider
	if abs(walkingSlider) > timeToFullSpeed walkingSlider = sign(walkingSlider) * timeToFullSpeed;

	// Print walkingSlider
	if showDebugMessages 
	{
		show_debug_message(walkingSlider);
		show_debug_message(hspeed);
	}
}

function Friction()
{
	walkingSlider *= walkingFrictionMulti;
}

function Jump()
{
	jumpTimer += delta_time / 1000000;
	vspeed -= extendedJumpForce * animcurve_channel_evaluate(jumpSpeedCurve, jumpTimer/maxJumpTime);
}

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
				if jumpFlag jumpFlag = false;
				else
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

function GoToIdle()
{
	if showDebugMessages show_debug_message("Player going to idle state");
	currentState = PlayerState.IDLE;
}
function GoToJumping()
{
	if showDebugMessages show_debug_message("Player going to jumping state");
	jumpFlag = true;
	jumpTimer = 0;
	vspeed -= initialJumpForce;
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

function StateBasedMethods()
{
	switch currentState
	{
		case PlayerState.IDLE:
			Friction();
			break;
		case PlayerState.WALKING:
			Walk();
			break;
		case PlayerState.JUMPING:
			Jump();
			Walk();
			break;
	}
}