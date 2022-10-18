audio_group_load(sfx_moose);

while instance_exists(obj_enemy_sword) instance_destroy(obj_enemy_sword);

instance_create_layer(0,0,layer, obj_enemy_attackEffect);
instance_create_layer(0,0,layer, obj_enemy_blockbox);
instance_create_layer(0,0,layer, obj_enemy_hitbox);
instance_create_layer(0,0,layer, obj_enemy_hurtbox);
//instance_create_layer(0,0,layer,obj_enemy_sword);
enum MooseState { IDLE, WANDER, SLIDE_ANTI, SLIDE, CHARGE_ANTI, CHARGE, WAITING, HIT, BLOCK, LOCK, DEAD, PULLING, LUNGE_ANTI, LUNGE, STAB_ANTI, STAB, JUMP_ANTI, JUMP, DIVE_ANTI, DIVE, STUCK, SPIN, PROJECTILE_ANTI, PROJECTILE, PROJECTILE_FOLLOW, STUN, BURP_ANTI, BURP_SWING, BURP_FOLLOW, SLEEP,PANIC_WAIT};

time_limit_jump = 240;

max_hp = 10;
hp = max_hp;
panicking = false;
hp_regen_timer = 0;
hp_regen_time_long = 600;
hp_regen_time_short = 100;

dead_timer = 90;

collision_mask = [obj_tile_coll, obj_door, obj_plate, obj_elevator];
collision_mask = [obj_tile_coll, obj_door, obj_plate, obj_elevator];

current_state = MooseState.IDLE;
armed = true;
armor = 1;
facing = Direction.LEFT;
state_timer = 0;

invuln = false;
invulnTimer = 0;

grounded = false;

// Idle
wanderCounter = 0;
wandersPerIdle = random(global.moose_wandersPerIdle);

// Wander

// Lunge
lunge_starting_pos = [x,y];
// Jump
jump_target = [0,0];
jump_direction = Direction.LEFT;

// Animations
currentFPI = 1;
currentAnimType = AnimationType.FIRST_FRAME;
animFrameCounter = 0;

// Retalliation
player_too_close_timer = 0;
head_jump_counter = 0;

if start_pulling current_state = MooseState.PULLING;

function UpdateMooseState()
{
	if current_state == MooseState.PULLING return;
	
	state_timer --;
	switch current_state
	{
		case MooseState.IDLE:
			if state_timer <= 0
			{
				if wanderCounter >= wandersPerIdle
				{
					wanderCounter = 0;
					wandersPerIdle = random(global.moose_wandersPerIdle);
					choose_attack();
					return;
				}
				MooseIdleToWander();
				return;
			}
			break;
		case MooseState.WANDER:
			if state_timer <= 0
			{
				MooseWanderToIdle();
				return;
			}
			break;
		case MooseState.SLIDE_ANTI:
			if state_timer <= 0
			{
				MooseSlideAntiToSlide();
				return;
			}
			break;
		case MooseState.SLIDE:
			if abs(hspeed) <= 0.0001
			{
				MooseSlideToIdle();
				return;
			}
			break;
		case MooseState.CHARGE_ANTI:
			if state_timer <= 0
			{
				MooseChargeAntiToCharge();
				return;
			}
			break;
		case MooseState.CHARGE:
			break;
		case MooseState.WAITING:
			if armed || obj_enemy_sword.current_state == SwordState.STUCK_FLOOR
			{
				MooseWaitToIdle();
				return;
			}
			break;
		case MooseState.HIT:
			state_timer--;
			if state_timer <= 0 {
				to_idle();
			}
			break;
		case MooseState.BLOCK:
			if obj_player_fighting.PlayerNotAttacking()
				MooseWanderToIdle();
			break;
	}
}

function MooseStateBasedActions()
{
	switch current_state
	{
		case MooseState.IDLE:
			panicking = false;
			MooseFacePlayer();
			MooseCheckBlock();
			break;
		case MooseState.WANDER:
			panicking = false;
			MooseFacePlayer();
			MooseWander();
			MooseCheckBlock();
			break;
		case MooseState.CHARGE:
			MooseCharge();
			break;
		case MooseState.LUNGE_ANTI:
			lunge_anti();
			break;
		case MooseState.LUNGE:
			lunge();
			break;
		case MooseState.STAB_ANTI:
			stab_anti();
			break;
		case MooseState.STAB:
			stab();
			break;
		case MooseState.JUMP_ANTI:
			jump_anti();
			break;
		case MooseState.JUMP:
			jump();
			break;
		case MooseState.DIVE_ANTI:
			dive_anti();
			break;
		case MooseState.DIVE:
			dive();
			break;
		case MooseState.STUCK:
			stuck();
			break;
		case MooseState.SPIN:
			spin();
			break;
		case MooseState.PROJECTILE_ANTI:
			projectile_anti();
			break;
		case MooseState.PROJECTILE:
			projectile();
			break;
		case MooseState.STUN:
			stun();
			break;
		case MooseState.BURP_ANTI:
			burp_anti();
			break;
		case MooseState.BURP_SWING:
			burp_swing();
			break;
		case MooseState.BURP_FOLLOW:
			burp_follow();
			break;
		case MooseState.SLEEP:
			sleep();
			break;
		case MooseState.PANIC_WAIT:
			panic_wait();
			break;
	}
}

