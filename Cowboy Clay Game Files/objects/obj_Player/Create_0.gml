/// @description Code to be executed when player is created
collision_mask = [obj_Ground, obj_Wall, obj_plate, obj_door,obj_box, obj_elevator, obj_tile_coll];
	
#region Master Variables
global.paused = false; // true if the game should be paused
global.showDebugMessages = true; // set to true if you want to print debug messages
#endregion

#region State Variables
enum PlayerState { IDLE, WALKING, JUMP_ANTI, JUMPING, FALLING, BASIC_ATTACK_ANTI, BASIC_ATTACK_SWING, BASIC_ATTACK_FOLLOW, DASH_ANTI, DASH, DASH_FOLLOW, LOCK, DEAD, KICK_ANTI, KICK_SWING, KICK_FOLLOW, SHEATHING, UNSHEATHING, PLUNGING };
current_state = PlayerState.LOCK;
facing = Direction.RIGHT; // The direction the player is facing
armed = startArmed; // Is the player armed. startArmed is set in the variable menu
sheathed = false;
grounded = false;
hiblock = 0;
#endregion

#region Physics Variables
global.player_gravityAccel = 1; // The basic rate of acceloration due to gravity
global.player_gravityMax = 20; // The basic maximum of gravity
#endregion

#region Walk Variables
global.player_frictionValue = .33; // The basic rate of friction
global.player_walkAccel = .5; // The basic rate of acceloration from walking
global.player_maxWalkSpeed = 6; // The basic max walking speed
#endregion

#region Dash Variables
dashTimer = 0;
lastDashTapDirection = Direction.LEFT;
dashOnCooldown = false;
global.player_dashAnticipation = 22;
global.player_dashFrameAllowance = 15;
global.player_dashImpulseForce = 60;
global.player_dashExtendForce = 22;
global.player_dashEndForce = 15;
global.player_instantDash = true;
global.player_dashDuration = 8;
global.player_dashCooldown = 9;
global.player_invulnWhileDashing = true;
global.player_dashFollow = 38;
#endregion

#region Jump Variables
jumpTimer = 0; // Frame counter to determine how long the player is preparing their jump
jump_buffer = 0;
global.player_minJumpWindup = 3; // the min # of frames the player can prepare a jump
global.player_maxJumpWindup = 30; // the max # of frames the player can prepare a jump
global.player_minVertJumpForce = 16; // min vertical force applied by a jump
global.player_maxVertJumpForce = 25; // max vertical force applied by a jump
global.player_minHoriJumpForce = 0; // min horizontal force applied by a jump
global.player_maxHoriJumpForce = 10; // max horizontal force applied by a jump
global.player_jump_buffer_frames = 160;
#endregion

#region Basic Attack Variables
global.player_attackAntiFrames = 12; // # of frames the attack anti is shown
global.player_attackSwingFrames = 10;
global.player_attackFollowFrames = 15;
attackTimer = 0; // Frame counter to determine how long the player has been in each attack state
#endregion
#region Kick Attack Variables
global.player_kickAntiFrames = 2;
global.player_kickSwingFrames = 10;
global.player_kickFollowFrames = 2;
#endregion

global.player_sheathFrames = 40;
global.player_unsheathFrames = 20;
sheathTimer = 0;

global.player_plungeFrames = 7;

invulnerable = false;
invulnerabilityTimer = 0;
global.player_invulnerabilityTime = 180;

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

layer_create(-300, "PlayerTools");
instance_create_layer(x,y,"PlayerTools", obj_player_attackEffect);
instance_create_layer(x,y,"PlayerTools", obj_player_hitbox);
instance_create_layer(x,y,"PlayerTools", obj_player_hurtbox);
instance_create_layer(x,y,"PlayerTools", obj_player_sword);
instance_create_layer(x,y,"PlayerTools", obj_cam_position);

