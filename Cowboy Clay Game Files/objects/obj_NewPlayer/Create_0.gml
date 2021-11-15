/// @description Code to be executed when player is created

#region Master Variables
paused = false;
showDebugMessages = true;
#endregion

#region State Variables
enum PlayerState { IDLE, WALKING, JUMPING, FALLING, BASIC_ATTACK };
enum AttackSubstate { ANTICIPATION, SWING, FOLLOWTHROUGH };
currentState = PlayerState.IDLE;
currentAttackSubstate = AttackSubstate.ANTICIPATION;
facing = Direction.RIGHT;
grounded = false;
armed = startArmed;
#endregion

#region Physics Variables
gravityAccel = 3;
gravityMax = 20;
#endregion

#region Walk Variables
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
#endregion

#region Jump Variables
jumpFlag = false;
jumpWindupFlag = false;
jumpTimer = 0;
jumpWindupTime = 0;
minJumpTime = 0.1;
maxJumpTime = .5;
initialJumpForce = 20;
extendedJumpForce = 4;
jumpSpeedCurve = animcurve_get_channel(PlayerJumpCurve, 0);
#endregion

#region Basic Attack Variables
anticipationFrames = 5;
swingFrames = 18;
followthroughFrames = 8;
basicAttackTimer = 0;
#endregion