function to_panic_wait(){
	state_timer = global.moose_panic_wait_time;
	current_state = MooseState.PANIC_WAIT;
}
function panic_wait(){
	state_timer --;
	if state_timer < 0 {
		choose_panic_attack();
	}
}

function to_sleep() {
	current_state = MooseState.SLEEP;
	if instance_exists(obj_player_fighting) {
		var i = 1;
		while (place_meeting(x,y,obj_player_fighting) || collision_check_edge(x,y,spr_enemy_collision,Direction.LEFT, collision_mask) || collision_check_edge(x,y,spr_enemy_collision,Direction.RIGHT, collision_mask)) {
			x += i;
			i = -1 * sign(i) * (abs(i)+1);
		}
	}
}

function sleep() {
	if instance_exists(obj_player_fighting) && obj_player_fighting.armed {
		if instance_exists(obj_music_controller) obj_music_controller.resume();
		to_idle();
	}
}

function choose_attack() {
	
	var dist_to_player = distance_to_object(obj_player_fighting);
	switch get_phase() {
		case 1:
			if dist_to_player < global.moose_attack_close_distance {
				to_lunge_anti();
				return;
			}
			if dist_to_player > global.moose_attack_far_distance {
				MooseIdleToChargeAnti();
				return;
			}
			var r = random(1);
			if r < 1/3 {
				MooseIdleToChargeAnti();
				return;
			} else {
				MooseIdleToSlideAnti();
				return;
			}
			break;
		case 2:
			if dist_to_player < global.moose_attack_close_distance {
				to_lunge_anti();
				return;
			}
			
			var r = random(1);
			if r < 4/7 {
				MooseIdleToSlideAnti();
				return;
			} else {
				to_projectile_anti();
			}
			break;
		case 3:
			if dist_to_player > global.moose_attack_safe_distance {
				MooseIdleToChargeAnti();
				return;
			}else{
				to_projectile_anti();
				return;
			}
			break;
	}
}

function MooseCheckBlock()
{
	if obj_player_fighting.current_state == PlayerState.BASIC_ATTACK_ANTI && distance_to_object(obj_player_fighting) <= global.moose_blockDistance
	{
		MooseToBlock();
	}
}

function get_gravity() {
	switch current_state {
		case MooseState.JUMP:
			return 0;
			break;
		case MooseState.DIVE_ANTI:
			return 0;
			break;
		case MooseState.DIVE:
			return .5;
			break;
	}
	return 1;
}

function to_burp_anti() {
	current_state = MooseState.BURP_ANTI;
	state_timer = global.moose_burp_anti_time;
	burp_anti();
}
function burp_anti() {
	if state_timer <= 0 {
		to_burp_swing();
	}
	state_timer --;
}
function to_burp_swing() {
	current_state = MooseState.BURP_SWING;
	state_timer = global.moose_burp_swing_time;
	audio_play_sound(sfx_moose_burp, -5, false);
	spawn_shockwave(depth-100,x,y,(obj_player_fighting.x < x ? Direction.LEFT : Direction.RIGHT), 75, 300, Curve.LINEAR);
	burp_swing();
}
function burp_swing() {
	MooseFacePlayer();
	
	if facing == Direction.LEFT {
		hspeed += global.moose_burp_swing_acceleration;
	}else {
		hspeed -= global.moose_burp_swing_acceleration;
	}
	if state_timer <= 0 {
		to_burp_follow();
	}
	state_timer --;
}
function to_burp_follow() {
	current_state = MooseState.BURP_FOLLOW;
	state_timer = global.moose_burp_follow_time;
	burp_follow();
}
function burp_follow() {
	if state_timer <= 0 {
		to_idle();
	}
	state_timer --;
}

function to_stun() {
	if current_state == MooseState.STUN {
		audio_play_sound(sfx_moose_grunt_0,5, false);
		to_idle();
		return;
	}
	current_state = MooseState.STUN;
	audio_play_sound(sfx_moose_stun, 4, false);
	state_timer = global.moose_stun_time;
}
function stun() {
	if state_timer < 0 {
		audio_play_sound(sfx_moose_grunt_0,5, false);
		to_idle();
	}
}

function to_idle() {
	state_timer = floor(random_range(global.moose_minIdleTime, global.moose_maxIdleTime));
	wanderCounter = random(global.moose_wandersPerIdle);
	current_state = MooseState.IDLE;
}

