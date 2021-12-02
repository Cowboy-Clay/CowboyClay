/// @description Code to be executed when player is created

#region Master Variables
global.paused = false; // true if the game should be paused
global.showDebugMessages = true; // set to true if you want to print debug messages
#endregion

#region State Variables
enum PlayerState { IDLE, WALKING, JUMP_ANTI, JUMPING, FALLING, BASIC_ATTACK_ANTI, BASIC_ATTACK_SWING, BASIC_ATTACK_FOLLOW, DASH_ANTI, DASH, DASH_FOLLOW, LOCK, DEAD };
currentState = PlayerState.LOCK;
facing = Direction.RIGHT; // The direction the player is facing
armed = startArmed; // Is the player armed. startArmed is set in the variable menu
grounded = false;
#endregion

#region Physics Variables
global.player_gravityAccel = 1; // The basic rate of acceloration due to gravity
global.player_gravityMax = 20; // The basic maximum of gravity
#endregion

#region Walk Variables
global.player_frictionValue = .45; // The basic rate of friction
global.player_walkAccel = 0.6; // The basic rate of acceloration from walking
global.player_maxWalkSpeed = 4; // The basic max walking speed
#endregion

#region Dash Variables
dashTimer = 0;
lastDashTapDirection = Direction.LEFT;
dashOnCooldown = false;
global.player_dashAnticipation = 45;
global.player_dashFrameAllowance = 15;
global.player_dashImpulseForce = 45;
global.player_dashExtendForce = 22;
global.player_dashEndForce = 15;
global.player_instantDash = true;
global.player_dashDuration = 10;
global.player_dashCooldown = 20;
global.player_invulnWhileDashing = true;
global.player_dashFollow = 38;
#endregion

#region Jump Variables
jumpTimer = 0; // Frame counter to determine how long the player is preparing their jump
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
attackTimer = 0; // Frame counter to determine how long the player has been in each attack state
#endregion

invulnerable = false;
invulnerabilityTimer = 0;
global.player_invulnerabilityTime = 60;

global.player_frictMulti_jumpAnti = .5;
global.player_frictMulti_jumping = 0.2;
global.player_frictMulti_attacking = 1;

global.player_speedMulti_jumping = 1;
global.player_speedMulti_falling = 0.3;

global.player_graviMulti_attacking = 0.8;

#region Animation Variables
// Animation
currentAnimType = AnimationType.FIRST_FRAME;
animFrameCounter = 0;
currentFPI = 1;

#endregion

#region  State Machine
function UpdatePlayerState()
{
	switch currentState
	{
		case PlayerState.IDLE:
			if keyboard_check(vk_down) && keyboard_check_pressed(ord("X")) && !dashOnCooldown
			{
				GoToDashAnti();
				return;
			}
			if keyboard_check_pressed(ord("X")) GoToPlayerJumpAnti();
			else if OneWalkKeyHeld() GoToPlayerWalk();
			break;
		case PlayerState.WALKING:
			if keyboard_check(vk_down) && keyboard_check_pressed(ord("X")) && !dashOnCooldown
			{
				GoToDashAnti();
				return;
			}
			if keyboard_check_pressed(ord("X")) GoToPlayerJumpAnti();
			else if !OneWalkKeyHeld() GoToPlayerIdle();
			break;
		case PlayerState.JUMP_ANTI:
			if keyboard_check(vk_down) && keyboard_check_pressed(ord("X")) && !dashOnCooldown
			{
				GoToDashAnti();
				return;
			}
			break;
		case PlayerState.JUMPING:
			if vspeed >= 0 GoToPlayerFall();
			break;
		case PlayerState.FALLING:
			if grounded
			{
				if OneWalkKeyHeld() GoToPlayerWalk();
				else GoToPlayerIdle();
			}
			break;
		case PlayerState.DASH_ANTI:
			dashTimer ++;
			if dashTimer >= global.player_dashAnticipation GoToDash();
			break;
		case PlayerState.DASH_FOLLOW:
			dashTimer ++;
			if dashTimer >= global.player_dashFollow GoToPlayerIdle();
			break;
	}
}