#region Animation Variables
// Animation
enum PlayerAnimationState { IDLE, RUN, ATTACK_ANTI, ATTACK_SWING, ATTACK_FOLLOW };
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
// Attack animations
attackAntiAnim = spr_Guy
attackSwingAnim = protoThrow;
attackFollowAnim = spr_FrontSlash;
#endregion

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
			Attack();
			break;
		case PlayerState.WALKING:
			Walk();
			Attack();
			break;
		case PlayerState.JUMPING:
			Jump();
			Walk();
			Attack();
			break;
		case PlayerState.FALLING:
			Walk();
			Attack();
			break;
		case PlayerState.BASIC_ATTACK:
			Attack();
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
function GoToBasicAttack()
{
	if showDebugMessages show_debug_message("Player going to basic attack state");
	basicAttackTimer = anticipationFrames;
	currentState = PlayerState.BASIC_ATTACK;
	currentAttackSubstate = AttackSubstate.ANTICIPATION;
	if basicAttackTimer <= 0
	{
		currentAttackSubstate = AttackSubstate.SWING;
		basicAttackTimer = swingFrames;
	}
	if basicAttackTimer <= 0
	{
		currentAttackSubstate = AttackSubstate.FOLLOWTHROUGH;
		basicAttackTimer = followthroughFrames;
	}
	if basicAttackTimer <= 0
	{
		GoToIdle();
	}
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

function Attack()
{
	// If you are starting the attack
	if currentState != PlayerState.BASIC_ATTACK && keyboard_check_pressed(ord("Z")) && armed
	{
		GoToBasicAttack();
	}
	else if currentState == PlayerState.BASIC_ATTACK
	{
		// Increment the attack timer
		basicAttackTimer -= 1;
		// Move through the different substates
		if currentAttackSubstate == AttackSubstate.ANTICIPATION && basicAttackTimer <= 0
		{
			currentAttackSubstate = AttackSubstate.SWING;
			basicAttackTimer = swingFrames;
		}
		if currentAttackSubstate == AttackSubstate.SWING && basicAttackTimer <= 0
		{
			currentAttackSubstate = AttackSubstate.FOLLOWTHROUGH;
			basicAttackTimer = followthroughFrames;
		}
		if currentAttackSubstate == AttackSubstate.FOLLOWTHROUGH && basicAttackTimer <= 0
		{
			GoToIdle();
		}
		
		if currentAttackSubstate == AttackSubstate.SWING obj_PlayerAttackEffect.ShowAttack(spr_FrontSlashEffect, sprite_get_number(spr_FrontSlashEffect)/swingFrames);
		else obj_PlayerAttackEffect.HideAttack();
	}
}
#endregion

#region Animation Controls
function UpdateAnimationState()
{
	if facing == Direction.RIGHT image_xscale = 1;
	else image_xscale = -1;
	
	switch animationState
	{
		case PlayerAnimationState.IDLE:
			if currentState == PlayerState.WALKING ToRunAnim();
			else if currentState == PlayerState.BASIC_ATTACK
			{
				if currentAttackSubstate == AttackSubstate.ANTICIPATION ToAttackAntiAnim();
				else if currentAttackSubstate == AttackSubstate.SWING ToAttackSwingAnim();
				else if currentAttackSubstate == AttackSubstate.FOLLOWTHROUGH ToAttackFollowAnim();
			}
			break;
		case PlayerAnimationState.RUN:
			if currentState == PlayerState.IDLE ToIdleAnim();
			else if currentState == PlayerState.BASIC_ATTACK
			{
				if currentAttackSubstate == AttackSubstate.ANTICIPATION ToAttackAntiAnim();
				else if currentAttackSubstate == AttackSubstate.SWING ToAttackSwingAnim();
				else if currentAttackSubstate == AttackSubstate.FOLLOWTHROUGH ToAttackFollowAnim();
			}
			break;
		case PlayerAnimationState.ATTACK_ANTI:
			if currentAttackSubstate == AttackSubstate.SWING ToAttackSwingAnim();
			else if currentAttackSubstate == AttackSubstate.FOLLOWTHROUGH ToAttackFollowAnim();
			else if currentState != PlayerState.BASIC_ATTACK ToIdleAnim();
			break;	
		case PlayerAnimationState.ATTACK_SWING:
			if currentAttackSubstate == AttackSubstate.FOLLOWTHROUGH ToAttackFollowAnim();
			else if currentState != PlayerState.BASIC_ATTACK ToIdleAnim();
			break;
		case PlayerAnimationState.ATTACK_FOLLOW:
			if currentState != PlayerState.BASIC_ATTACK ToIdleAnim();
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
	currentAnimType = AnimationType.LOOP;
	frameCounter = 0;
	currentFPI = runFPI;
	if armed sprite_index = armedRunAnim;
	else sprite_index = disarRunAnim;
}

function ToIdleAnim()
{
	animationState = PlayerAnimationState.IDLE;
	currentAnimType = AnimationType.HOLD;
	frameCounter = 0;
	currentFPI = idleFPI;
	if armed sprite_index = armedIdleAnim;
	else sprite_index = disarIdleAnim;
}

function ToAttackAntiAnim()
{
	animationState = PlayerAnimationState.ATTACK_ANTI;
	currentAnimType = AnimationType.HOLD;
	frameCounter = 0;
	currentFPI = sprite_get_number(attackAntiAnim) / anticipationFrames;
	sprite_index = attackAntiAnim;
}

function ToAttackSwingAnim()
{
	animationState = PlayerAnimationState.ATTACK_SWING;
	currentAnimType = AnimationType.HOLD;
	frameCounter = 0;
	currentFPI = sprite_get_number(attackSwingAnim) / swingFrames;
	sprite_index = attackSwingAnim;
}

function ToAttackFollowAnim()
{
	animationState = PlayerAnimationState.ATTACK_FOLLOW;
	currentAnimType = AnimationType.HOLD;
	frameCounter = 0;
	currentFPI = sprite_get_number(attackFollowAnim) / followthroughFrames;
	sprite_index = attackFollowAnim;
}

function SwitchArmedAnims()
{
	if armed
	{
		if sprite_index == disarRunAnim sprite_index = armedRunAnim;
		if sprite_index == disarIdleAnim sprite_index = armedIdleAnim;
	}
	else
	{
		if sprite_index == armedRunAnim sprite_index = disarRunAnim;
		if sprite_index == armedIdleAnim sprite_index = disarIdleAnim;
	}
}
#endregion