#region lunge and stab
function to_lunge_anti() {
	current_state = MooseState.LUNGE_ANTI;
	state_timer = global.moose_lunge_anti_frames;
	lunge_starting_pos = [x,y];
	facing = obj_player_fighting.x < x ? Direction.LEFT : Direction.RIGHT;
}
function lunge_anti() {
	if state_timer <= 0{
		to_lunge();
	}
}
function to_lunge() {
	current_state = MooseState.LUNGE;
}
function lunge() {
	if (facing == Direction.LEFT && collision_check_edge(x,y,spr_enemy_collision,Direction.LEFT, collision_mask)) ||
	  (facing == Direction.RIGHT && collision_check_edge(x,y,spr_enemy_collision,Direction.RIGHT,collision_mask)) ||
	  distance_to_object(obj_player_fighting) <= global.moose_lunge_target_distance_to_player ||
	  distance_to_point(lunge_starting_pos[0], lunge_starting_pos[1]) > global.moose_lunge_distance_max {
		  to_stab_anti();
		  return;
	  }
	hspeed = facing == Direction.LEFT ? -1 * global.moose_lunge_speed : global.moose_lunge_speed;
}
function to_stab_anti() {
	current_state = MooseState.STAB_ANTI;
	state_timer = global.moose_stab_anti_frames;
}
function stab_anti() {
	if state_timer <= 0 to_stab();
}
function to_stab() {
	audio_play_sound(sfx_moose_swing, 2, false);
	current_state = MooseState.STAB;
	state_timer = global.moose_stab_frames;
}
function stab() {
	if state_timer <= 0 MooseWanderToIdle();
}
#endregion

#region jump and dive and spin
function to_jump_anti() {
	current_state = MooseState.JUMP_ANTI;
	state_timer = global.moose_jump_anti_frames;
	facing = obj_player_fighting.x < x ? Direction.LEFT : Direction.RIGHT;
}
function jump_anti() {
	if state_timer <= 0 to_jump();
}
function to_jump() {
	audio_play_sound(sfx_moose_jump, 2, false);
	current_state = MooseState.JUMP;
	state_timer = 0;
	jump_target = [obj_player_fighting.x, y-global.moose_jump_y_height];
	jump_direction = jump_target[0] < x ? Direction.LEFT : Direction.RIGHT;
}
function jump() {
	hspeed = jump_direction == Direction.LEFT ? -1 * global.moose_jump_x_speed : global.moose_jump_x_speed;
	vspeed = -1 * global.moose_jump_y_speed;
	
	// Overshot on y
	if y <= jump_target[1] {
		vspeed = 0;
		y = jump_target[1]
	}
	// Overshot on x
	if (jump_direction == Direction.LEFT && x <= jump_target[0]) ||
	  (jump_direction == Direction.RIGHT && x >= jump_target[0]) {
		hspeed = 0;
		x = jump_target[0];
	}
	
	// State ends when we are at the right position
	// Or if we've collided in both directions
	if (x == jump_target[0] && y == jump_target[1]) ||
	((jump_direction == Direction.LEFT && collision_check_edge(x,y,spr_enemy_collision,Direction.LEFT,collision_mask)) || (jump_direction == Direction.RIGHT &&collision_check_edge(x,y,spr_enemy_collision,Direction.RIGHT,collision_mask)) ||
	collision_check_edge(x,y,spr_enemy_collision,Direction.UP,collision_mask)) {
		to_dive_anti();
	}
	
	state_timer ++;
	if state_timer >= time_limit_jump {
		to_dive_anti();
	}
}
function to_dive_anti() {
	current_state = MooseState.DIVE_ANTI;
	state_timer = global.moose_dive_anti_frames;
}
function dive_anti() {
	if state_timer <= 0 to_dive();
}
function to_dive() {
	audio_play_sound(sfx_moose_plunge, 2, false);
	current_state = MooseState.DIVE;
	vspeed = global.moose_dive_speed;
}
function dive() {
	with obj_enemy_hitbox {
		if place_meeting(x,y,obj_player_hurtbox) {
			with obj_Moose {
				MooseWanderToIdle();
				knock_away_from(obj_Moose,obj_player_fighting.x + 300*(obj_player_fighting.x > x ? 1 : -1), obj_player_fighting.y, 20);
				return;
			}
		}
	}
	if collision_check_edge(x,y+10,spr_enemy_collision,Direction.DOWN,collision_mask) {
		while !collision_check_edge(x,y,spr_enemy_collision, Direction.DOWN, collision_mask) {
			y++;
		}
		// Spawn shockwaves
		spawn_shockwave(depth-100,x,y+150,Direction.LEFT, 45, 200, Curve.ROOT);
		spawn_shockwave(depth-100,x,y+150,Direction.RIGHT, 45, 200, Curve.ROOT);
		
		if armor > 0 {
			to_stuck();
			return;
		} else {
			to_spin();
			return;
		}
	}
}
function to_stuck() {
	if armor < 1 {
		to_spin();
		return;
	}
	current_state = MooseState.STUCK;
	state_timer = global.moose_stuck_frames;
}
function stuck() {
	if state_timer <= 0 to_spin();
}
function to_spin() {
	current_state = MooseState.SPIN;
	hspeed = obj_player_fighting.x < x ? global.moose_spin_x_speed : -1*global.moose_spin_x_speed;
	vspeed = global.moose_spin_y_speed;
	y += global.moose_spin_y_offset;
}
function spin() {
	if collision_check_edge(x,y,spr_enemy_collision,Direction.DOWN,collision_mask) {
		panicking = false;
		MooseWanderToIdle();
		audio_play_sound(sfx_moose_land, 3, false);
	}
}
#endregion

