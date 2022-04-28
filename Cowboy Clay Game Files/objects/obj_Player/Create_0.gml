/// @description Code to be executed when player is created
collision_mask = [obj_wall_breakable, obj_Ground, obj_Wall, obj_plate, obj_door,obj_box, obj_elevator, obj_tile_coll];

audio_group_load(sfx_clay);

#region Master Variables
global.paused = false; // true if the game should be paused
global.showDebugMessages = true; // set to true if you want to print debug messages
#endregion

#region State Variables
enum PlayerState { IDLE, WALKING, JUMP_ANTI, JUMPING, FALLING, ATTACK_CHARGE_CANCEL,BASIC_ATTACK_ANTI, BASIC_ATTACK_SWING, BASIC_ATTACK_FOLLOW, DASH_ANTI, DASH, DASH_FOLLOW, LOCK, DEAD, KICK_ANTI, KICK_SWING, KICK_FOLLOW, SHEATHING, UNSHEATHING, PLUNGING, BLOCK, BLOCK_FOLLOW, SLING_ANTI, SLING_SWING, SLING_FOLLOW, PAIN };
current_state = PlayerState.LOCK;
facing = Direction.RIGHT; // The direction the player is facing
armed = startArmed; // Is the player armed. startArmed is set in the variable menu
sheathed = false;
grounded = false;
hiblock = 0;
block_success = false;
special_fall = 0;
#endregion

#region Physics Variables
global.player_gravityAccel = 1; // The basic rate of acceloration due to gravity
global.player_gravityMax = 20; // The basic maximum of gravity
#endregion

#region Walk Variables
global.player_frictionValue = .40; // The basic rate of friction
global.player_walkAccel = .8; // The basic rate of acceloration from walking
global.player_maxWalkSpeed = 8; // The basic max walking speed
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
global.player_minJumpWindup = 0; // the min # of frames the player can prepare a jump
global.player_maxJumpWindup = 60; // the max # of frames the player can prepare a jump
global.player_minVertJumpForce = 20; // min vertical force applied by a jump
global.player_maxVertJumpForce = 27.5; // max vertical force applied by a jump
global.player_minHoriJumpForce = 5; // min horizontal force applied by a jump
global.player_maxHoriJumpForce = 10; // max horizontal force applied by a jump
global.player_jump_buffer_frames = 20;
#endregion

#region Basic Attack Variables
basic_attack_charge_timer = 0;
global.player_basic_attack_charge_min = 45;
global.player_attack_cancel_frames = 20;
global.player_attackAntiFrames = 2; // # of frames the attack anti is shown
global.player_attackSwingFrames = 10;
global.player_attackFollowFrames = 15;
attackTimer = 0; // Frame counter to determine how long the player has been in each attack state
#endregion
sling_attack_charge_timer = 0;
global.player_sling_attack_charge_min = 0;
global.player_sling_attack_charge_full = 80;
global.player_sling_anti_frames = 2;
global.player_sling_swing_frames = 6;
global.player_sling_follow_frames = 16;
#region Kick Attack Variables
global.player_kickAntiFrames = 5;
global.player_kickSwingFrames = 25;
global.player_kickFollowFrames = 6;
global.player_kick_force = 10;
#endregion

global.player_sheathFrames = 40;
global.player_unsheathFrames = 20;
sheathTimer = 0;

global.player_plungeFrames = 7;

global.player_block_frames = 45;
global.player_block_success_frames = 5;
global.player_block_failure_frames = 30;

global.player_pain_frames = 45;

invulnerable = false;
invulnerabilityTimer = 0;
global.player_invulnerabilityTime = 180;

global.player_frictMulti_jumpAnti = .5;
global.player_frictMulti_jumping = 0.2;
global.player_frictMulti_attacking = 1;

global.player_speedMulti_jumping = 0.5;
global.player_speedMulti_falling = 0.4;

global.player_graviMulti_attacking = 0.2;

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
if startArmed == true instance_create_layer(x,y,"PlayerTools", obj_player_sword);
instance_create_layer(x,y,"PlayerTools", obj_cam_position);

