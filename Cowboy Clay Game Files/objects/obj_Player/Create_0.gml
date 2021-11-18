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
global.player_maxWalkSpeed = 4; // The basic max walking speed
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
player_attackTimer = 0; // Frame counter to determine how long the player has been in each attack state
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
		case PlayerState.BASIC_ATTACK_ANTI:
			PlayerAttack();
			break;
		case PlayerState.BASIC_ATTACK_SWING:
			PlayerAttack();
			break;
		case PlayerState.BASIC_ATTACK_FOLLOW:
			PlayerAttack();
			break;
	}
}

function GoToPlayerIdle()
{
	if global.showDebugMessages show_debug_message("Player going to idle state");
	player_currentState = PlayerState.IDLE;
	if player_armed SetPlayerAnimation(global.player_idleAnim, global.player_idleFPI, global.player_idleAnimType);
	else SetPlayerAnimation(global.player_idleAnim_disarmed, global.player_idleFPI, global.player_idleAnimType);
}
function GoToPlayerJumpAnti()
{
	if global.showDebugMessages show_debug_message("Player going to jump anticipation state");
	player_jumpTimer = 0;
	player_currentState = PlayerState.JUMP_ANTI;
	if player_armed SetPlayerAnimation(global.player_jumpAntiAnim, global.player_jumpAntiFPI, global.player_jumpAntiAnimType);
	else SetPlayerAnimation(global.player_jumpAntiAnim_disarmed, global.player_jumpAntiFPI, global.player_jumpAntiAnimType);
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
		hspeed += lerp(global.player_minHoriJumpForce, global.player_maxHoriJumpForce, l);
	}
	else if OneWalkKeyHeld() && keyboard_check(vk_left)
	{
		facing = Direction.LEFT;
		hspeed -= lerp(global.player_minHoriJumpForce, global.player_maxHoriJumpForce, l);
	}
	player_currentState = PlayerState.JUMPING;
	
	if player_armed SetPlayerAnimation(global.player_jumpAnim, global.player_jumpFPI, global.player_jumpAnimType);
	else SetPlayerAnimation(global.player_jumpAnim_disarmed, global.player_jumpFPI, global.player_jumpAnimType);
}
function GoToPlayerWalk()
{
	if global.showDebugMessages show_debug_message("Player going to walking state");
	player_currentState = PlayerState.WALKING;
	
	if player_armed SetPlayerAnimation(global.player_walkAnim, global.player_walkFPI, global.player_walkAnimType);
	else SetPlayerAnimation(global.player_walkAnim_disarmed, global.player_walkFPI, global.player_walkAnimType);
}
function GoToPlayerFall()
{
	if global.showDebugMessages show_debug_message("Player going to falling state");
	player_currentState = PlayerState.FALLING;
	if player_armed SetPlayerAnimation(global.player_fallAnim, global.player_fallFPI, global.player_fallAnimType);
	else SetPlayerAnimation(global.player_fallAnim_disarmed, global.player_fallFPI, global.player_fallAnimType);
}
function GoToPlayerBasicAttack()
{
	if global.showDebugMessages show_debug_message("Player going to basic attack state");
	player_attackTimer = global.player_attackAntiFrames;
	player_currentState = PlayerState.BASIC_ATTACK_ANTI;
	SetPlayerAnimation(global.player_attackAntiAnim, 1, AnimationType.HOLD);
	if player_attackTimer <= 0
	{
		player_currentState = PlayerState.BASIC_ATTACK_SWING;
		SetPlayerAnimation(global.player_attackSwingAnim, 1, AnimationType.HOLD);
		player_attackTimer = global.player_attackSwingFrames;
	}
	if player_attackTimer <= 0
	{
		player_currentState = PlayerState.BASIC_ATTACK_FOLLOW;
		SetPlayerAnimation(global.player_attackFollowAnim, 1, AnimationType.HOLD);
		player_attackTimer = global.player_attackFollowFrames;
	}
	if player_attackTimer <= 0
	{
		GoToPlayerIdle();
	}
}
#endregion