function to_projectile_anti() {
	current_state = MooseState.PROJECTILE_ANTI;
}
function projectile_anti() {
	if obj_player_fighting.x < x {
		hspeed += global.moose_wanderAccel;
		if collision_check_edge(x,y,spr_enemy_collision, Direction.RIGHT, collision_mask) {
			to_projectile();
			return;
		}
	} else {
		hspeed -= global.moose_wanderAccel;
		if collision_check_edge(x,y,spr_enemy_collision, Direction.LEFT, collision_mask) {
			to_projectile();
			return;
		}
	}
}
function to_projectile() {
	current_state = MooseState.PROJECTILE;
	state_timer = 90;
	var furthest = obj_player_fighting.x < x ? -1400 : 1400;
	var nearest = obj_player_fighting.x < x ? -200 : 200;
	var projectile_count = 6;
	var blank = floor(random(projectile_count));
	for (var i = 0; i < projectile_count; i++) {
		if i == blank continue;
		var inst = instance_create_depth(x,y,-100,obj_moose_projectile);
		inst.start_x = x;
		inst.start_y = y;
		inst.arc_width = lerp(nearest, furthest, i/projectile_count);
		inst.arc_height = -600;
	}
}
function projectile() {
	//show_debug_message(state_timer);
	if state_timer <= 0 MooseWanderToIdle();
}

function MooseCharge()
{
	if facing == Direction.LEFT {
		hspeed -= global.moose_chargeAccel;
		if collision_check_edge(x,y,spr_enemy_collision,Direction.LEFT, collision_mask) || (collision_check_edge(x,y,spr_enemy_collision,Direction.LEFT, [obj_player_fighting]) && collision_check_edge_other(obj_player_fighting, obj_player_fighting.x, obj_player_fighting.y, spr_clay_n_collision, Direction.LEFT, obj_player_fighting.collision_mask))  {
			MooseChargeToWait();
		}
		return;
	}
	else {
		hspeed += global.moose_chargeAccel;
		if collision_check_edge(x,y,spr_enemy_collision,Direction.RIGHT, collision_mask)|| (collision_check_edge(x,y,spr_enemy_collision,Direction.RIGHT, [obj_player_fighting]) && collision_check_edge_other(obj_player_fighting, obj_player_fighting.x, obj_player_fighting.y, spr_clay_n_collision, Direction.RIGHT, obj_player_fighting.collision_mask)) {
			MooseChargeToWait();
		}
		return;
	}
}

function MooseWander()
{
	if wanderDir == Direction.LEFT hspeed -= global.moose_wanderAccel;
	else hspeed += global.moose_wanderAccel;
}

function MooseFacePlayer()
{
	if obj_player_fighting.x < x facing = Direction.LEFT;
	else facing = Direction.RIGHT;
}

function MoosePickupSword()
{
	if instance_exists(obj_enemy_sword) == false return;
	if !armed && place_meeting(x,y,obj_enemy_sword) && obj_enemy_sword.EnemySwordCanBePickedUp()
	{
		armed = true;
		instance_destroy(obj_enemy_sword);
	}
}

function MooseToDead()
{
	current_state = MooseState.DEAD;
	instance_deactivate_object(obj_enemy_hitbox);
	instance_deactivate_object(obj_enemy_hurtbox);
	instance_deactivate_object(obj_enemy_blockbox);
}


function MooseToBlock()
{
	if !armed
	{
		MooseIdleToChargeAnti();
		return;
	}
	
	current_state = MooseState.BLOCK;
}

function MooseChargeToWait()
{
	if instance_exists(obj_enemy_sword)
		obj_enemy_sword.to_fall();
	audio_play_sound(sfx_moose_crash,2,false);
	current_state = MooseState.WAITING;
}

function MooseIdleToChargeAnti()
{
	audio_play_sound(sfx_moose_charge_anti,2, false);
	
	if !armed {
		if obj_enemy_sword.x < x facing = Direction.LEFT;
		else facing = Direction.RIGHT;
	} else {
		if obj_player_fighting.x < x facing = Direction.LEFT;
		else facing = Direction.RIGHT;
	}
	
	state_timer = global.moose_chargeAntiTime;
	
	current_state = MooseState.CHARGE_ANTI;
}

function MooseChargeAntiToCharge()
{
	audio_play_sound(sfx_moose_charge, 2, false);
	current_state = MooseState.CHARGE;
}

function MooseIdleToWander()
{
	wanderCounter ++;
	
	// Decide direction to wander
	var distToPlayer = distance_to_object(obj_player_fighting);
	if distToPlayer < global.moose_minDistance
	{
		if obj_player_fighting.x < x wanderDir = Direction.RIGHT;
		else wanderDir = Direction.LEFT;
	}
	else if distToPlayer > global.moose_maxDistance
	{
		if obj_player_fighting.x < x wanderDir = Direction.LEFT;
		else wanderDir = Direction.RIGHT;
	}
	else 
	{
		if random_range(0,1) < 0.5 wanderDir = Direction.LEFT;
		else wanderDir = Direction.RIGHT;
	}
	
	// Decide wander duration
	state_timer = floor(random_range(global.moose_minWanderTime, global.moose_maxWanderTime));
	
	current_state = MooseState.WANDER;
}

function MooseWanderToIdle()
{
	state_timer = floor(random_range(global.moose_minIdleTime, global.moose_maxIdleTime));
	if armor == 0 state_timer = 0;
	
	current_state = MooseState.IDLE;
}