function PlayerStateBasedMethods()
{
	switch currentState
	{
		case PlayerState.IDLE:
			PlayerDashCooldown();
			PlayerAttack();
			break;
		case PlayerState.WALKING:
			PlayerDashCooldown();
			PlayerWalk();
			PlayerAttack();
			break;
		case PlayerState.JUMP_ANTI:
			PlayerDashCooldown();
			PlayerAttack();
			PlayerJumpAnti();
			SetPlayerFacingBasedOnSprite();
			break;
		case PlayerState.JUMPING:
			PlayerDashCooldown();
			PlayerWalk();
			PlayerAttack();
			SetPlayerFacingBasedOnSprite();
			break;
		case PlayerState.FALLING:
			PlayerDashCooldown();
			PlayerWalk();
			PlayerAttack();
			SetPlayerFacingBasedOnSprite();
			break;
		case PlayerState.BASIC_ATTACK_ANTI:
			PlayerDashCooldown();
			PlayerAttack();
			break;
		case PlayerState.BASIC_ATTACK_SWING:
			PlayerDashCooldown();
			PlayerAttack();
			break;
		case PlayerState.BASIC_ATTACK_FOLLOW:
			PlayerDashCooldown();
			PlayerAttack();
			break;
		case PlayerState.DASH_ANTI:
			break;
		case PlayerState.DASH:
			PlayerDash();
			break;
	}
}

function GoToPlayerDead()
{
	currentState = PlayerState.DEAD;
	instance_deactivate_object(obj_player_hitbox);
	instance_deactivate_object(obj_player_hurtbox);
	SetPlayerAnimation(global.player_deathAnim, global.player_deathAnimFPI, global.player_deadAnimType);
}

function GoToPlayerIdle()
{
	if global.showDebugMessages show_debug_message("Player going to idle state");
	currentState = PlayerState.IDLE;
	if armed SetPlayerAnimation(global.player_idleAnim, global.player_idleFPI, global.player_idleAnimType);
	else SetPlayerAnimation(global.player_idleAnim_disarmed, global.player_idleFPI, global.player_idleAnimType);
}
function GoToPlayerJumpAnti()
{
	if global.showDebugMessages show_debug_message("Player going to jump anticipation state");
	jumpTimer = 0;
	currentState = PlayerState.JUMP_ANTI;
	if armed SetPlayerAnimation(global.player_jumpAntiAnim, global.player_jumpAntiFPI, global.player_jumpAntiAnimType);
	else SetPlayerAnimation(global.player_jumpAntiAnim_disarmed, global.player_jumpAntiFPI, global.player_jumpAntiAnimType);
}
function GoToPlayerJump()
{
	if global.showDebugMessages show_debug_message("Player going to jump state");
	var l = jumpTimer - global.player_minJumpWindup;
	l = l / (global.player_maxJumpWindup - global.player_minJumpWindup);
	vspeed -= lerp(global.player_minVertJumpForce, global.player_maxVertJumpForce, l);
	if OneWalkKeyHeld() && keyboard_check(vk_right)
	{
		hspeed += lerp(global.player_minHoriJumpForce, global.player_maxHoriJumpForce, l);
	}
	else if OneWalkKeyHeld() && keyboard_check(vk_left)
	{
		hspeed -= lerp(global.player_minHoriJumpForce, global.player_maxHoriJumpForce, l);
	}
	currentState = PlayerState.JUMPING;
	
	if armed SetPlayerAnimation(global.player_jumpAnim, global.player_jumpFPI, global.player_jumpAnimType);
	else SetPlayerAnimation(global.player_jumpAnim_disarmed, global.player_jumpFPI, global.player_jumpAnimType);
}
function GoToPlayerWalk()
{
	if global.showDebugMessages show_debug_message("Player going to walking state");
	currentState = PlayerState.WALKING;
	
	if keyboard_check(vk_left) lastDashTapDirection = Direction.LEFT;
	else if keyboard_check(vk_right) lastDashTapDirection = Direction.RIGHT;
	
	if armed SetPlayerAnimation(global.player_walkAnim, global.player_walkFPI, global.player_walkAnimType);
	else SetPlayerAnimation(global.player_walkAnim_disarmed, global.player_walkFPI, global.player_walkAnimType);
}
function GoToPlayerFall()
{
	if global.showDebugMessages show_debug_message("Player going to falling state");
	currentState = PlayerState.FALLING;
	if armed SetPlayerAnimation(global.player_fallAnim, global.player_fallFPI, global.player_fallAnimType);
	else SetPlayerAnimation(global.player_fallAnim_disarmed, global.player_fallFPI, global.player_fallAnimType);
}
function GoToPlayerBasicAttack()
{
	if global.showDebugMessages show_debug_message("Player going to basic attack state");
	attackTimer = global.player_attackAntiFrames;
	currentState = PlayerState.BASIC_ATTACK_ANTI;
	SetPlayerAnimation(global.player_attackAntiAnim, 1, AnimationType.HOLD);
	if attackTimer <= 0
	{
		currentState = PlayerState.BASIC_ATTACK_SWING;
		SetPlayerAnimation(global.player_attackSwingAnim, 1, AnimationType.HOLD);
		attackTimer = global.player_attackSwingFrames;
	}
	if attackTimer <= 0
	{
		currentState = PlayerState.BASIC_ATTACK_FOLLOW;
		SetPlayerAnimation(global.player_attackFollowAnim, 1, AnimationType.HOLD);
		attackTimer = global.player_attackFollowFrames;
	}
	if attackTimer <= 0
	{
		GoToPlayerIdle();
	}
}

