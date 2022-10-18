/// @description Code to be executed when player is created
collision_mask = [obj_wall_breakable, obj_Ground, obj_Wall, obj_plate, obj_door,obj_box, obj_elevator, obj_tile_coll, obj_house, obj_tallHouse, obj_longHouse, obj_midHouse, obj_punching_bag];

current_stance = stance.fighting;

audio_group_load(sfx_clay);

#region Master Variables
global.paused = false;
global.showDebugMessages = true; // set to true if you want to print debug messages
pause_flag = false;
#endregion

#region State Variables
current_stance = stance.neutral;
enum PlayerState { IDLE, WALKING, JUMP_ANTI, JUMPING, FALLING, ATTACK_CHARGE_CANCEL,BASIC_ATTACK_ANTI, BASIC_ATTACK_SWING, BASIC_ATTACK_FOLLOW, DASH_ANTI, DASH, DASH_FOLLOW, LOCK, DEAD, KICK_ANTI, KICK_SWING, KICK_FOLLOW, SHEATHING, UNSHEATHING, PLUNGING, BLOCK, BLOCK_FOLLOW, SLING_ANTI, SLING_SWING, SLING_FOLLOW, PAIN, REVIVING };
current_state = _skip_revive ? PlayerState.IDLE : PlayerState.REVIVING;
facing = Direction.RIGHT; // The direction the player is facing
armed = startArmed; // Is the player armed. startArmed is set in the variable menu
sheathed = false;
grounded = false;
hiblock = 0;
block_success = false;
special_fall = 0;
locked_on = noone;
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
global.player_maxJumpWindup = 30; // the max # of frames the player can prepare a jump
global.player_minVertJumpForce = 23.5; // min vertical force applied by a jump
global.player_maxVertJumpForce = 27.5; // max vertical force applied by a jump
global.player_minHoriJumpForce = 5; // min horizontal force applied by a jump
global.player_maxHoriJumpForce = 10; // max horizontal force applied by a jump
global.player_jump_buffer_frames = 20;
#endregion

global.player_attack_turn_buffer = 18;

#region Basic Attack Variables
basic_attack_charge_timer = 0;
global.player_basic_attack_charge_min = 45;
global.player_attack_cancel_frames = 20;
global.player_attackAntiFrames = 5; // # of frames the attack anti is shown
global.player_attackSwingFrames = 18;
global.player_attackFollowFrames = 15;
attackTimer = 0; // Frame counter to determine how long the player has been in each attack state
attack_height = 0;
#endregion

global.player_attack_high_anti_frames = 5;
global.player_attack_high_swing_frames = 30;
global.player_attack_high_follow_frames = 15;
global.player_attack_high_blocked_frames = 12;

global.player_attack_mid_anti_frames = 5;
global.player_attack_mid_swing_frames = 18;
global.player_attack_mid_follow_frames = 15;
global.player_attack_mid_blocked_frames = 12;

global.player_attack_low_anti_frames = 5;
global.player_attack_low_swing_frames = 18;
global.player_attack_low_follow_frames = 18;
global.player_attack_low_blocked_frames = 15;

sling_attack_charge_timer = 0;
global.player_sling_attack_charge_min = 30;
global.player_sling_attack_charge_full = 80;
global.player_sling_anti_frames = 2;
global.player_sling_swing_frames = 6;
global.player_sling_follow_frames = 16;
#region Kick Attack Variables
global.player_kickAntiFrames = 4;
global.player_kickSwingFrames = 25;
global.player_kickFollowFrames = 6;
global.player_kick_force = 5;
kick_held_flag = false;
kick_buffer = -1;
global.player_kick_buffer_time = 10;
#endregion

global.player_sheathFrames = 40;
global.player_unsheathFrames = 20;
sheathTimer = 0;

global.player_plungeFrames = 7;

global.player_block_frames = 45;
global.player_block_active_frames = 15;
global.player_block_success_frames = 25;
global.player_block_failure_frames = 35;

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
animation_type_current = animation_type.loop;
animation_fps_current = 10;
animation_frame_counter = 0;
#endregion