function MooseWaitToIdle()
{
	state_timer = floor(random_range(global.moose_minIdleTime, global.moose_maxIdleTime));
	
	wanderCounter = global.moose_wandersPerIdle - 1;
	
	current_state = MooseState.IDLE;
}

function MooseIdleToSlideAnti()
{
	audio_play_sound(sfx_moose_slide_anti, 2, false);
	
	state_timer = global.moose_slideAntiDuration;
	
	MooseFacePlayer();
	
	current_state = MooseState.SLIDE_ANTI;
}

function MooseSlideAntiToSlide()
{
	audio_play_sound(sfx_moose_slide, 2, false);
	
	if facing == Direction.LEFT hspeed = -global.moose_slideImpulse;
	else hspeed = global.moose_slideImpulse;
	
	current_state = MooseState.SLIDE;
}

function MooseSlideToIdle()
{
	state_timer = floor(random_range(global.moose_minIdleTime, global.moose_maxIdleTime));
	
	current_state = MooseState.IDLE;
}


function SetMooseAnimation(animation, fpi, type)
{
	if sprite_index == animation && currentFPI == fpi && currentAnimType == type return;
	sprite_index = animation;
	currentFPI = fpi;
	currentAnimType = type;
	image_index = 0;
	animFrameCounter = 0;
}