#region Actions
function PlayerWalk()
{
	var curAc = global.player_walkAccel;
	switch player_currentState
	{
		case PlayerState.JUMPING:
			curAc = curAc * global.player_speedMulti_jumping;
			break;
		case PlayerState.FALLING:
			curAc = curAc * global.player_speedMulti_jumping;
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
	
	if hspeed > 0 player_facing = Direction.RIGHT;
	else if hspeed < 0 player_facing = Direction.LEFT;
	
	if abs(hspeed) > global.player_maxWalkSpeed && player_currentState != PlayerState.JUMPING && player_currentState != PlayerState.FALLING
	{
		hspeed = sign(hspeed) * global.player_maxWalkSpeed;
	}
}

function PlayerJumpAnti()
{
	player_jumpTimer += 1;
	if player_jumpTimer > global.player_maxJumpWindup || (player_jumpTimer > global.player_minJumpWindup && keyboard_check(ord("X")) == false)
	{
		GoToPlayerJump();
	}
}

function PlayerAttack()
{
	// If you are starting the attack
	if player_currentState != PlayerState.BASIC_ATTACK_ANTI && player_currentState != PlayerState.BASIC_ATTACK_SWING 
	&& player_currentState != PlayerState.BASIC_ATTACK_FOLLOW && keyboard_check_pressed(ord("Z")) && player_armed
	{
		GoToPlayerBasicAttack();
	}
	else if player_currentState == PlayerState.BASIC_ATTACK_ANTI || player_currentState == PlayerState.BASIC_ATTACK_SWING || player_currentState == PlayerState.BASIC_ATTACK_FOLLOW
	{
		// Increment the attack timer
		player_attackTimer -= 1;
		// Move through the different substates
		if player_currentState == PlayerState.BASIC_ATTACK_ANTI && player_attackTimer <= 0
		{
			player_currentState = PlayerState.BASIC_ATTACK_SWING;
			SetPlayerAnimation(global.player_attackSwingAnim, 1, AnimationType.HOLD);
			player_attackTimer = global.player_attackSwingFrames;
		}
		if player_currentState == PlayerState.BASIC_ATTACK_SWING && player_attackTimer <= 0
		{
			player_currentState = PlayerState.BASIC_ATTACK_FOLLOW;
			SetPlayerAnimation(global.player_attackFollowAnim, 1, AnimationType.HOLD);
			player_attackTimer = global.player_attackFollowFrames;
		}
		if player_currentState == PlayerState.BASIC_ATTACK_FOLLOW && player_attackTimer <= 0
		{
			GoToPlayerIdle();
		}
		
		if player_currentState == PlayerState.BASIC_ATTACK_SWING SpawnPlayerHit(spr_player_attackEffect, spr_player_collision);
		else DespawnPlayerHit();
	}
}

function SpawnPlayerHit(attackEffect, hitbox)
{
	obj_player_attackEffect.ShowPlayerAttack(attackEffect, sprite_get_number(attackEffect)/global.player_attackSwingFrames);
	obj_player_hitbox.SpawnPlayerHitbox(hitbox, sprite_get_number(hitbox)/global.player_attackSwingFrames);
}
function DespawnPlayerHit()
{
	obj_player_attackEffect.HidePlayerAttack();
	obj_player_hitbox.DespawnPlayerHitbox();
}

function PlayerPickupSword()
{
	if !player_armed && keyboard_check(ord("Z")) && place_meeting(x,y,obj_player_sword)
	{
		obj_sceneControl_test.flag = true;
		if global.showDebugMessages show_debug_message("Picked up sword");
		player_armed = true;
		instance_deactivate_object(obj_player_sword);
	}
}

function PlayerGetHit()
{
	if player_armed
	{
		player_armed = false;
		instance_activate_object(obj_player_sword);
		obj_player_sword.Flung(obj_Moose.x);
	}
}
#endregion

#region Animation Controls
function PlayPlayerAnimation()
{
	if player_currentAnimType == AnimationType.FIRST_FRAME
	{
		image_index = 0;
		return;
	}
	player_animFrameCounter++;
	if player_animFrameCounter >= player_currentFPI
	{
		player_animFrameCounter = 0;
		image_index ++;
		if image_index >= sprite_get_number(sprite_index)
		{
			if player_currentAnimType == AnimationType.LOOP image_index = 0;
			else if player_currentAnimType == AnimationType.HOLD image_index = sprite_get_number(sprite_index) - 1;
		}
	}
}

function SetPlayerAnimation(animation, fpi, type)
{
	sprite_index = animation;
	player_currentFPI = fpi;
	player_currentAnimType = type;
	player_animFrameCounter = 0;
}

function SetPlayerFacingDirection()
{
	if player_currentState == PlayerState.BASIC_ATTACK_ANTI || player_currentState == PlayerState.BASIC_ATTACK_SWING
	|| player_currentState == PlayerState.BASIC_ATTACK_FOLLOW|| player_currentState == PlayerState.JUMPING || player_currentState == PlayerState.FALLING
		return;
	if player_facing == Direction.RIGHT
		image_xscale = 1;
	else image_xscale = -1;
}

function SwitchPlayerArmedAnims()
{
	if player_armed
	{
		if sprite_index == global.player_walkAnim_disarmed sprite_index = global.player_walkAnim;
		if sprite_index == global.player_idleAnim_disarmed sprite_index = global.player_idleAnim;
	}
	else
	{
		if sprite_index == global.player_walkAnim sprite_index = global.player_walkAnim_disarmed;
		if sprite_index == global.player_idleAnim sprite_index = global.player_idleAnim_disarmed;
	}
}
#endregion

function PickPlayerFrict()
{
	var fVal = global.player_frictionValue;
	switch player_currentState
	{
		case PlayerState.JUMP_ANTI:
			fVal *= global.player_frictMulti_jumpAnti;
			break;
		case PlayerState.JUMPING:
			fVal *= global.player_frictMulti_jumping;
			break;
		case PlayerState.FALLING:
			fVal *= global.player_frictMulti_jumping;
			break;
		case PlayerState.BASIC_ATTACK_ANTI:
			fVal *= global.player_frictMulti_attacking;
			break;
		case PlayerState.BASIC_ATTACK_SWING:
			fVal *= global.player_frictMulti_attacking;
			break;
		case PlayerState.BASIC_ATTACK_FOLLOW:
			fVal *= global.player_frictMulti_attacking;
			break;
	}
	return fVal;
}

function PickPlayerGravi()
{
	var g = global.player_gravityAccel;
	switch player_currentState
	{
		case PlayerState.BASIC_ATTACK_ANTI:
			g *= global.player_graviMulti_attacking;
			break;
		case PlayerState.BASIC_ATTACK_SWING:
			g *= global.player_graviMulti_attacking;
			break;
		case PlayerState.BASIC_ATTACK_FOLLOW:
			g *= global.player_graviMulti_attacking;
			break;
	}
	return g;
}