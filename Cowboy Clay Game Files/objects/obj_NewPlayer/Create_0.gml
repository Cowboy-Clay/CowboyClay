/// @description Code to be executed when player is created

#region Master Variables
paused = false;
showDebugMessages = true;
#endregion

#region State Variables
enum PlayerState { IDLE, WALKING, JUMP_ANTI, JUMPING, FALLING, BASIC_ATTACK };
enum AttackSubstate { ANTICIPATION, SWING, FOLLOWTHROUGH };
currentState = PlayerState.IDLE;
currentAttackSubstate = AttackSubstate.ANTICIPATION;
facing = Direction.RIGHT;
grounded = false;
armed = startArmed;
#endregion

#region Physics Variables
gravityAccel = 1;
gravityMax = 20;
#endregion

#region Walk Variables
frictionValue = .37;
walkAccel = 0.6;
maxWalkSpeed = 4;

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
jumpTimer = 0;
minJumpWindup = 3;
maxJumpWindup = 30;
minVertJumpForce = 15;
maxVertJumpForce = 25;
minHoriJumpForce = 0;
maxHoriJumpForce = 10;
#endregion

#region Basic Attack Variables
anticipationFrames = 15;
swingFrames = 10;
followthroughFrames = 15;
basicAttackTimer = 0;
#endregion

frictMulti_jumpAnti = .5;
frictMulti_jumping = 0.2;
frictMulti_attacking = 1;

speedMulti_jumping = 1.2;

graviMulti_attacking = 0.8;

#region Animation Variables
// Animation
currentAnimType = AnimationType.LOOP;
frameCounter = 0;
currentFPI = 1;
// Idle animations
armedIdleAnim = spr_SwordIdle;
disarIdleAnim = spr_Idle
idleFPI = 1;
idleAnimType = AnimationType.HOLD;
// Run animations
armedRunAnim = SlowWalk;
disarRunAnim = spr_RunDisarmed;
runFPI = 7;
runAnimType = AnimationType.LOOP;
// Attack animations
attackAntiAnim = BigSwordAnticip;
attackSwingAnim = BigSwordSwing;
attackFollowAnim = BigSwordFollowthrough;
attackAnimType = AnimationType.HOLD;
// Jump anti anims
armedJumpAnti = jumpAnticip;
disarJumpAnti= ProtoCrouch;
jumpAntiFPI = 1;
jumpAntiAnimType = AnimationType.HOLD;
armedJumpAnim = jump;
disarJumpAnim = spr_DisarmedJumpUp;
jumpFPI = 1;
jumpAnimType = AnimationType.HOLD;
armedFallAnim = jumpFall;
disarFallAnim = jumpFall;
fallFPI = 1;
fallAnimType = AnimationType.HOLD;
#endregion