function update_animation() {
	var phase = get_phase();
	switch(current_state) {
		case MooseState.IDLE:
			if phase == 1 {
				if distance_to_object(obj_player_fighting) < 400 {
					var a = spr_moose_blockLo;
				} else {
					var a = spr_moose_idle;
				}
			} else if phase == 2 {
				with(obj_player_fighting) {
					if collision_check_edge(x,y,spr_clay_n_collision, Direction.DOWN, collision_mask) {
						var a = spr_moose_blockLo_helmless;
					} else {
						var a = spr_moose_hiBlock;
					}
				}
			} else { 
				var a = spr_moose_idle_empty;
			}
			SetMooseAnimation(a, global.moose_animation_idle_FPI, global.moose_animation_idle_type);
			break;
		case MooseState.WANDER:
			if phase == 1 {
				if distance_to_object(obj_player_fighting) < 400 {
					var a = global.moose_animation_walk_blockLo;
				} else {
					var a = global.moose_animation_wander;
				}
			} else if phase == 2 {
				with(obj_player_fighting) {
					if collision_check_edge(x,y,spr_clay_n_collision, Direction.DOWN, collision_mask) {
						var a = global.moose_animation_walk_blockLo_helmless;
					} else {
						var a = global.moose_animation_wander_blockHi;
					}
				}
			} else {
				var a = global.moose_animation_wander_disarmed;
			} 
			if (facing == Direction.LEFT && hspeed > 0) || (facing == Direction.RIGHT && hspeed < 0) {
			SetMooseAnimation(a, global.moose_animation_wander_FPI, AnimationType.REVERSE_LOOP);
			}else {
			SetMooseAnimation(a, global.moose_animation_wander_FPI, global.moose_animation_wander_type);
			}
			break;
		case MooseState.SLIDE_ANTI:
			var a = armor > 0 ? global.moose_animation_slideAnti : (armed==true ? global.moose_animation_slideAnti_helmless : global.moose_animation_slideAnti_disarmed);
			SetMooseAnimation(a, global.moose_animation_slideAnti_FPI, global.moose_animation_slideAnti_type);
			break;
		case MooseState.SLIDE:
			var a = armor > 0 ? global.moose_animation_slide : (armed==true ? global.moose_animation_slide_helmless : global.moose_animation_slide_disarmed);
			SetMooseAnimation(a, global.moose_animation_slide_FPI, global.moose_animation_slide_type);
			break;
		case MooseState.CHARGE_ANTI:
			var a = armor > 0 ? global.moose_animation_chargeAnti : (armed==true ? global.moose_animation_chargeAnti_helmless : global.moose_animation_chargeAnti_disarmed);
			SetMooseAnimation(a, global.moose_animation_chargeAnti_FPI, global.moose_animation_chargeAnti_type);
			break;
		case MooseState.CHARGE:
			var a = armor > 0 ? global.moose_animation_charge : (armed==true ? global.moose_animation_charge_helmless : global.moose_animation_charge_disarmed);
			SetMooseAnimation(a, global.moose_animation_charge_FPI, global.moose_animation_charge_type);
			break;
		case MooseState.WAITING:
			var a = armor > 0 ? global.moose_animation_idle : (armed==true ? global.moose_animation_idle_helmless : global.moose_animation_idle_disarmed);
			SetMooseAnimation(a, global.moose_animation_idle_FPI, global.moose_animation_idle_type);
			break;
		case MooseState.HIT:
			var a = armed ? global.moose_animation_hit : (global.moose_animation_hit_helmless);
			SetMooseAnimation(a, global.moose_animation_hit_FPI, global.moose_animation_hit_type);
			break;
			
		case MooseState.LOCK:
			break;
			
		case MooseState.DEAD:
			var a = global.moose_animation_dead;
			SetMooseAnimation(a, global.moose_animation_dead_FPI, global.moose_animation_dead_type);
			break;
			
		case MooseState.PULLING:
			var a = armor > 0 ? global.moose_animation_pulling : (armed==true ? global.moose_animation_pulling : global.moose_animation_pulling);
			SetMooseAnimation(a, global.moose_animation_pulling_FPI, global.moose_animation_pulling_type);
			break;
			
		case MooseState.LUNGE_ANTI:
			var a = armor > 0 ? global.moose_animation_stabAnti : (armed==true ? global.moose_animation_stabAnti_helmless : global.moose_animation_stabAnti_disarmed);
			SetMooseAnimation(a, 1, AnimationType.FIRST_FRAME);
			break;
		case MooseState.LUNGE:
			var a = armor > 0 ? spr_moose_run : (armed==true ? spr_moose_run_helmless : spr_moose_run_empty);
			SetMooseAnimation(a, 8, AnimationType.LOOP);
			break;
		case MooseState.STAB_ANTI:
			var a = armor > 0 ? global.moose_animation_stabAnti : (armed==true ? global.moose_animation_stabAnti_helmless : global.moose_animation_stabAnti_disarmed);
			SetMooseAnimation(a, global.moose_animation_stabAnti_FPI, global.moose_animation_stabAnti_type);
			break;
		case MooseState.STAB:
			var a = armor > 0 ? global.moose_animation_stab : (armed==true ? global.moose_animation_stab_helmless : global.moose_animation_stab_disarmed);
			SetMooseAnimation(a, global.moose_animation_stab_FPI, global.moose_animation_stab_type);
			break;
		case MooseState.JUMP_ANTI:
			var a = armor > 0 ? global.moose_animation_jumpAnti : (armed==true ? global.moose_animation_jumpAnti_helmless : global.moose_animation_jumpAnti_disarmed);
			SetMooseAnimation(a, global.moose_animation_jumpAnti_FPI, global.moose_animation_jumpAnti_type);
			break;
		case MooseState.JUMP:
			var a = armor > 0 ? global.moose_animation_jumping : (armed==true ? global.moose_animation_jumping_helmless : global.moose_animation_jumping_disarmed);
			SetMooseAnimation(a, global.moose_animation_jumping_FPI, global.moose_animation_jumping_type);
			break;
		case MooseState.DIVE_ANTI:
			var a = armor > 0 ? global.moose_animation_plunging : (armed==true ? global.moose_animation_plunging_helmless : global.moose_animation_plunging_disarmed);
			SetMooseAnimation(a, global.moose_animation_plunging_FPI, global.moose_animation_plunging_type);
			break;
		case MooseState.DIVE:
			var a = armor > 0 ? global.moose_animation_plunging : (armed==true ? global.moose_animation_plunging_helmless : global.moose_animation_plunging_disarmed);
			SetMooseAnimation(a, global.moose_animation_plunging_FPI, global.moose_animation_plunging_type);
			break;
		case MooseState.STUCK:
			var a = armor > 0 ? global.moose_animation_stuck : global.moose_animation_stuck_helmless;
			SetMooseAnimation(a, global.moose_animation_stuck_FPI, global.moose_animation_stuck_type);
			break;
		case MooseState.SPIN:
			var a = armor > 0 ? global.moose_animation_spinning : (armed==true ? global.moose_animation_spinning_helmless : global.moose_animation_spinning_disarmed);
			SetMooseAnimation(a, global.moose_animation_spinning_FPI, global.moose_animation_spinning_type);
			break;
		case MooseState.STUN:
			var a = armor > 0 ? spr_moose_staggered : (armed == true ? spr_moose_staggered_helmless : spr_moose_staggered_empty);
			SetMooseAnimation(a, 6, AnimationType.LOOP);
			break;
		case MooseState.PROJECTILE_ANTI:
			var a = noone;
			if armor > 0 a = spr_moose_throwAnti;
			else if armed a = spr_moose_throwAnti_helmless;
			else a = spr_moose_throwAnti_empty;
			SetMooseAnimation(a,1,AnimationType.FIRST_FRAME);
			break;
		case MooseState.PROJECTILE:
			var a = noone;
			if armor > 0 a = spr_moose_throw;
			else if armed a = spr_moose_throw_helmless;
			else a = spr_moose_throw_empty;
			SetMooseAnimation(a,1,AnimationType.FIRST_FRAME);
			break;
		case MooseState.PROJECTILE_FOLLOW:
			var a = noone;
			if armor > 0 a = spr_moose_throw;
			else if armed a = spr_moose_throw_helmless;
			else a = spr_moose_throw_empty;
			SetMooseAnimation(a,1,AnimationType.FIRST_FRAME);
			break;
		case MooseState.BURP_ANTI:
			var a = noone;
			if armor > 0  a = spr_moose_burpAnti;
			else if armed a = spr_moose_burpAnti_helmless;
			else a = spr_moose_burpAnti_empty;
			SetMooseAnimation(a,8,AnimationType.HOLD);
		case MooseState.BURP_SWING:
			var a = noone;
			if armor > 0  a = spr_moose_burp;
			else if armed a = spr_moose_burp_helmless;
			else a = spr_moose_burp_empty;
			SetMooseAnimation(a,6,AnimationType.LOOP);
			break;
		case MooseState.BURP_FOLLOW:
			var a = noone;
			if armor > 0  a = spr_moose_burpFollow;
			else if armed a = spr_moose_burpFollow_helmless;
			else a = spr_moose_burpFollow_empty;
			SetMooseAnimation(a,8,AnimationType.HOLD);
			break;
		case MooseState.SLEEP:
			var a = noone;
			if armor > 0 a = spr_moose_sleep;
			else if armed a = spr_moose_sleep_helmless;
			else a = spr_moose_sleep_empty;
			SetMooseAnimation(a,12,AnimationType.LOOP);
			break;
		case MooseState.PANIC_WAIT:
			var a = spr_moose_chargeBounce;
			if armor == 0 a = spr_moose_chargeBounce_helmless;
			SetMooseAnimation(a,1,AnimationType.FIRST_FRAME);
			break;
	}
}
function PlayMooseAnimation()
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