layer_create(-300, "PlayerTools");
instance_create_layer(x,y,"PlayerTools", obj_player_attackEffect);
instance_create_layer(x,y,"PlayerTools", obj_player_hitbox);
instance_create_layer(x,y,"PlayerTools", obj_player_hurtbox);
if startArmed == true instance_create_layer(x,y,"PlayerTools", obj_player_sword);
if instance_exists(obj_cam_position) == false instance_create_layer(x,y,"PlayerTools", obj_cam_position);

#region Animation Variables
draw_hat = false;
draw_shirt = true;
draw_shoes = true;
#endregion

#region  State Machine
function PlayerStateBasedMethods()
{
	// show_debug_message(player_state_to_string(current_state));
	if current_state != PlayerState.KICK_ANTI kick_held_flag = false;
	
	if jump_buffer > 0 jump_buffer --;
	else if jump_buffer < 0 jump_buffer ++;
	if kick_buffer > 0 kick_buffer--;
	if input_check_pressed(input_action.jump) && jump_buffer >= 0{
		jump_buffer = global.player_jump_buffer_frames;
	}
	
	if input_check_pressed(input_action.attack) && (
		current_state == PlayerState.IDLE ||
		current_state == PlayerState.WALKING ||
		current_state == PlayerState.JUMPING ||
		current_state == PlayerState.FALLING
	){
		kick_buffer = global.player_kick_buffer_time;
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
			// Go to walk if you are moving
			if abs(hspeed) > 0.1 && current_state == PlayerState.IDLE{
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
			if abs(hspeed) <= 0.1 {
				to_idle();
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
			state_timer ++;
			if state_timer > 5 && collision_check_edge(x,y,spr_clay_n_collision,Direction.DOWN, collision_mask) {
				to_idle();
			}
			break;
		case PlayerState.FALLING:
			if !check_falling(){
				audio_play_sound(sfx_clay_land, 5, false);
				instance_create_depth(x,y,depth-100, obj_player_land_dust);
				to_idle();
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
		case PlayerState.DEAD:
			if state_timer != -1 state_timer ++;
			if state_timer > 60 {
				show_debug_message("Spawning game over screen");
				instance_create_depth(camera_get_view_x(view_camera[0]), camera_get_view_y(view_camera[0]),-1000,obj_gameover);
				if instance_exists(obj_Moose) obj_Moose.to_sleep();
				state_timer = -1;
			}
	}
}

function lock_on() {
	if locked_on == obj_Moose && instance_exists(obj_Moose) {
		facing = obj_Moose.x < x ? Direction.LEFT : Direction.RIGHT;
	}
	
	if input_check(input_action.face){
		if instance_exists(obj_Moose) {
			locked_on = obj_Moose;
		} else {
			locked_on = facing;
		}
	} else {
		locked_on = noone;
	}
}

function to_kick_anti() {
	kick_buffer = 0;
	kick_held_flag = true;
	state_timer = global.player_kickAntiFrames;
	current_state = PlayerState.KICK_ANTI;
	kick_anti();
}
function kick_anti() {
	hspeed += facing == Direction.RIGHT ? .5 : -.5;
	if input_check(input_action.attack) == false kick_held_flag = false;
	if state_timer <= 0 {
		to_kick_swing();
		return;
	}
	state_timer--;
}
function to_kick_swing() {
	if kick_held_flag && input_check(input_action.attack) && armed {
		basic_attack_charge_timer = global.player_kickAntiFrames;
		to_idle();
		return;
	}
	
	state_timer = global.player_kickSwingFrames;
	current_state = PlayerState.KICK_SWING;
	hspeed += facing == Direction.RIGHT ? global.player_kick_force : -1 * global.player_kick_force;
	instance_create_depth(x,y,depth-100, obj_player_walk_dust).image_xscale = facing == Direction.RIGHT ? 1 : -1;
	kick_swing();
}
function kick_swing() {
	//show_debug_message(player_state_to_string(current_state));
	//show_debug_message(state_timer);
	if state_timer <= 0 {
		to_kick_follow();
		return;
	}
	state_timer --;
	//show_debug_message(state_timer);
}
function to_kick_follow() {
	state_timer = global.player_kickFollowFrames;
	current_state = PlayerState.KICK_FOLLOW;
	kick_follow();
}
function kick_follow() {
	if state_timer <= 0 {
		to_idle();
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
		to_idle();
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
	
	if vspeed > 0 && place_meeting(x,y+2,obj_elevator) {
		return false;
	}
	
	if vspeed > 0 && !collision_check_edge(x,y,spr_clay_n_collision, Direction.DOWN, collision_mask) {
		GoToPlayerFall();
		return true;
	}
	special_fall = 0;
	return false;
}

function attack_cancel() {
	state_timer --;
	if state_timer <= 0 {
		to_idle();
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
	if input_check_pressed(input_action.attack){
		if input_check(input_action.up) and not input_check(input_action.down) {
			attack_height = 2;
		} else if input_check(input_action.down) and not input_check(input_action.up) {
			attack_height = 0;
		} else {
			attack_height = 1;
		}
		GoToPlayerBasicAttack();
		return;
	}
	if basic_attack_charge_timer == 0 return;
	
	if basic_attack_charge_timer == global.player_basic_attack_charge_min {
		instance_create_depth(x,y,depth-10, obj_player_charge_spark);
		audio_play_sound(sfx_sword_anti, 10, false);
		basic_attack_charge_timer ++;
	}
	
	if basic_attack_charge_timer == 0 && input_check_pressed(input_action.attack) && sling_attack_charge_timer == 0{
		basic_attack_charge_timer ++;
	} else if basic_attack_charge_timer > 0 && input_check(input_action.attack) {
		basic_attack_charge_timer ++;
	} else if basic_attack_charge_timer > 0 && basic_attack_charge_timer < global.player_basic_attack_charge_min && !input_check(input_action.attack) {
		//to_attack_cancel();
		basic_attack_charge_timer = 0;
		to_kick_swing();
	} else if basic_attack_charge_timer > global.player_basic_attack_charge_min && !input_check(input_action.attack) {
		basic_attack_charge_timer = 0;
		audio_play_sound(sfx_sword_swing, 10, false);
		GoToPlayerBasicAttack();
	}
}
function sling_attack_charge() {
	if sling_attack_charge_timer == 0 && input_check_pressed(input_action.sling) && basic_attack_charge_timer == 0{
		//show_debug_message("Began charging sling");
		sling_attack_charge_timer ++;
	} else if sling_attack_charge_timer > 0 && input_check(input_action.sling) {
		//show_debug_message("continue charging sling");
		sling_attack_charge_timer ++;
	} else if sling_attack_charge_timer > 0 && sling_attack_charge_timer < global.player_sling_attack_charge_min && !input_check(input_action.sling) {
		//show_debug_message("release sling early");
		to_idle();
		sling_attack_charge_timer = 0;
	} else if sling_attack_charge_timer > global.player_sling_attack_charge_min && !input_check(input_action.sling) {
		//show_debug_message("release sling good");
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
		to_idle();
	}
}

function check_blocks() {
	//if !armed return;
	if input_check_pressed(input_action.block) {
		if input_check(input_action.up) && !input_check(input_action.down) {
			hiblock = 1;
		} else {
			hiblock = 0;
		}
		hiblock = 0;
		to_block();
		return true;
	}
	return false;
}

function to_block() {
	if hiblock == 1 {
		instance_create_depth(x,y,depth-100, obj_player_hi_block_spark);
	} else {
		instance_create_depth(x,y,depth-100, obj_player_lo_block_spark);
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
	//show_debug_message(success);
	if !success {
		instance_create_depth(x,y,depth+10, obj_question_mark);
		audio_play_sound(sfx_clay_confused,10,false);
	}
	current_state = PlayerState.BLOCK_FOLLOW;
	block_success = success;
	state_timer = success ? global.player_block_success_frames : global.player_block_failure_frames;
}
function block_follow() {
	state_timer--;
	if state_timer < 0 {
		to_idle();
	}
}

function GoToPlayerDead()
{
	current_state = PlayerState.DEAD;
	state_timer = 0;
	audio_play_sound(sfx_clay_die,0,false);
	if instance_exists(obj_music_controller) obj_music_controller.pause();
	instance_deactivate_object(obj_player_hitbox);
	instance_deactivate_object(obj_player_hurtbox);
}

function to_idle()
{
	current_state = PlayerState.IDLE;
}
function GoToPlayerJumpAnti()
{
	var g = collision_check_edge(x,y,spr_clay_n_collision,Direction.DOWN,collision_mask) == false;
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
	if OneWalkKeyHeld() && input_check(input_action.right)
	{
		hspeed += jumpTimer >= global.player_maxJumpWindup ? global.player_maxHoriJumpForce : global.player_minHoriJumpForce;
	}
	else if OneWalkKeyHeld() && input_check(input_action.left)
	{
		hspeed -= jumpTimer >= global.player_maxJumpWindup ? global.player_maxHoriJumpForce : global.player_minHoriJumpForce;
	}
	state_timer =0;
	current_state = PlayerState.JUMPING;
}
function GoToPlayerWalk()
{
	current_state = PlayerState.WALKING;
	
	if input_check(input_action.left) lastDashTapDirection = Direction.LEFT;
	else if input_check(input_action.right) lastDashTapDirection = Direction.RIGHT;
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
		//show_debug_message(get_hi_attack_player(id,5));
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
		to_idle();
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
		to_idle();
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
					to_idle();
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
					to_idle();
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
	
	if input_check(input_action.left)
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
	else if input_check(input_action.right)
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
		to_idle();
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
		to_idle();
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
		to_idle();
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
	if input_check(input_action.left) && !input_check(input_action.right)
	{
		hspeed -= curAc;
	}
	// Right movement
	else if input_check(input_action.right) && !input_check(input_action.left)
	{
		hspeed += curAc;
	}
	
	if hspeed > 0 && input_check(input_action.right) && locked_on == noone && basic_attack_charge_timer <= global.player_attack_turn_buffer && sling_attack_charge_timer <= global.player_attack_turn_buffer facing = Direction.RIGHT;
	else if hspeed < 0 && input_check(input_action.left) && locked_on == noone && basic_attack_charge_timer<= global.player_attack_turn_buffer && sling_attack_charge_timer <= global.player_attack_turn_buffer facing = Direction.LEFT;
	
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
					to_idle();
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
	if jumpTimer == global.player_maxJumpWindup {
		instance_create_depth(x,y,depth-100,obj_player_jump_charge).image_xscale = image_xscale;
		audio_play_sound(sfx_clay_hit, -2, false);
	}
	if (jumpTimer > global.player_minJumpWindup && input_check(input_action.jump) == false)
	{
		GoToPlayerJump();
	}
}

function PlayerAttack()
{
	var anti_f = noone;
	var swing_f = noone;
	var follow_f = noone;
	var blocked_f = noone;
	var anti_a = noone;
	var swing_a = noone;
	var follow_a = noone;
	var blocked_a = noone;
	if attack_height == 0 {
		anti_f = global.player_attack_low_anti_frames;
		swing_f = global.player_attack_low_swing_frames;
		follow_f = global.player_attack_low_follow_frames;
		blocked_f = global.player_attack_low_blocked_frames;
		anti_a = global.player_animation_attack_low_anti;
		swing_a = global.player_animation_attack_low_swing;
		follow_a = global.player_animation_attack_low_follow;
		blocked_a = global.player_animation_attack_low_blocked;
	} else if attack_height = 1 {
		anti_f = global.player_attack_mid_anti_frames;
		swing_f = global.player_attack_mid_swing_frames;
		follow_f = global.player_attack_mid_follow_frames;
		blocked_f = global.player_attack_mid_blocked_frames;
		anti_a = global.player_animation_attack_mid_anti;
		swing_a = global.player_animation_attack_mid_swing;
		follow_a = global.player_animation_attack_mid_follow;
		blocked_a = global.player_animation_attack_mid_blocked;
	} else if attack_height = 2 {
		anti_f = global.player_attack_high_anti_frames;
		swing_f = global.player_attack_high_swing_frames;
		follow_f = global.player_attack_high_follow_frames;
		blocked_f = global.player_attack_high_blocked_frames;
		anti_a = global.player_animation_attack_high_anti;
		swing_a = global.player_animation_attack_high_swing;
		follow_a = global.player_animation_attack_high_follow;
		blocked_a = global.player_animation_attack_high_blocked;
	}
	
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
			attackTimer = swing_f;
		}
		if current_state == PlayerState.BASIC_ATTACK_SWING && attackTimer <= 0
		{
			current_state = PlayerState.BASIC_ATTACK_FOLLOW;
			special_fall = 1;
			obj_player_attackEffect.HidePlayerAttack();
			attackTimer = follow_f;
		}
		if current_state == PlayerState.BASIC_ATTACK_FOLLOW && attackTimer <= 0
		{
			to_idle();
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
			to_idle();
		}
	}
}

function PlayerPickupSword()
{
	if current_state == PlayerState.DEAD return;
	if !armed && place_meeting(x,y,obj_player_sword) && obj_player_sword.SwordCanBePickedUp()
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
		//hitstun(.,false);
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
	if current_state == PlayerState.REVIVING return;
	
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
	var anti_a = noone;
	var swing_a = noone;
	var follow_a = noone;
	var blocked_a = noone;
	if attack_height == 0 {
		anti_a = global.player_animation_attack_low_anti;
		swing_a = global.player_animation_attack_low_swing;
		follow_a = global.player_animation_attack_low_follow;
		blocked_a = global.player_animation_attack_low_blocked;
	} else if attack_height = 1 {
		anti_a = global.player_animation_attack_mid_anti;
		swing_a = global.player_animation_attack_mid_swing;
		follow_a = global.player_animation_attack_mid_follow;
		blocked_a = global.player_animation_attack_mid_blocked;
	} else if attack_height = 2 {
		anti_a = global.player_animation_attack_high_anti;
		swing_a = global.player_animation_attack_high_swing;
		follow_a = global.player_animation_attack_high_follow;
		blocked_a = global.player_animation_attack_high_blocked;
	}
	
	var a = noone;
	switch(current_state) {
		case PlayerState.IDLE:
			if basic_attack_charge_timer > 0 {
				a = global.player_animation_idle_sword_charge;
				break;
			} else if sling_attack_charge_timer > 0 {
				a = armed ? global.player_animation_idle_sling_charge : global.player_animation_idle_sling_charge_disarmed;
				if sling_attack_charge_timer < global.player_sling_attack_charge_min {
					a = armed ? [spr_player_aimStart,6,AnimationType.LOOP] : [spr_player_aimStart_disarmed,6,AnimationType.LOOP];
				}
				break;
			} else if armed {
				a = locked_on != noone ? global.player_animation_stra_idle : global.player_animation_idle;
			} else {
				a = locked_on != noone ? global.player_animation_stra_idle_disarmed : global.player_animation_idle_disarmed;
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
					if sling_attack_charge_timer < global.player_sling_attack_charge_min {
						a = armed ? [spr_player_aimStartWalk,6,AnimationType.LOOP] : [spr_player_aimStartWalk_disarmed,6,AnimationType.LOOP];
					}
					break;
				} else if armed {
					a = locked_on != noone ? global.player_animation_strastep : global.player_animation_walk;
					break;
				} else {
					a = locked_on != noone ? global.player_animation_strastep_disarmed : global.player_animation_walk_disarmed;
				}
			}
			// Backward
			else {
				if basic_attack_charge_timer > 0 {
					a = global.player_animation_backstep_sword_charge;
					break;
				} else if sling_attack_charge_timer > 0 {
					a = armed ? global.player_animation_backstep_sling_charge : global.player_animation_backstep_sling_charge_disarmed;
					if sling_attack_charge_timer < global.player_sling_attack_charge_min {
						a = armed ? [spr_player_aimStartWalkBack,6,AnimationType.LOOP] : [spr_player_aimStartWalkBack_disarmed,6,AnimationType.LOOP];
					}
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
				if sling_attack_charge_timer < global.player_sling_attack_charge_min {
					a = armed ? [spr_player_aimStartJumpAnti,6,AnimationType.LOOP] : [spr_player_aimStartJumpAnti_disarmed,6,AnimationType.LOOP];
				}
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
				if sling_attack_charge_timer < global.player_sling_attack_charge_min {
					a = armed ? [spr_player_aimStartJump,6,AnimationType.LOOP] : [spr_player_aimStartJump_disarmed,6,AnimationType.LOOP];
				}
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
				a = armed ? global.player_animation_fall_sling_charge : global.player_animation_fall_sling_charge_disarmed;
				if sling_attack_charge_timer < global.player_sling_attack_charge_min {
					a = armed ? [spr_player_aimStartFall,6,AnimationType.LOOP] : [spr_player_aimStartFall_disarmed,6,AnimationType.LOOP];
				}
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
			a = anti_a;
			break;
		case PlayerState.BASIC_ATTACK_SWING:
			a = swing_a;
			break;
		case PlayerState.BASIC_ATTACK_FOLLOW:
			a = follow_a;
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
			if !armed
			{
			a = global.player_animation_block_lo_disarmed;
			}
			break;
		case PlayerState.BLOCK_FOLLOW:
			if block_success == true {
				a = hiblock == 1 ? global.player_animation_block_hi_recoil : global.player_animation_block_lo_recoil;
				if !armed
				{
					a = global.player_animation_block_lo_recoil_disarmed;
				}
			} else {
				a = global.player_animation_block_failure;	
				if !armed {
					a = global.player_animation_block_lo_failure_disarmed;
				}			
			}
				break;
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
		case PlayerState.REVIVING:
			if sprite_index != spr_player_resurrect{
				sprite_index = spr_player_resurrect;
				image_index = 0;
			}
			instance_activate_object(obj_player_hitbox);
			instance_activate_object(obj_player_hurtbox);
			return;
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
	
	animation_set(a);
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

function player_state_to_string(_state) {
	switch (_state) {
		case PlayerState.ATTACK_CHARGE_CANCEL: return "attack_charge_cancel"; break;
		case PlayerState.BASIC_ATTACK_ANTI: return "basic_attack_anti"; break;
		case PlayerState.BASIC_ATTACK_FOLLOW: return "basic_attack_follow"; break;
		case PlayerState.BASIC_ATTACK_SWING: return "basic_attack_swing"; break;
		case PlayerState.BLOCK: return "block"; break;
		case PlayerState.BLOCK_FOLLOW: return "block_follow"; break;
		case PlayerState.DASH: return "dash"; break;
		case PlayerState.DASH_ANTI: return "dash_anti"; break;
		case PlayerState.DASH_FOLLOW: return "dash_follow"; break;
		case PlayerState.DEAD: return "dead"; break;
		case PlayerState.FALLING: return "falling"; break;
		case PlayerState.IDLE: return "idle"; break;
		case PlayerState.JUMP_ANTI: return "jump_anti"; break;
		case PlayerState.JUMPING: return "jumping"; break;
		case PlayerState.KICK_ANTI: return "kick_anti"; break;
		case PlayerState.KICK_FOLLOW: return "kick_follow"; break;
		case PlayerState.KICK_SWING: return "kick_swing"; break;
		case PlayerState.LOCK: return "lock"; break;
		case PlayerState.PAIN: return "pain"; break;
		case PlayerState.PLUNGING: return "plunging"; break;
		case PlayerState.REVIVING: return "reviving"; break;
		case PlayerState.SHEATHING: return "sheathing"; break;
		case PlayerState.SLING_ANTI: return "sling_anti"; break;
		case PlayerState.SLING_FOLLOW: return "sling_follow"; break;
		case PlayerState.SLING_SWING: return "sling_swing"; break;
		case PlayerState.UNSHEATHING: return "unsheathing"; break;
		case PlayerState.WALKING: return "walking"; break;
	}
}
