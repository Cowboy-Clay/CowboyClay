/// @description Code to be executed when player is created

#region Master Variables
global.paused = false; // true if the game should be paused
global.showDebugMessages = true; // set to true if you want to print debug messages
#endregion

#region State Variables
enum PlayerState { IDLE, WALKING, JUMP_ANTI, JUMPING, FALLING, BASIC_ATTACK_ANTI, BASIC_ATTACK_SWING, BASIC_ATTACK_FOLLOW };
player_currentState = PlayerState.IDLE;
player_facing = Direction.RIGHT; // The direction the player is facing
player_grounded = false;
player_armed = startArmed; // Is the player armed. startArmed is set in the variable menu
#endregion

#region Physics Variables
global.player_gravityAccel = 1; // The basic rate of acceloration due to gravity
global.player_gravityMax = 20; // The basic maximum of gravity
#endregion

#region Walk Variables
global.player_frictionValue = .37; // The basic rate of friction
global.player_walkAccel = 0.6; // The basic rate of acceloration from walking
global.maxWalkSpeed = 4; // The basic max walking speed
#endregion

#region Jump Variables
player_jumpTimer = 0; // Frame counter to determine how long the player is preparing their jump
global.player_minJumpWindup = 3; // the min # of frames the player can prepare a jump
global.player_maxJumpWindup = 30; // the max # of frames the player can prepare a jump
global.player_minVertJumpForce = 15; // min vertical force applied by a jump
global.player_maxVertJumpForce = 25; // max vertical force applied by a jump
global.player_minHoriJumpForce = 0; // min horizontal force applied by a jump
global.player_maxHoriJumpForce = 10; // max horizontal force applied by a jump
#endregion

#region Basic Attack Variables
global.player_attackAntiFrames = 15; // # of frames the attack anti is shown
global.player_attackSwingFrames = 10;
global.player_attackFollowFrames = 15;
basicAttackTimer = 0; // Frame counter to determine how long the player has been in each attack state
#endregion

global.player_frictMulti_jumpAnti = .5;
global.player_frictMulti_jumping = 0.2;
global.player_frictMulti_attacking = 1;

global.player_speedMulti_jumping = 1.2;

global.player_graviMulti_attacking = 0.8;

#region Animation Variables
// Animation
player_currentAnimType = AnimationType.FIRST_FRAME;
player_animFrameCounter = 0;
player_currentFPI = 1;
// Idle animations
global.player_idleAnim = spr_player_walk;
global.player_idleAnim_disarmed = spr_player_idle_disarmed;
global.player_idleFPI = 1;
global.player_idleAnimType = AnimationType.FIRST_FRAME;
// Run animations
global.player_walkAnim = spr_player_walk;
global.player_walkAnim_disarmed = spr_player_walk_disarmed;
global.player_walkFPI = 12;
global.player_walkAnimType = AnimationType.LOOP;
// Attack animations
global.player_attackAntiAnim = spr_player_attackAnti;
global.player_attackSwingAnim = spr_player_attackSwing;
global.player_attackFollowAnim = spr_player_attackFollow;
// Jump anti anims
global.player_jumpAntiAnim = spr_player_jumpAnti;
global.player_jumpAntiAnim_disarmed = spr_player_crouch_disarmed;
global.player_jumpAntiFPI = 1;
global.player_jumpAntiAnimType = AnimationType.HOLD;
global.player_jumpAnim = spr_player_jump;
global.player_jumpAnim_disarmed = spr_player_jump_disarmed;
global.player_jumpFPI = 1;
global.player_jumpAnimType = AnimationType.HOLD;
global.player_fallAnim = spr_player_fall;
global.player_fallAnim_disarmed = spr_player_idle_disarmed;
global.player_fallFPI = 1;
global.player_fallAnimType = AnimationType.HOLD;
#endregion

#region  State Machine
function UpdatePlayerState()
{
	switch player_currentState
	{
		case PlayerState.IDLE:
			if keyboard_check_pressed(ord("X")) GoToPlayerJumpAnti();
			else if OneWalkKeyHeld() GoToPlayerWalk();
			break;
		case PlayerState.WALKING:
			if keyboard_check_pressed(ord("X")) GoToPlayerJumpAnti();
			else if !OneWalkKeyHeld() GoToPlayerIdle();
			break;
		case PlayerState.JUMP_ANTI:
			break;
		case PlayerState.JUMPING:
			if vspeed <= 0 GoToPlayerFall();
			break;
		case PlayerState.FALLING:
			if grounded
			{
				if OneWalkKeyHeld() GoToPlayerWalk();
				else GoToPlayerIdle();
			}
			break;
	}
}