function GetMooseFriction()
{
	switch current_state
	{
		case MooseState.IDLE:
			return global.moose_idleFriction;
			break;
		case MooseState.WANDER:
			return global.moose_wanderFriction;
			break;
		case MooseState.SLIDE:
			return global.moose_slideFriction;
			break;
		case MooseState.JUMP:
			return 0;
			break;
	}
	return global.moose_idleFriction;
}

function LimitMooseSpeed()
{
	var m = global.moose_wanderMaxSpeed;
	if current_state == MooseState.SLIDE m = global.moose_slideMaxSpeed;
	if abs(hspeed) > m
	{
		var s = sign(hspeed)
		var v = lerp(abs(hspeed), m, 0.2);
		hspeed = s * v;
	}
}

function SetMooseDirection()
{
	if facing == Direction.LEFT
	{
		image_xscale = 1;
	}
	else
	{
		image_xscale = -1;
	}
}

function MooseInvuln()
{
	if invuln == false return;
	invulnTimer --;
	visible = ceil(invulnTimer/7)%2;
	visible = !visible;
	if invulnTimer <= 0
	{
		invuln = false;
		visible = true;
	}
}

function MakeMooseInvulnerable(_time)
{
	invuln = true;
	invulnTimer = _time;
}

function MooseGetHit()
{
	if armor > 0 {
		y-= 2;
		vspeed -= 20;
		if obj_player_fighting.x > x hspeed = obj_player_fighting.x > x ? -20 : 20;
		armor --;
		MakeMooseInvulnerable(global.moose_invulTime);
		current_state = MooseState.HIT;
		state_timer = 60;
		wanderCounter = 0;
		var helm = instance_create_depth(x,y-100,depth-100, obj_moose_helmet);
		helm.activate(obj_player_fighting.x < x ? Direction.RIGHT : Direction.LEFT);
		audio_play_sound(sfx_moose_dehelm, 2, false);
	} else if armed {
		state_timer = 60;
		y-= 2;
		vspeed -= 20;
		if obj_player_fighting.x > x hspeed = obj_player_fighting.x > x ? -20 : 20;
		armed = false;
		h = obj_player_fighting.x < x ? -1 : 1;
		var s = instance_create_layer(x,y,layer,obj_enemy_sword);
		s.EnemySwordFling(h,-1.67,17);
		MakeMooseInvulnerable(global.moose_invulTime);
		current_state = MooseState.HIT;
		wanderCounter = 0;
		audio_play_sound(sfx_moose_dehelm, 2, false);
	} else {
		if obj_player_fighting.x > x hspeed =  -20;
		else hspeed = 20;
		vspeed = -20;
		MooseToDead();
		if instance_exists(obj_music_controller) obj_music_controller.pause();
		audio_play_sound(sfx_moose_death, 2, false);
	}
}

function message_state() {
	var s = "Current state is ";
	switch current_state {
		case MooseState.IDLE:
			s += "Idle";
			break;
		case MooseState.WANDER:
			s += "Wander";
			break;
		case MooseState.SLIDE_ANTI:
			s+= "Slide Anti";
			break;
		case MooseState.SLIDE:
			s+= "Slide";
			break;
		case MooseState.CHARGE_ANTI:
			s+= "Charge Anti";
			break;
		case MooseState.CHARGE:
			s+= "Charge";
			break;
		case MooseState.WAITING:
			s+= "Waiting";
			break;
		case MooseState.HIT:
			s+= "Hit";
			break;
		case MooseState.BLOCK:
			s+= "Block";
			break;
		case MooseState.LOCK:
			s+= "Lock";
			break;
		case MooseState.DEAD:
			s+= "Dead";
			break;
		case MooseState.PULLING:
			s+= "Pulling";
			break;
		case MooseState.LUNGE_ANTI:
			s+= "Lunge Anti";
			break;
		case MooseState.LUNGE:
			s+= "Lunge";
			break;
		case MooseState.STAB_ANTI:
			s+= "Stab Anti";
			break;
		case MooseState.STAB:
			s+= "Stab";
			break;
		case MooseState.JUMP_ANTI:
			s+= "Jump Anti";
			break;
		case MooseState.JUMP:
			s+= "Jump";
			break;
		case MooseState.DIVE_ANTI:
			s+= "Dive Anti";
			break;
		case MooseState.DIVE:
			s+= "Dive";
			break;
		case MooseState.STUCK:
			s+= "Stuck";
			break;
		case MooseState.SPIN:
			s+= "Spin";
			break;
	}
	
	show_debug_message(s);
}