#region  State Machine
function UpdatePlayerState()
{
	switch current_state
	{
		case PlayerState.IDLE:
			/*if hiblock == 0 && keyboard_check(vk_down) && keyboard_check_pressed(ord("Z"))
			{
				PlayerPlungeSword();
				return;
			}*/
			
			
			if keyboard_check_pressed(ord("X")) {
				jump_buffer = global.player_jump_buffer_frames;
			}
			if jump_buffer > 0 GoToPlayerJumpAnti();
			else if OneWalkKeyHeld() GoToPlayerWalk();
			if collision_check_edge(x,y,spr_player_collision,Direction.DOWN,collision_mask) == false GoToPlayerFall();
			break;
		case PlayerState.WALKING:
			if keyboard_check(vk_down) && keyboard_check_pressed(ord("X")) && !dashOnCooldown
			{
				//GoToDashAnti();
				//return;
			}
			if keyboard_check_pressed(ord("X")) {
				jump_buffer = global.player_jump_buffer_frames;
			}
			if jump_buffer > 0 GoToPlayerJumpAnti();
			else if !OneWalkKeyHeld() GoToPlayerIdle();
			if collision_check_edge(x,y,spr_player_collision,Direction.DOWN,collision_mask) == false GoToPlayerFall();
			break;
		case PlayerState.JUMP_ANTI:
			if keyboard_check(vk_down) && keyboard_check_pressed(ord("X")) && !dashOnCooldown
			{
				//GoToDashAnti();
				//return;
			}
			break;
		case PlayerState.JUMPING:
			if vspeed > 0 GoToPlayerFall();
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
	switch current_state
	{
		case PlayerState.IDLE:
			PlayerUpdateBlock();
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
		case PlayerState.KICK_ANTI:
			PlayerDashCooldown();
			PlayerAttack();
			break;
		case PlayerState.KICK_SWING:
			PlayerDashCooldown();
			PlayerAttack();
			break;
		case PlayerState.KICK_FOLLOW:
			PlayerDashCooldown();
			PlayerAttack();
			break;
		case PlayerState.DASH_ANTI:
			break;
		case PlayerState.DASH:
			PlayerDash();
			break;
		case PlayerState.SHEATHING:
			PlayerSheathSword();
			break;
		case PlayerState.UNSHEATHING:
			PlayerUnsheathSword();
			break;
		case PlayerState.PLUNGING:
			PlayerPlungeSword();
			break;
	}
}

function GoToPlayerDead()
{
	current_state = PlayerState.DEAD;
	instance_deactivate_object(obj_player_hitbox);
	instance_deactivate_object(obj_player_hurtbox);
}

function GoToPlayerIdle()
{
	current_state = PlayerState.IDLE;
}
function GoToPlayerJumpAnti()
{
	jumpTimer = 0;
	jump_buffer = -1;
	current_state = PlayerState.JUMP_ANTI;
}
function GoToPlayerJump()
{
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
	current_state = PlayerState.JUMPING;
}
function GoToPlayerWalk()
{
	current_state = PlayerState.WALKING;
	
	if keyboard_check(vk_left) lastDashTapDirection = Direction.LEFT;
	else if keyboard_check(vk_right) lastDashTapDirection = Direction.RIGHT;
}
function GoToPlayerFall()
{
	current_state = PlayerState.FALLING;
}
function GoToPlayerBasicAttack()
{
	attackTimer = global.player_attackAntiFrames;
	current_state = PlayerState.BASIC_ATTACK_ANTI;
	if attackTimer <= 0
	{
		current_state = PlayerState.BASIC_ATTACK_SWING;
			obj_player_attackEffect.ShowPlayerAttack(spr_player_attackEffect,1);
		attackTimer = global.player_attackSwingFrames;
	}
	if attackTimer <= 0
	{
		current_state = PlayerState.BASIC_ATTACK_FOLLOW;
			obj_player_attackEffect.HidePlayerAttack();
		attackTimer = global.player_attackFollowFrames;
	}
	if attackTimer <= 0
	{
		GoToPlayerIdle();
	}
}
function GoToPlayerKick()
{
	attackTimer = global.player_kickAntiFrames;
	current_state = PlayerState.KICK_ANTI;
	if attackTimer <= 0
	{
		current_state = PlayerState.KICK_SWING;
		//obj_player_attackEffect.ShowPlayerAttack(spr_player_kickEffect,1);
		attackTimer = global.player_kickSwingFrames;
	}
	
	if attackTimer <= 0
	{
		current_state = PlayerState.KICK_FOLLOW;
		obj_player_attackEffect.HidePlayerAttack();
		attackTimer = global.player_kickFollowFrames;
	}
	if attackTimer <= 0
	{
		GoToPlayerIdle();
	}
}

function GoToDashAnti()
{
	current_state = PlayerState.DASH_ANTI;
	
	var a = global.player_dashAntiAnim;
	if !armed a = global.player_dashAntiAnim_disarmed;
	
	dashTimer = 0;
}

function GoToDash()
{
	current_state = PlayerState.DASH;
	
	var a = global.player_dashAnim;
	if !armed a = global.player_dashAnim_disarmed;
	
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
	dashTimer = 0;
	current_state = PlayerState.DASH_FOLLOW;
	
	var a = global.player_dashFollowAnim;
	if !armed a = global.player_dashFollowAnim_disarmed;
}

function CheckDash()
{
	if dashOnCooldown
	{
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
function PlayerPlungeSword()
{
	if !armed return;
	if current_state != PlayerState.PLUNGING
	{
		audio_play_sound(sfx_sword_plunge,25,false);
		current_state = PlayerState.PLUNGING;
		sheathTimer = global.player_plungeFrames;
		return;
	}
	sheathTimer --;
	if sheathTimer <= 0
	{
		armed = false;
		sheathed = false;
		obj_player_sword.PlayerSwordFling(0,-1,.5);
		obj_player_sword.plungeFlag = true
		GoToPlayerIdle();
	}
}

function PlayerUnsheathSword()
{
	if !sheathed || armed return;
	if current_state != PlayerState.UNSHEATHING
	{
		current_state = PlayerState.UNSHEATHING;
		sheathTimer = global.player_unsheathFrames;
		return;
	}
	sheathTimer --;
	if sheathTimer <= 0
	{
		armed = true;
		sheathed = false;
		hiblock = 1;
		GoToPlayerIdle();
	}
}

function PlayerSheathSword()
{
	if !armed || sheathed return;
	if current_state != PlayerState.SHEATHING
	{
		current_state = PlayerState.SHEATHING;
		sheathTimer = global.player_sheathFrames;
		return;
	}
	sheathTimer --;
	if sheathTimer <= 0
	{
		armed = false;
		sheathed = true;
		GoToPlayerIdle();
	}
}

function PlayerUpdateBlock()
{
	if keyboard_check_pressed(vk_up) && hiblock == 0
	{
		hiblock = 1;
		return;
	}
	else if keyboard_check_pressed(vk_down) && hiblock == 1
	{
		hiblock = 0;
		return;
	}
}

function PlayerWalk()
{
	var curAc = global.player_walkAccel;
	
	switch current_state
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
	
	if abs(hspeed) > global.player_maxWalkSpeed && current_state != PlayerState.JUMPING && current_state != PlayerState.FALLING
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
	if current_state != PlayerState.BASIC_ATTACK_ANTI && current_state != PlayerState.BASIC_ATTACK_SWING 
	&& current_state != PlayerState.BASIC_ATTACK_FOLLOW && keyboard_check_pressed(ord("Z")) && armed
	{
		GoToPlayerBasicAttack();
	}
	else if current_state != PlayerState.KICK_ANTI && current_state != PlayerState.KICK_SWING
	&& current_state != PlayerState.KICK_FOLLOW && keyboard_check_pressed(ord("Z")) && !armed && !keyboard_check(vk_down)
	{
		GoToPlayerKick();
	}
	else if current_state == PlayerState.BASIC_ATTACK_ANTI || current_state == PlayerState.BASIC_ATTACK_SWING || current_state == PlayerState.BASIC_ATTACK_FOLLOW
	{
		// Increment the attack timer
		attackTimer -= 1;
		// Move through the different substates
		if current_state == PlayerState.BASIC_ATTACK_ANTI && attackTimer <= 0
		{
			current_state = PlayerState.BASIC_ATTACK_SWING;
			obj_player_attackEffect.ShowPlayerAttack(spr_player_attackEffect,1);
			attackTimer = global.player_attackSwingFrames;
		}
		if current_state == PlayerState.BASIC_ATTACK_SWING && attackTimer <= 0
		{
			current_state = PlayerState.BASIC_ATTACK_FOLLOW;
			obj_player_attackEffect.HidePlayerAttack();
			attackTimer = global.player_attackFollowFrames;
		}
		if current_state == PlayerState.BASIC_ATTACK_FOLLOW && attackTimer <= 0
		{
			GoToPlayerIdle();
		}
	}
	else if current_state == PlayerState.KICK_ANTI || current_state == PlayerState.KICK_SWING || current_state == PlayerState.KICK_FOLLOW
	{
		// Increment the attack timer
		attackTimer -= 1;
		// Move through the different substates
		if current_state == PlayerState.KICK_ANTI && attackTimer <= 0
		{
			current_state = PlayerState.KICK_SWING;
			//obj_player_attackEffect.ShowPlayerAttack(
			attackTimer = global.player_kickSwingFrames;
		}
		if current_state == PlayerState.KICK_SWING && attackTimer <= 0
		{
			current_state = PlayerState.KICK_FOLLOW;
			//obj_player_attackEffect.HidePlayerAttack();
			attackTimer = global.player_kickFollowFrames;
		}
		if current_state == PlayerState.KICK_FOLLOW && attackTimer <= 0
		{
			GoToPlayerIdle();
		}
	}
}

function PlayerKick()
{
	
}

function PlayerPickupSword()
{
	if !armed && keyboard_check_pressed(ord("Z")) && place_meeting(x,y,obj_player_sword) && obj_player_sword.SwordCanBePickedUp()
	{
		audio_play_sound(sfx_sword_retrieve,25,false);
		armed = true;
		obj_player_sword.current_state = SwordState.INACTIVE;
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
		if obj_Moose.x > x hspeed = - 20;
		else hspeed = 20;
		vspeed = -20
		GoToPlayerDead();
		obj_Moose.current_state = MooseState.LOCK;
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
		for(var i = 0; i < array_length(global.player_sfx_table); i++) {
		if sprite_index == global.player_sfx_table[i][0] {
			if image_index == global.player_sfx_table[i][1] {
				audio_play_sound(global.player_sfx_table[i][2], 50, false);
			}
		}
	}
	}
	
	
}

function SetPlayerAnimation(animation, fpi, type)
{
	if sprite_index == animation && currentFPI == fpi && currentAnimType == type return;
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
	if current_state == PlayerState.BASIC_ATTACK_ANTI || current_state == PlayerState.BASIC_ATTACK_SWING
	|| current_state == PlayerState.BASIC_ATTACK_FOLLOW|| current_state == PlayerState.JUMPING || current_state == PlayerState.FALLING
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
	switch current_state
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
	switch current_state
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
	if current_state == PlayerState.DASH && global.player_invulnWhileDashing
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
	if current_state == PlayerState.BASIC_ATTACK_ANTI return false;
	else if current_state == PlayerState.BASIC_ATTACK_FOLLOW return false;
	else if current_state == PlayerState.BASIC_ATTACK_SWING return false;
	else return true;
}

function update_animation() {
	var a = noone;
	switch(current_state) {
		case PlayerState.IDLE:
			if !armed {
				a = spr_player_idle_disarmed;
			} else if hiblock == 1 {
				a = spr_player_blockHi;
			} else {
				a = spr_player_idle_loBlock;
			}
			SetPlayerAnimation(a, global.player_idleFPI, global.player_idleAnimType);
			break;
		case PlayerState.WALKING:			 
			if !armed {
				a = spr_player_walk_disarmed;
			} else if hiblock == 1 {
				a = spr_player_walk_hiBlock;
			} else {
				a = spr_player_walk_loBlock;
			}
			SetPlayerAnimation(a, global.player_walkFPI, global.player_walkAnimType);
			break;
		case PlayerState.JUMP_ANTI:
			a = armed ? spr_player_jumpAnti : spr_player_jumpAnti_disarmed;
			SetPlayerAnimation(a, global.player_jumpAntiFPI, global.player_jumpAntiAnimType);
			break;
		case PlayerState.JUMPING:	
			 a = armed ? spr_player_jump : spr_player_jump_disarmed;
			SetPlayerAnimation(a, global.player_jumpFPI, global.player_jumpAnimType);
			break;
		case PlayerState.FALLING:	
			a = armed ? spr_player_fall : spr_player_jumpDown_disarmed;
			SetPlayerAnimation(a, global.player_fallFPI, global.player_fallAnimType);
			break;
		case PlayerState.BASIC_ATTACK_ANTI:
			a = get_hi_attack_player(id,10) ? global.player_hiattackAntiAnim : spr_player_attackAnti;
			SetPlayerAnimation(a, 1, AnimationType.FIRST_FRAME);
			break;
		case PlayerState.BASIC_ATTACK_SWING: 
			a = get_hi_attack_player(id,10) ? global.player_hiattackSwingAnim : spr_player_attackSwing;
			SetPlayerAnimation(a, 1, AnimationType.FIRST_FRAME);
			break;
		case PlayerState.BASIC_ATTACK_FOLLOW:
			a = get_hi_attack_player(id,10) ? global.player_hiattackFollowAnim : spr_player_attackFollow;
			SetPlayerAnimation(a, 1, AnimationType.FIRST_FRAME);
			break;
		case PlayerState.DASH_ANTI:			
			a = armed ? spr_player_dash_anti : spr_player_dash_anti_disarmed;
			SetPlayerAnimation(a, global.player_dashAntiAnimFPI, global.player_dashAntiAnimType);
			break;
		case PlayerState.DASH:				 
			a = armed ? spr_player_dash : spr_player_dash_disarmed;
			SetPlayerAnimation(a, global.player_dashAnimFPI, global.player_dashAnimType);
			break;
		case PlayerState.DASH_FOLLOW:		 
			a = armed? spr_player_dash_follow : spr_player_dash_follow_disarmed;
			SetPlayerAnimation(a, global.player_dashFollowAnimFPI, global.player_dashFollowAnimType);
			break;
		case PlayerState.LOCK:
			// This state has no specific animations
			break;
		case PlayerState.DEAD:
			a = spr_player_death;
			SetPlayerAnimation(a, global.player_deathAnimFPI, AnimationType.HOLD);
			break;
	}
}