function GoToDashAnti()
{
	if global.showDebugMessages show_debug_message("Player going to dash anti state");
	currentState = PlayerState.DASH_ANTI;
	
	var a = global.player_dashAntiAnim;
	if !armed a = global.player_dashAntiAnim_disarmed;
	SetPlayerAnimation(a, global.player_dashAntiAnimFPI, global.player_dashAntiAnimType);
	
	dashTimer = 0;
}

function GoToDash()
{
	if global.showDebugMessages show_debug_message("Player going to dash state");
	currentState = PlayerState.DASH;
	
	var a = global.player_dashAnim;
	if !armed a = global.player_dashAnim_disarmed;
	SetPlayerAnimation(a, global.player_dashAnimFPI, global.player_dashAnimType);
	
	dashTimer = 0;
	dashOnCooldown = true;
	
	if global.player_instantDash
	{
		if facing == Direction.LEFT
		{
			for (i = x-1; i > x -global.player_dashImpulseForce; i--)
			{
				if place_meeting(i,y,obj_Wall)
				{
					x = i + 1;
					GoToPlayerIdle();
					return;
				}
			}
		}
		else
		{
			for (i = x+1; i < x + global.player_dashImpulseForce; i++)
			{
				if place_meeting(i,y, obj_Wall)
				{
					x = i - 1;
					GoToPlayerIdle();
					return;
				}
			}
		}
		
		if facing == Direction.LEFT x -= global.player_dashImpulseForce;
		else x += global.player_dashImpulseForce;
		return;
	}
	
	if facing == Direction.LEFT hspeed = - global.player_dashImpulseForce;
	else hspeed = global.player_dashImpulseForce;
}

function GoToPlayerDashFollow()
{
	if global.showDebugMessages show_debug_message("Player going to dash follow through");
	dashTimer = 0;
	currentState = PlayerState.DASH_FOLLOW;
	
	var a = global.player_dashFollowAnim;
	if !armed a = global.player_dashFollowAnim_disarmed;
	SetPlayerAnimation(a, global.player_dashFollowAnimFPI, global.player_dashFollowAnimType);
}