function PlayerStateBasedMethods()
{
	switch player_currentState
	{
		case PlayerState.IDLE:
			PlayerAttack();
			break;
		case PlayerState.WALKING:
			PlayerWalk();
			PlayerAttack();
			break;
		case PlayerState.JUMP_ANTI:
			PlayerJumpAnti();
			break;
		case PlayerState.JUMPING:
			PlayerWalk();
			PlayerAttack();
			break;
		case PlayerState.FALLING:
			PlayerWalk();
			PlayerAttack();
			break;
		case PlayerState.BASIC_ATTACK:
			PlayerAttack();
			break;
	}
}

function GoToPlayerIdle()
{
	if global.showDebugMessages show_debug_message("Player going to idle state");
	player_currentState = PlayerState.IDLE;
	if player_armed SetAnimation(global.player_idleAnim, global.player_idleFPI, global.player_idleAnimType);
	else SetAnimation(global.player_idleAnim_disarmed, global.player_idelFPI, global.player_idleAnimType);
}
function GoToPlayerJumpAnti()
{
	if global.showDebugMessages show_debug_message("Player going to jump anticipation state");
	player_jumpTimer = 0;
	player_currentState = PlayerState.JUMP_ANTI;
	if player_armed SetAnimation(global.player_jumpAntiAnim, global.player_jumpAntiFPI, global.player_jumpAntiAnimType);
	else SetAnimation(global.player_jumpAntiAnim_disarmed, global.player_jumpAntiFPI, global.player_jumpAntiAnimType);
}
function GoToPlayerJump()
{
	if global.showDebugMessages show_debug_message("Player going to jump state");
	var l = player_jumpTimer - global.player_minJumpWindup;
	l = l / (global.player_maxJumpWindup - global.player_minJumpWindup);
	vspeed -= lerp(global.player_minVertJumpForce, global.player_maxVertJumpForce, l);
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
	player_currentState = PlayerState.JUMPING;
	
	if player_armed SetAnimation(armedJumpAnim, jumpFPI, jumpAnimType);
	else SetAnimation(disarJumpAnim, jumpFPI, jumpAnimType);
}
function GoToPlayerWalk()
{
	if global.showDebugMessages show_debug_message("Player going to walking state");
	player_currentState = PlayerState.WALKING;
	
	if player_armed SetAnimation(armedRunAnim, runFPI, runAnimType);
	else SetAnimation(disarRunAnim, runFPI,runAnimType);
}
function GoToPlayerFall()
{
	if global.showDebugMessages show_debug_message("Player going to falling state");
	player_currentState = PlayerState.FALLING;
	if player_armed SetAnimation(armedFallAnim, fallFPI, fallAnimType);
	else SetAnimation(disarFallAnim, fallFPI, fallAnimType);
}
function GoToBasicAttack()
{
	if global.showDebugMessages show_debug_message("Player going to basic attack state");
	basicAttackTimer = anticipationFrames;
	player_currentState = PlayerState.BASIC_ATTACK;
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
		GoToPlayerIdle();
	}
}
#endregion

#region Actions
function PlayerWalk()
{
	var curAc = walkAccel;
	switch player_currentState
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
	
	if abs(hspeed) > maxWalkSpeed && player_currentState != PlayerState.JUMPING && player_currentState != PlayerState.FALLING
	{
		hspeed = sign(hspeed) * maxWalkSpeed;
	}
}

function PlayerJumpAnti()
{
	jumpTimer += 1;
	if jumpTimer > maxJumpWindup || (jumpTimer > minJumpWindup && keyboard_check(ord("X")) == false)
	{
		GoToPlayerJump();
	}
}

function PlayerAttack()
{
	// If you are starting the attack
	if player_currentState != PlayerState.BASIC_ATTACK && keyboard_check_pressed(ord("Z")) && player_armed
	{
		GoToBasicAttack();
	}
	else if player_currentState == PlayerState.BASIC_ATTACK
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
			GoToPlayerIdle();
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
	if !player_armed && keyboard_check(ord("Z")) && place_meeting(x,y,obj_Sword)
	{
		obj_TestSceneController.flag = true;
		if global.showDebugMessages show_debug_message("Picked up sword");
		player_armed = true;
		instance_deactivate_object(obj_Sword);
	}
}

function PlayerGetHit()
{
	if player_armed
	{
		player_armed = false;
		instance_activate_object(obj_Sword);
		obj_Sword.Flung(obj_Moose.x);
	}
}
#endregion

#region Animation Controls
function PlayAnimation()
{
	if currentAnimType == AnimationType.FIRST_FRAME
	{
		image_index = 0;
		return;
	}
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

function SetFacingDirection()
{
	if player_currentState == PlayerState.BASIC_ATTACK || player_currentState == PlayerState.JUMPING || player_currentState == PlayerState.FALLING
		return;
	if facing == Direction.RIGHT
		image_xscale = 1;
	else image_xscale = -1;
}

function SwitchArmedAnims()
{
	if player_armed
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
	switch player_currentState
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
	switch player_currentState
	{
		case PlayerState.BASIC_ATTACK:
			g *= graviMulti_attacking;
			break;
	}
	return g;
}