#region  State Machine
function PlayerStateBasedMethods()
{
	jump_buffer --;
	if keyboard_check_pressed(global.keybind_jump) {
		jump_buffer = global.player_jump_buffer_frames;
	}
	
	switch current_state {
		case PlayerState.IDLE:
			walk();
			sling_attack_charge();
			basic_attack_charge();
			check_falling();
			if check_blocks() && basic_attack_charge_timer == 0 break;
			if jump_buffer > 0 {
				GoToPlayerJumpAnti();
				break;
			}
			if basic_attack_charge_timer == 0 && sling_attack_charge_timer == 0 && keyboard_check_pressed(global.keybind_kick) {
				to_kick_anti();
				break;
			}
			// Go to walk if you are moving
			if abs(hspeed) > 0.1 {
				GoToPlayerWalk();
				break;
			}
			break;
		case PlayerState.WALKING:
			walk();
			sling_attack_charge();
			basic_attack_charge();
			check_falling();
			if check_blocks() && basic_attack_charge_timer == 0 break;
			if jump_buffer > 0 {
				GoToPlayerJumpAnti();
				break;
			}
			if basic_attack_charge_timer == 0 && sling_attack_charge_timer == 0 && keyboard_check_pressed(global.keybind_kick) {
				to_kick_anti();
				break;
			}
			if abs(hspeed) <= 0.1 {
				GoToPlayerIdle();
			}
			break;
		case PlayerState.JUMP_ANTI:
			sling_attack_charge();
			basic_attack_charge();
			check_falling();
			PlayerJumpAnti();
			break;
		case PlayerState.JUMPING:
			sling_attack_charge();
			basic_attack_charge();
			if basic_attack_charge_timer == 0 && sling_attack_charge_timer == 0 {
				walk();
			}
			check_falling();
			break;
		case PlayerState.FALLING:
			if !check_falling(){
				audio_play_sound(sfx_clay_land, 5, false);
				instance_create_depth(x,y,depth-100, obj_player_land_dust);
				GoToPlayerIdle();
			}
			sling_attack_charge();
			basic_attack_charge();
			if basic_attack_charge_timer == 0 && sling_attack_charge_timer == 0 {
				walk();
			}
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
		case PlayerState.KICK_ANTI:
			kick_anti();
			break;
		case PlayerState.KICK_SWING:
			kick_swing();
			break;
		case PlayerState.KICK_FOLLOW:
			kick_follow();
			break;
		case PlayerState.DASH_ANTI:
			break;
		case PlayerState.DASH:
			break;
		case PlayerState.SHEATHING:
			break;
		case PlayerState.UNSHEATHING:
			break;
		case PlayerState.PLUNGING:
			break;
		case PlayerState.BLOCK:
			block();
			break;
		case PlayerState.BLOCK_FOLLOW:
			block_follow();
			break;
		case PlayerState.ATTACK_CHARGE_CANCEL:
			attack_cancel();
			break;
		case PlayerState.SLING_ANTI:
			sling_attack_anti();
			break;
		case PlayerState.SLING_SWING:
			sling_attack_swing();
			break;
		case PlayerState.SLING_FOLLOW:
			sling_attack_follow();
			break;
		case PlayerState.PAIN:
			pain();
			break;
	}
}