#region  State Machine
function UpdateState()
{
	switch currentState
	{
		case PlayerState.IDLE:
			if keyboard_check_pressed(ord("X")) GoToJumpAnti();
			else if OneWalkKeyHeld() GoToWalking();
			break;
		case PlayerState.WALKING:
			if keyboard_check_pressed(ord("X")) GoToJumpAnti();
			else if !OneWalkKeyHeld() GoToIdle();
			break;
		case PlayerState.JUMP_ANTI:
			break;
		case PlayerState.JUMPING:
			if vspeed <= 0 GoToFalling();
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
		case PlayerState.JUMP_ANTI:
			JumpAnti();
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
	if armed SetAnimation(armedIdleAnim, idleFPI, idleAnimType);
	else SetAnimation(disarIdleAnim, idleFPI, idleAnimType);
}
function GoToJumpAnti()
{
	if showDebugMessages show_debug_message("Player going to jump anticipation state");
	jumpTimer = 0;
	currentState = PlayerState.JUMP_ANTI;
	if armed SetAnimation(armedJumpAnti, jumpAntiFPI, jumpAntiAnimType);
	else SetAnimation(disarJumpAnti, jumpAntiFPI, jumpAntiAnimType);
}
function GoToJump()
{
	if showDebugMessages show_debug_message("Player going to jump state");
	var l = jumpTimer - minJumpWindup;
	l = l / (maxJumpWindup - minJumpWindup);
	vspeed -= lerp(minVertJumpForce, maxVertJumpForce, l);
	if OneWalkKeyHeld() && keyboard_check(vk_right)
	{
		facing = Direction.RIGHT;
		hspeed += lerp(minHoriJumpForce, maxHoriJumpForce, l);
	}
	else if OneWalkKeyHeld() && keyboard_check(vk_left)
	{
		facing = Direction.LEFT;
		hspeed -= lerp(minHoriJumpForce, maxHoriJumpForce, l);
	}
	currentState = PlayerState.JUMPING;
	
	if armed SetAnimation(armedJumpAnim, jumpFPI, jumpAnimType);
	else SetAnimation(disarJumpAnim, jumpFPI, jumpAnimType);
}
function GoToWalking()
{
	if showDebugMessages show_debug_message("Player going to walking state");
	currentState = PlayerState.WALKING;
	
	if armed SetAnimation(armedRunAnim, runFPI, runAnimType);
	else SetAnimation(disarRunAnim, runFPI,runAnimType);
}
function GoToFalling()
{
	if showDebugMessages show_debug_message("Player going to falling state");
	currentState = PlayerState.FALLING;
	if armed SetAnimation(armedFallAnim, fallFPI, fallAnimType);
	else SetAnimation(disarFallAnim, fallFPI, fallAnimType);
}
function GoToBasicAttack()
{
	if showDebugMessages show_debug_message("Player going to basic attack state");
	basicAttackTimer = anticipationFrames;
	currentState = PlayerState.BASIC_ATTACK;
	currentAttackSubstate = AttackSubstate.ANTICIPATION;
	SetAnimation(attackAntiAnim, 1, AnimationType.HOLD);
	if basicAttackTimer <= 0
	{
		currentAttackSubstate = AttackSubstate.SWING;
		SetAnimation(attackSwingAnim, 1, AnimationType.HOLD);
		basicAttackTimer = swingFrames;
	}
	if basicAttackTimer <= 0
	{
		currentAttackSubstate = AttackSubstate.FOLLOWTHROUGH;
		SetAnimation(attackFollowAnim, 1, AnimationType.HOLD);
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
	var curAc = walkAccel;
	switch currentState
	{
		case PlayerState.JUMPING:
			curAc = curAc * speedMulti_jumping;
			break;
		case PlayerState.FALLING:
			curAc = curAc * speedMulti_jumping;
			break;
	}
	// Left movement
	if keyboard_check(vk_left) && !keyboard_check(vk_right)
	{
		hspeed -= curAc;
	}
	// Right movement
	else if keyboard_check(vk_right) && !keyboard_check(vk_left)
	{
		hspeed += curAc;
	}
	
	if hspeed > 0 facing = Direction.RIGHT;
	else if hspeed < 0 facing = Direction.LEFT;
	
	if abs(hspeed) > maxWalkSpeed && currentState != PlayerState.JUMPING && currentState != PlayerState.FALLING
	{
		hspeed = sign(hspeed) * maxWalkSpeed;
	}
}

function JumpAnti()
{
	jumpTimer += 1;
	if jumpTimer > maxJumpWindup || (jumpTimer > minJumpWindup && keyboard_check(ord("X")) == false)
	{
		GoToJump();
	}
}

function Jump()
{
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
			SetAnimation(attackSwingAnim, 1, AnimationType.HOLD);
			basicAttackTimer = swingFrames;
		}
		if currentAttackSubstate == AttackSubstate.SWING && basicAttackTimer <= 0
		{
			currentAttackSubstate = AttackSubstate.FOLLOWTHROUGH;
			SetAnimation(attackFollowAnim, 1, AnimationType.HOLD);
			basicAttackTimer = followthroughFrames;
		}
		if currentAttackSubstate == AttackSubstate.FOLLOWTHROUGH && basicAttackTimer <= 0
		{
			GoToIdle();
		}
		
		if currentAttackSubstate == AttackSubstate.SWING SpawnHit(BigSwordSlash, spr_EnemySword);
		else DespawnHit();
	}
}

function SpawnHit(attackEffect, hitbox)
{
	obj_PlayerAttackEffect.ShowPlayerAttack(attackEffect, sprite_get_number(attackEffect)/swingFrames);
	obj_PlayerHitBox.SpawnPlayerHitbox(hitbox, sprite_get_number(hitbox)/swingFrames);
}
function DespawnHit()
{
	obj_PlayerAttackEffect.HidePlayerAttack();
	obj_PlayerHitBox.DespawnPlayerHitbox();
}

function PickupSword()
{
	if !armed && keyboard_check(ord("Z")) && place_meeting(x,y,obj_Sword)
	{
		obj_TestSceneController.flag = true;
		if showDebugMessages show_debug_message("Picked up sword");
		armed = true;
		instance_deactivate_object(obj_Sword);
	}
}

function PlayerGetHit()
{
	if armed
	{
		armed = false;
		instance_activate_object(obj_Sword);
		obj_Sword.Flung(obj_Moose.x);
	}
}
#endregion

#region Animation Controls
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

function SetAnimation(animation, fpi, type)
{
	sprite_index = animation;
	currentFPI = fpi;
	currentAnimType = type;
	frameCounter = 0;
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

function PickFrict()
{
	var fVal = frictionValue;
	switch currentState
	{
		case PlayerState.JUMP_ANTI:
			fVal *= frictMulti_jumpAnti;
			break;
		case PlayerState.JUMPING:
			fVal *= frictMulti_jumping;
			break;
		case PlayerState.FALLING:
			fVal *= frictMulti_jumping;
			break;
		case PlayerState.BASIC_ATTACK:
			fVal *= frictMulti_attacking;
	}
	return fVal;
}

function PickGravi()
{
	var g = gravityAccel;
	switch currentState
	{
		case PlayerState.BASIC_ATTACK:
			g *= graviMulti_attacking;
			break;
	}
	return g;
}