function CheckDash()
{
	if dashOnCooldown
	{
		show_debug_message(dashTimer);
		show_debug_message(global.player_dashCooldown);
		dashTimer ++;
		if dashTimer >= global.player_dashCooldown
		{
			dashTimer = 0;
			dashOnCooldown = false;
		}
		return;
	}
	
	if keyboard_check_pressed(vk_left)
	{
		if lastDashTapDirection == Direction.LEFT && dashTimer <= global.player_dashFrameAllowance && dashTimer != 0
		{
			GoToDash();
		}
		else
		{
			dashTimer = 0;
			lastDashTapDirection = Direction.LEFT;
		}
	}
	else if keyboard_check_pressed(vk_right)
	{
		if lastDashTapDirection == Direction.RIGHT && dashTimer <= global.player_dashFrameAllowance && dashTimer != 0
		{
			GoToDash();
		}
		else
		{
			dashTimer = 0;
			lastDashTapDirection = Direction.RIGHT;
		}
	}
	
	dashTimer ++;
}
#endregion

#region Actions
function PlayerWalk()
{
	var curAc = global.player_walkAccel;
	
	switch currentState
	{
		case PlayerState.JUMPING:
			curAc = curAc * global.player_speedMulti_jumping;
			break;
		case PlayerState.FALLING:
			curAc = curAc * global.player_speedMulti_falling;
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
	
	if hspeed > 0 && keyboard_check(vk_right) facing = Direction.RIGHT;
	else if hspeed < 0 && keyboard_check(vk_left) facing = Direction.LEFT;
	
	if abs(hspeed) > global.player_maxWalkSpeed && currentState != PlayerState.JUMPING && currentState != PlayerState.FALLING
	{
		hspeed = sign(hspeed) * lerp(abs(hspeed), global.player_maxWalkSpeed, .2);
		//hspeed = sign(hspeed) * global.player_maxWalkSpeed;
	}
}

function PlayerDash()
{
	dashTimer ++;
	if dashTimer >= global.player_dashDuration
	{
		dashTimer = 0;
		if facing == Direction.LEFT hspeed = - global.player_dashEndForce;
		else hspeed = global.player_dashEndForce;
		while place_meeting(x,y,obj_Moose)
		{
			if facing == Direction.LEFT x --;
			else x++;
		}
		invulnerable = false;
		GoToPlayerDashFollow();
		return;
	}
	if global.player_instantDash
	{
		if facing == Direction.LEFT
		{
			for (i = x-1; i > x -global.player_dashExtendForce; i--)
			{
				if place_meeting(i,y,obj_Wall)
				{
					x = i + 1;
					GoToPlayerDashFollow();
					return;
				}
			}
		}
		else
		{
			for (i = x+1; i < x + global.player_dashExtendForce; i++)
			{
				if place_meeting(i,y, obj_Wall)
				{
					x = i - 1;
					GoToPlayerIdle();
					return;
				}
			}
		}
		
		if facing == Direction.LEFT x -= global.player_dashExtendForce;
		else x += global.player_dashExtendForce;
		return;
	}
	if facing == Direction.LEFT hspeed = -global.player_dashExtendForce;
	else hspeed = global.player_dashExtendForce;
}

function PlayerDashCooldown()
{
	if !dashOnCooldown return;
	dashTimer ++;
	if dashTimer >= global.player_dashCooldown
	{
		dashOnCooldown = false;
	}
}

function PlayerJumpAnti()
{
	jumpTimer += 1;
	if jumpTimer > global.player_maxJumpWindup || (jumpTimer > global.player_minJumpWindup && keyboard_check(ord("X")) == false)
	{
		GoToPlayerJump();
	}
}

function PlayerAttack()
{
	// If you are starting the attack
	if currentState != PlayerState.BASIC_ATTACK_ANTI && currentState != PlayerState.BASIC_ATTACK_SWING 
	&& currentState != PlayerState.BASIC_ATTACK_FOLLOW && keyboard_check_pressed(ord("Z")) && armed
	{
		GoToPlayerBasicAttack();
	}
	else if currentState == PlayerState.BASIC_ATTACK_ANTI || currentState == PlayerState.BASIC_ATTACK_SWING || currentState == PlayerState.BASIC_ATTACK_FOLLOW
	{
		// Increment the attack timer
		attackTimer -= 1;
		// Move through the different substates
		if currentState == PlayerState.BASIC_ATTACK_ANTI && attackTimer <= 0
		{
			currentState = PlayerState.BASIC_ATTACK_SWING;
			SetPlayerAnimation(global.player_attackSwingAnim, 1, AnimationType.HOLD);
			attackTimer = global.player_attackSwingFrames;
		}
		if currentState == PlayerState.BASIC_ATTACK_SWING && attackTimer <= 0
		{
			currentState = PlayerState.BASIC_ATTACK_FOLLOW;
			SetPlayerAnimation(global.player_attackFollowAnim, 1, AnimationType.HOLD);
			attackTimer = global.player_attackFollowFrames;
		}
		if currentState == PlayerState.BASIC_ATTACK_FOLLOW && attackTimer <= 0
		{
			GoToPlayerIdle();
		}
	}
}

function PlayerPickupSword()
{
	if !armed && keyboard_check(ord("Z")) && place_meeting(x,y,obj_player_sword) && obj_player_sword.SwordCanBePickedUp()
	{
		if global.showDebugMessages show_debug_message("Picked up sword");
		armed = true;
		obj_player_sword.currentState = SwordState.INACTIVE;
	}
}

function PlayerGetHit()
{
	if invulnerable return;
	if armed
	{
		vspeed -= 15;
		if obj_Moose.x > x hspeed = - 20;
		else hspeed = 20;
		armed = false;
		h = -1;
		if obj_Moose.x < x h = 1;
		obj_player_sword.PlayerSwordFling(h,-1.67,17);
		MakePlayerInvulnerable();
	}
	else
	{
		GoToPlayerDead();
	}
}
#endregion

#region Animation Controls
function PlayPlayerAnimation()
{
	if currentAnimType == AnimationType.FIRST_FRAME
	{
		image_index = 0;
		return;
	}
	animFrameCounter++;
	if animFrameCounter >= currentFPI
	{
		animFrameCounter = 0;
		image_index ++;
		if image_index >= sprite_get_number(sprite_index)
		{
			if currentAnimType == AnimationType.LOOP image_index = 0;
			else if currentAnimType == AnimationType.HOLD image_index = sprite_get_number(sprite_index) - 1;
		}
	}
}

function SetPlayerAnimation(animation, fpi, type)
{
	sprite_index = animation;
	currentFPI = fpi;
	currentAnimType = type;
	animFrameCounter = 0;
}


function SetPlayerFacingBasedOnSprite()
{
	if image_xscale > 0 facing = Direction.RIGHT;
	else facing = Direction.LEFT;
}
function SetPlayerFacingDirection()
{
	if currentState == PlayerState.BASIC_ATTACK_ANTI || currentState == PlayerState.BASIC_ATTACK_SWING
	|| currentState == PlayerState.BASIC_ATTACK_FOLLOW|| currentState == PlayerState.JUMPING || currentState == PlayerState.FALLING
		return;
	if facing == Direction.RIGHT
		image_xscale = 1;
	else image_xscale = -1;
}

function SwitchPlayerArmedAnims()
{
	if armed
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
	switch currentState
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
	switch currentState
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

function MakePlayerInvulnerable()
{
	invulnerable = true;
	invulnerabilityTimer = global.player_invulnerabilityTime;
}

function PlayerInvulnerability()
{
	if currentState == PlayerState.DASH && global.player_invulnWhileDashing
	{
		invulnerable = true;
		return;
	}
	if invulnerable == false return;
	invulnerabilityTimer --;
	visible = ceil(invulnerabilityTimer/7)%2;
	if invulnerabilityTimer <= 0 
	{
		visible = true;
		invulnerable = false;
	}
}

function PlayerNotAttacking()
{
	if currentState == PlayerState.BASIC_ATTACK_ANTI return false;
	else if currentState == PlayerState.BASIC_ATTACK_FOLLOW return false;
	else if currentState == PlayerState.BASIC_ATTACK_SWING return false;
	else return true;
}