function to_kick_anti() {
	state_timer = global.player_kickAntiFrames;
	current_state = PlayerState.KICK_ANTI;
	kick_anti();
}
function kick_anti() {
	hspeed *= 0.2;
	if state_timer <= 0 {
		to_kick_swing();
		return;
	}
	state_timer--;
}
function to_kick_swing() {
	state_timer = global.player_kickSwingFrames;
	current_state = PlayerState.KICK_SWING;
	hspeed += facing == Direction.RIGHT ? global.player_kick_force : -1 * global.player_kick_force;
	instance_create_depth(x,y,depth-100, obj_player_walk_dust).image_xscale = facing == Direction.RIGHT ? 1 : -1;
	kick_swing();
}
function kick_swing() {
	if facing == Direction.LEFT &&
	   collision_check_edge(x,y,spr_player_collision,Direction.LEFT,collision_mask) && 
	   instance_exists(obj_player_sword) &&
	   obj_player_sword.current_state == SwordState.STUCK_WALL_LEFT &&
	   abs(obj_player_sword.x - x) < 200 {
		obj_player_sword.to_kicked(); 
	} else if facing == Direction.RIGHT &&
	          collision_check_edge(x,y,spr_player_collision,Direction.RIGHT, collision_mask) &&
			  instance_exists(obj_player_sword) &&
			  obj_player_sword.current_state == SwordState.STUCK_WALL_RIGHT &&
			  abs(obj_player_sword.x - x) < 200 {
		obj_player_sword.to_kicked();	  
	}
	   
	
	if state_timer <= 0 {
		to_kick_follow();
		return;
	}
	state_timer --;
}
function to_kick_follow() {
	state_timer = global.player_kickFollowFrames;
	current_state = PlayerState.KICK_FOLLOW;
	kick_follow();
}
function kick_follow() {
	if state_timer <= 0 {
		GoToPlayerIdle();
		return;
	}
	state_timer --;
}

function to_pain() {
	//hitstun(.);
	state_timer = global.player_pain_frames;
	current_state = PlayerState.PAIN;
}
function pain() {
	if state_timer <= 0 {
		GoToPlayerIdle();
		return;
	}
	state_timer --;
}

function check_falling() {
	if current_state == PlayerState.BASIC_ATTACK_ANTI ||
	   current_state == PlayerState.BASIC_ATTACK_SWING ||
	   current_state == PlayerState.BASIC_ATTACK_FOLLOW ||
	   current_state == PlayerState.ATTACK_CHARGE_CANCEL {
		   return false;
	}
	
	if vspeed > 0 && !collision_check_edge(x,y,spr_player_collision, Direction.DOWN, collision_mask) {
		GoToPlayerFall();
		return true;
	}
	special_fall = 0;
	return false;
}

function attack_cancel() {
	state_timer --;
	if state_timer <= 0 {
		GoToPlayerIdle();
	}
}
function to_attack_cancel() {
	instance_create_depth(x,y,depth+10, obj_question_mark);
	audio_play_sound(sfx_clay_confused, 10, false);
	state_timer = global.player_attack_cancel_frames;
	current_state = PlayerState.ATTACK_CHARGE_CANCEL;
}

function basic_attack_charge() {
	if !armed {
		basic_attack_charge_timer = 0;
		return;
	}
	
	if basic_attack_charge_timer == global.player_basic_attack_charge_min {
		instance_create_depth(x,y,depth-10, obj_player_charge_spark)
		audio_play_sound(sfx_sword_anti, 10, false);
	}
	
	if basic_attack_charge_timer == 0 && keyboard_check_pressed(global.keybind_attack) && sling_attack_charge_timer == 0{
		basic_attack_charge_timer ++;
	} else if basic_attack_charge_timer > 0 && keyboard_check(global.keybind_attack) {
		basic_attack_charge_timer ++;
	} else if basic_attack_charge_timer > 0 && basic_attack_charge_timer < global.player_basic_attack_charge_min && !keyboard_check(global.keybind_attack) {
		to_attack_cancel();
		basic_attack_charge_timer = 0;
	} else if basic_attack_charge_timer > global.player_basic_attack_charge_min && !keyboard_check(global.keybind_attack) {
		basic_attack_charge_timer = 0;
		audio_play_sound(sfx_sword_swing, 10, false);
		GoToPlayerBasicAttack();
	}
}
function sling_attack_charge() {
	if sling_attack_charge_timer == 0 && keyboard_check_pressed(global.keybind_sling) && basic_attack_charge_timer == 0{
		show_debug_message("Began charging sling");
		sling_attack_charge_timer ++;
	} else if sling_attack_charge_timer > 0 && keyboard_check(global.keybind_sling) {
		show_debug_message("continue charging sling");
		sling_attack_charge_timer ++;
	} else if sling_attack_charge_timer > 0 && sling_attack_charge_timer < global.player_sling_attack_charge_min && !keyboard_check(global.keybind_sling) {
		show_debug_message("release sling early");
		to_attack_cancel();
		sling_attack_charge_timer = 0;
	} else if sling_attack_charge_timer > global.player_sling_attack_charge_min && !keyboard_check(global.keybind_sling) {
		show_debug_message("release sling good");
		to_sling_attack_anti(sling_attack_charge_timer / global.player_sling_attack_charge_full);
		sling_attack_charge_timer = 0;
	}
}