function get_phase() {
	if armor > 0 return 1;
	else if armed return 2;
	else return 3;
}

function retalliation() {
	switch(current_state) {
		case MooseState.CHARGE: return;break;
		case MooseState.CHARGE_ANTI: return;break;
		case MooseState.DEAD: return; break;
		case MooseState.DIVE: return; break;
		case MooseState.DIVE_ANTI: return; break;
		case MooseState.HIT: return; break;
		case MooseState.JUMP: return; break;
		case MooseState.JUMP_ANTI: return; break;
		case MooseState.LOCK: return; break;
		case MooseState.LUNGE: return; break;
		case MooseState.LUNGE_ANTI: return; break;
		case MooseState.PROJECTILE: return; break;
		case MooseState.PROJECTILE_ANTI: return; break;
		case MooseState.PROJECTILE_FOLLOW: return; break;
		case MooseState.SLIDE: return; break;
		case MooseState.SLIDE_ANTI: return; break;
		case MooseState.SPIN: return; break;
		case MooseState.STAB: return; break;
		case MooseState.STAB_ANTI: return; break;
		case MooseState.STUCK: return; break;
		case MooseState.STUN: return; break;
		case MooseState.WAITING: return; break;
		case MooseState.SLEEP: return; break;
	}
	
	var dist_to_player = distance_to_object(obj_player_fighting);
	
	// Player too close
	if dist_to_player < global.moose_player_too_close_distance {
		player_too_close_timer ++;
		if player_too_close_timer > global.moose_player_too_close_time {
			player_too_close_timer = 0;
			var p = obj_player_fighting.x < x ? distance_to_wall(Direction.RIGHT) : distance_to_wall(Direction.LEFT);
			
			if p > 300 {
				to_projectile_anti();
				return;
			} else {
				to_burp_anti();
				return;
			}
		}
	} else {
		player_too_close_timer = 0;
	}
	// Basic attack charge too long
	if obj_player_fighting.basic_attack_charge_timer > global.moose_player_basic_charge_too_long_time {
		to_projectile_anti();
		return;
	}
	// Sling attack charge too long
	if obj_player_fighting.sling_attack_charge_timer > global.moose_player_sling_charge_too_long_time {
		to_jump_anti();
		return;
	}
	// Jump charge too long
	if obj_player_fighting.jumpTimer > global.moose_player_jump_charge_too_long_time {
		MooseIdleToSlideAnti();
		return;
	}
	
	// head jumps
	if collision_check_edge(x,y-10,spr_enemy_collision, Direction.UP, [obj_player_fighting]){
		head_jump_counter++;
		if head_jump_counter >= global.moose_too_many_head_jumps {
			to_spin();
		}
	}
	if head_jump_counter > 0 && floor(current_time/100) % 2  == 0 {
		head_jump_counter --;
	}
}

function distance_to_wall(d) {
	var cur = d == Direction.RIGHT ? 100 : -100;
	while collision_line_mask(x,y,x+d,y,collision_mask,false,true) {
		cur += d == Direction.RIGHT ? 100 : -100;
	}
	return cur;
}

function check_frame_sounds() {
	if sprite_index == spr_moose_walk || sprite_index == spr_moose_walk_disarmedHelm || sprite_index == spr_moose_walk_empty || sprite_index == spr_moose_walk_hiBlock || sprite_index == spr_moose_walk_noHelm || sprite_index == spr_moose_walkBlock || sprite_index == spr_moose_walkBlock_noHelm{
		if image_index == 0 {
			audio_play_sound(sfx_moose_step_0, 10, false);
			return;
		} 
		if image_index == 2 {
			audio_play_sound(sfx_moose_step_1, 10, false);
			return;
		}
	}
}

function take_hit_minor() {
	show_debug_message("Moose taking minor hit");
	show_debug_message("Health before hit: " + string(hp));
	MakeMooseInvulnerable(10);
	
	hp_regen_timer = 0;
	
	if panicking {
		hp -= 2;
		panicking = false;
		if hp > 0 
			to_stun();
		else 
			take_hit_major();
	} else {
		hp -= 1;
		panicking = true;
		if hp > 0 
			to_panic_wait();
		else 
			take_hit_major();
	}
	show_debug_message("Health after minor hit: " + string(hp));
}

function take_hit_major() {
	show_debug_message("Moose taking major hit");
	show_debug_message("Health before major hit: " + string(hp));
	MakeMooseInvulnerable(5);
	hp_regen_timer = 0;
	
	MooseGetHit();
	hp = max_hp;
	show_debug_message("Health after major hit: " + string(hp));
}

function choose_panic_attack() {
	var _phase = get_phase();
	if _phase == 1 
		to_jump_anti();
	else if _phase == 2 
		to_lunge_anti();
	else
		MooseIdleToChargeAnti();
}

function regen_hp() {
	if hp_regen_timer == hp_regen_time_long {
		hp = hp + 1> max_hp ? max_hp : hp + 1;
	} else if hp_regen_timer > hp_regen_time_long {
		if (hp_regen_timer - hp_regen_time_long) % hp_regen_time_short == 0 {
			hp = hp + 1> max_hp ? max_hp : hp + 1;
		}
	}
	hp_regen_timer ++;
}