function to_sling_attack_anti(charge_percent) {
	sling_attack_charge_percent = charge_percent;
	current_state = PlayerState.SLING_ANTI;
	special_fall = 2;
	state_timer = global.player_sling_anti_frames;
}
function sling_attack_anti() {
	state_timer --;
	if state_timer < 0 {
		to_sling_attack_swing();
	}
}
function to_sling_attack_swing() {
	audio_play_sound(sfx_clay_sling_attack, 5, false);
	current_state = PlayerState.SLING_SWING;
	state_timer = global.player_sling_swing_frames;
	// SPAWN PROJECTILE
	if vspeed > 0 vspeed *= 0.2;
	var i = instance_create_depth(x,y,-100,obj_player_projectile);
	i.facing = facing;
	i.h = lerp(i.h/6, i.h, clamp(sling_attack_charge_percent,0,1));
}
function sling_attack_swing() {
	state_timer --;
	if state_timer < 0 {
		to_sling_attack_follow();
	}
}
function to_sling_attack_follow() {
	current_state = PlayerState.SLING_FOLLOW;
	state_timer = global.player_sling_follow_frames;
}
function sling_attack_follow() {
	state_timer --;
	if state_timer < 0 {
		GoToPlayerIdle();
	}
}

function check_blocks() {
	if !armed return;
	if keyboard_check_pressed(global.keybind_block) {
		if keyboard_check(global.keybind_up) && !keyboard_check(global.keybind_down) {
			hiblock = 1;
		} else {
			hiblock = 0;
		}
		to_block();
		return true;
	}
	return false;
}

function to_block() {
	if hiblock == 1 {
		instance_create_depth(x,y,depth-100, obj_player_hi_block_spark).image_xscale = image_xscale;
	} else {
		instance_create_depth(x,y,depth-100, obj_player_lo_block_spark).image_xscale = image_xscale;
	}
	current_state = PlayerState.BLOCK;
	state_timer = global.player_block_frames;
}
function block() {
	state_timer --;
	// if block state has run out then the block was a failure
	if state_timer < 0 {
		to_block_follow(false);
	}
}
function to_block_follow(success) {
	show_debug_message(success);
	if !success {
		instance_create_depth(x,y,depth+10, obj_question_mark).x -= facing == Direction.LEFT ? 100 : 0;
		audio_play_sound(sfx_clay_confused,10,false);
	}
	current_state = PlayerState.BLOCK_FOLLOW;
	block_success = success;
	state_timer = success ? global.player_block_success_frames : global.player_block_failure_frames;
}
function block_follow() {
	state_timer--;
	if state_timer < 0 {
		GoToPlayerIdle();
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
	var g = collision_check_edge(x,y,spr_player_collision,Direction.DOWN,collision_mask) == false;
	if g return;
	jumpTimer = 0;
	jump_buffer = -1;
	current_state = PlayerState.JUMP_ANTI;
}
function GoToPlayerJump()
{
	instance_create_depth(x,y,depth-100, obj_player_jump_dust);
	audio_play_sound(sfx_clay_jump, 5, false);
	vspeed -= jumpTimer >= global.player_maxJumpWindup ? global.player_maxVertJumpForce : global.player_minVertJumpForce;
	if OneWalkKeyHeld() && keyboard_check(vk_right)
	{
		hspeed += jumpTimer >= global.player_maxJumpWindup ? global.player_maxHoriJumpForce : global.player_minHoriJumpForce;
	}
	else if OneWalkKeyHeld() && keyboard_check(vk_left)
	{
		hspeed -= jumpTimer >= global.player_maxJumpWindup ? global.player_maxHoriJumpForce : global.player_minHoriJumpForce;
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
		if vspeed > 0 vspeed *= 0.2;
		current_state = PlayerState.BASIC_ATTACK_SWING; 
		show_debug_message(get_hi_attack_player(id,5));
			obj_player_attackEffect.ShowPlayerAttack(get_hi_attack_player(id,5) ? spr_player_jumpAttack_Slash : spr_player_attackEffect, 1);
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

function walk()
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
	if basic_attack_charge_timer > 0 {
		curAc = curAc * 1;
	}
	if sling_attack_charge_timer > 0 {
		curAc = curAc * 1;
	}
	// Left movement
	if keyboard_check(global.keybind_left) && !keyboard_check(global.keybind_right)
	{
		hspeed -= curAc;
	}
	// Right movement
	else if keyboard_check(global.keybind_right) && !keyboard_check(global.keybind_left)
	{
		hspeed += curAc;
	}
	
	if hspeed > 0 && keyboard_check(global.keybind_right) && !keyboard_check(global.keybind_face) && basic_attack_charge_timer == 0 && sling_attack_charge_timer == 0 facing = Direction.RIGHT;
	else if hspeed < 0 && keyboard_check(global.keybind_left) && !keyboard_check(global.keybind_face) && basic_attack_charge_timer == 0 && sling_attack_charge_timer == 0 facing = Direction.LEFT;
	
	var max_speed = global.player_maxWalkSpeed;
	if basic_attack_charge_timer > 0 || sling_attack_charge_timer > 0 {
		max_speed *= .3;
	}
	if abs(hspeed) > max_speed && current_state != PlayerState.JUMPING && current_state != PlayerState.FALLING
	{
		hspeed = sign(hspeed) * lerp(abs(hspeed), max_speed, .2);
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
	if (jumpTimer > global.player_minJumpWindup && keyboard_check(ord("X")) == false)
	{
		GoToPlayerJump();
	}
}

function PlayerAttack()
{
	if current_state == PlayerState.BASIC_ATTACK_ANTI || current_state == PlayerState.BASIC_ATTACK_SWING || current_state == PlayerState.BASIC_ATTACK_FOLLOW
	{
		// Increment the attack timer
		attackTimer -= 1;
		// Move through the different substates
		if current_state == PlayerState.BASIC_ATTACK_ANTI && attackTimer <= 0
		{
			if vspeed > 0 vspeed *= 0.2;
			current_state = PlayerState.BASIC_ATTACK_SWING;
			obj_player_attackEffect.ShowPlayerAttack(get_hi_attack_player(id, 10) ? spr_player_jumpAttack_Slash : spr_player_attackEffect,1);
			attackTimer = global.player_attackSwingFrames;
		}
		if current_state == PlayerState.BASIC_ATTACK_SWING && attackTimer <= 0
		{
			current_state = PlayerState.BASIC_ATTACK_FOLLOW;
			special_fall = 1;
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
	if invulnerable || current_state == PlayerState.DEAD return;
	if armed
	{
		knock_away_from(id,obj_Moose.x, obj_Moose.y, 12);
		armed = false;
		h = 1;
		if obj_Moose.x < x h = -1;
		obj_player_sword.PlayerSwordFling(h,-1.67,17);
		MakePlayerInvulnerable();
		to_pain();
	}
	else
	{
		hitstun(.0);
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
		if currentAnimType == AnimationType.REVERSE_LOOP {
			image_index--;
			if image_index < 0 {
				image_index = sprite_get_number(sprite_index) - 1;
			}
			check_frame_sounds();
			return;
		}
		image_index ++;
		if image_index >= sprite_get_number(sprite_index)
		{
			if currentAnimType == AnimationType.LOOP image_index = 0;
			else if currentAnimType == AnimationType.HOLD image_index = sprite_get_number(sprite_index) - 1;
		}
		check_frame_sounds();
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
	if vspeed < 0 return g;
	switch current_state
	{
		case PlayerState.BASIC_ATTACK_SWING:
			g *= global.player_graviMulti_attacking;
			break;
		case PlayerState.SLING_SWING:
			g *= global.player_graviMulti_attacking;
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
	visible = !visible;
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
			if basic_attack_charge_timer > 0 {
				a = global.player_animation_idle_sword_charge;
				break;
			} else if sling_attack_charge_timer > 0 {
				a = armed ? global.player_animation_idle_sling_charge : global.player_animation_idle_sling_charge_disarmed;
				break;
			} else if armed {
				a = keyboard_check(global.keybind_face) ? global.player_animation_stra_idle : global.player_animation_idle;
			} else {
				a = keyboard_check(global.keybind_face) ? global.player_animation_stra_idle_disarmed : global.player_animation_idle_disarmed;
			}
			break;
		case PlayerState.WALKING:
			// Foward
			if (hspeed < 0 && facing == Direction.LEFT) || (hspeed > 0 && facing == Direction.RIGHT) {
				if basic_attack_charge_timer > 0 {
					a = global.player_animation_walk_sword_charge;
					break;
				} else if sling_attack_charge_timer > 0 {
					a = armed ? global.player_animation_walk_sling_charge : global.player_animation_walk_sling_charge_disarmed;
					break;
				} else if armed {
					a = keyboard_check(global.keybind_face) ? global.player_animation_strastep : global.player_animation_walk;
					break;
				} else {
					a = keyboard_check(global.keybind_face) ? global.player_animation_strastep_disarmed : global.player_animation_walk_disarmed;
				}
			}
			// Backward
			else {
				if basic_attack_charge_timer > 0 {
					a = global.player_animation_backstep_sword_charge;
					break;
				} else if sling_attack_charge_timer > 0 {
					a = armed ? global.player_animation_backstep_sling_charge : global.player_animation_backstep_sling_charge_disarmed;
					break;
				} else if armed {
					a = global.player_animation_backstep;
					break;
				} else {
					a = global.player_animation_backstep_disarmed;
					break;
				}
			}
			break;
		case PlayerState.JUMP_ANTI:
			if basic_attack_charge_timer > 0 {
				a = global.player_animation_jump_anti_sword_charge;
				break;
			} else if sling_attack_charge_timer > 0 {
				a = armed ? global.player_animation_jump_anti_sling_charge : global.player_animation_jump_anti_sling_charge_disarmed;
				break;
			} else if armed {
				a = global.player_animation_jump_anti;
				break;
			} else {
				a = global.player_animation_jump_anti_disarmed;
				break;
			}
			break;
		case PlayerState.JUMPING:
			if basic_attack_charge_timer > 0 {
				a = global.player_animation_jump_sword_charge;
				break;
			} else if sling_attack_charge_timer > 0 {
				a = armed ? global.player_animation_jump_sling_charge : global.player_animation_jump_sling_charge_disarmed;
				break;
			} else if armed {
				a = global.player_animation_jump;
				break;
			} else {
				a = global.player_animation_jump_disarmed;
			}
			break;
		case PlayerState.FALLING:
			if basic_attack_charge_timer > 0 {
				a = global.player_animation_fall_sword_charge;
				break;
			} else if sling_attack_charge_timer > 0 {
				a = global.player_animation_fall_sling_charge;
				break;
			} else if special_fall == 1 {
				a = global.player_animation_sword_hi_follow;
			} else if special_fall == 2 {
				a = armed ? global.player_animation_sling_hi_follow : global.player_animation_sling_hi_follow_disarmed;
			} else if armed {
				a = global.player_animation_fall;
				break;
			} else {
				a = global.player_animation_fall_disarmed;
			}
			break;
		case PlayerState.BASIC_ATTACK_ANTI:
			a = get_hi_attack_player(id, 10) ? global.player_animation_sword_hi_anti : global.player_animation_sword_anti;
			break;
		case PlayerState.BASIC_ATTACK_SWING:
			a = get_hi_attack_player(id, 10) ? global.player_animation_sword_hi_swing : global.player_animation_sword_swing;
			break;
		case PlayerState.BASIC_ATTACK_FOLLOW:
			a = get_hi_attack_player(id, 10) ? global.player_animation_sword_hi_follow : global.player_animation_sword_follow;
			break;
		case PlayerState.SLING_ANTI:
			if get_hi_attack_player(id, 10) {
				a = armed ? global.player_animation_sling_hi_anti : global.player_animation_sling_hi_anti_disarmed;
				break;
			} else  {
				a = armed ? global.player_animation_sling_anti : global.player_animation_sling_anti_disarmed;
			}
			break;
		case PlayerState.SLING_SWING:
			if get_hi_attack_player(id, 10) {
				a = armed ? global.player_animation_sling_hi_swing : global.player_animation_sling_hi_swing_disarmed;
				break;
			} else  {
				a = armed ? global.player_animation_sling_swing : global.player_animation_sling_swing_disarmed;
			}
			break;
		case PlayerState.SLING_FOLLOW:
			if get_hi_attack_player(id, 10) {
				a = armed ? global.player_animation_sling_hi_follow : global.player_animation_sling_hi_follow_disarmed;
				break;
			} else  {
				a = armed ? global.player_animation_sling_follow : global.player_animation_sling_follow_disarmed;
			}
			break;
		case PlayerState.ATTACK_CHARGE_CANCEL:
			a = armed ? global.player_animation_attack_cancel : global.player_animation_attack_cancel_disarmed;
			break;
		case PlayerState.BLOCK:
			a = hiblock == 1 ? global.player_animation_block_hi : global.player_animation_block_lo;
			break;
		case PlayerState.BLOCK_FOLLOW:
			if block_success == true {
				a = hiblock == 1 ? global.player_animation_block_hi_recoil : global.player_animation_block_lo_recoil;
				break;
			} else {
				a = global.player_animation_block_failure;
				break;
			}
		case PlayerState.DEAD:
			a = global.player_animation_death;
			break;
		case PlayerState.PAIN:
			a = armed == true ? global.player_animation_pain : global.player_animation_pain_disarmed;
			break;
		case PlayerState.KICK_ANTI:
			a = armed == true ? global.player_animation_kick_anti : global.player_animation_kick_anti_disarmed;
			break;
		case PlayerState.KICK_SWING:
			a = armed == true ? global.player_animation_kick_swing : global.player_animation_kick_swing_disarmed;
			break;
		case PlayerState.KICK_FOLLOW:
			a = armed == true ? global.player_animation_kick_follow : global.player_animation_kick_follow_disarmed;
			break;
	}
	if a == noone {
		show_debug_message("No animation was found in global declarations.");
		return;
	}
	if array_length(a) != 3 {
		show_debug_message("Animation array was not the right length.");
		return;
	}
	SetPlayerAnimation(a[0], a[1], a[2]);
}

function check_frame_sounds() {
	if sprite_index == global.player_animation_walk[0] || sprite_index == global.player_animation_walk_sling_charge[0] || sprite_index == global.player_animation_walk_sword_charge[0] || sprite_index == global.player_animation_walk_disarmed[0] || sprite_index == global.player_animation_walk_sling_charge_disarmed[0]{
		if image_index == 2{
			if abs(hspeed) >= 3
				instance_create_depth(x,y,depth-100, obj_player_walk_dust).image_xscale = facing == Direction.RIGHT ? 1 : -1;
			audio_play_sound(sfx_clay_walk_disarmed, 10, false);
			
			return;
		}
	}
	if sprite_index == global.player_animation_strastep[0] || sprite_index == global.player_animation_strastep_disarmed[0] || sprite_index == global.player_animation_strastep_sword_charge[0] {
		if image_index == 1 || image_index == 2 {
			audio_play_sound(sfx_clay_walk_disarmed, 10, false);
			return;
		}
	}
	if sprite_index == global.player_animation_strastep_sling_charge[0] || sprite_index == global.player_animation_backstep_sling_charge[0] || sprite_index == global.player_animation_backstep_sling_charge_disarmed[0]{
		if image_index == 2{
			audio_play_sound(sfx_clay_walk_disarmed, 10, false);
			return;
		}
	}
}
