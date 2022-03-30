enum MooseState { IDLE, WANDER, SLIDE_ANTI, SLIDE, CHARGE_ANTI, CHARGE, WAITING, HIT, BLOCK, LOCK, DEAD, PULLING };

collision_mask = [obj_tile_coll, obj_door, obj_plate, obj_elevator];

currentState = MooseState.IDLE;
armed = true;
facing = Direction.LEFT;
stateTimer = 0;

invuln = false;
invulnTimer = 0;

grounded = false;

// Idle
wanderCounter = 0;

// Wander

// Animations
currentFPI = 1;
currentAnimType = AnimationType.FIRST_FRAME;
animFrameCounter = 0;

if start_pulling currentState = MooseState.PULLING;

function UpdateMooseState()
{
	if currentState == MooseState.PULLING return;
	
	stateTimer --;
	switch currentState
	{
		case MooseState.IDLE:
			if stateTimer <= 0
			{
				if wanderCounter >= global.moose_wandersPerIdle
				{
					wanderCounter = 0;
					if armed
					{
						MooseIdleToSlideAnti();
						return;
					}
					else
					{
						MooseIdleToChargeAnti();
						return;
					}
				}
				if wanderCounter >= 2 && !armed
				{
					MooseIdleToChargeAnti();
					return;
				}
				MooseIdleToWander();
				return;
			}
			break;
		case MooseState.WANDER:
			if stateTimer <= 0
			{
				MooseWanderToIdle();
				return;
			}
			break;
		case MooseState.SLIDE_ANTI:
			if stateTimer <= 0
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
			if stateTimer <= 0
			{
				MooseChargeAntiToCharge();
				return;
			}
			break;
		case MooseState.CHARGE:
			if place_meeting(x,y,obj_Wall)
			{
				MooseChargeToWait();
				return;
			}
			break;
		case MooseState.WAITING:
			if armed
			{
				MooseWaitToIdle();
				return;
			}
			break;
		case MooseState.HIT:
			if grounded
			{
				MooseWanderToIdle();
				return;
			}
			break;
		case MooseState.BLOCK:
			if obj_player.PlayerNotAttacking()
				MooseWanderToIdle();
			break;
	}
}

function MooseStateBasedActions()
{
	switch currentState
	{
		case MooseState.IDLE:
			MooseFacePlayer();
			MooseCheckBlock();
			break;
		case MooseState.WANDER:
			MooseFacePlayer();
			MooseWander();
			MooseCheckBlock();
			break;
		case MooseState.CHARGE:
			MooseCharge();
			break;
	}
}

function MooseCheckBlock()
{
	if obj_player.currentState == PlayerState.BASIC_ATTACK_ANTI && distance_to_object(obj_player) <= global.moose_blockDistance
	{
		MooseToBlock();
	}
}

function MooseCharge()
{
	if facing == Direction.LEFT
		hspeed -= global.moose_chargeAccel;
	else
		hspeed += global.moose_chargeAccel;
}

function MooseWander()
{
	if wanderDir == Direction.LEFT hspeed -= global.moose_wanderAccel;
	else hspeed += global.moose_wanderAccel;
}

function MooseFacePlayer()
{
	if obj_player.x < x facing = Direction.LEFT;
	else facing = Direction.RIGHT;
}

function MoosePickupSword()
{
	if !armed && place_meeting(x,y,obj_enemy_sword) && obj_enemy_sword.EnemySwordCanBePickedUp()
	{
		if global.showDebugMessages show_debug_message("Picked up sword");
		armed = true;
		obj_enemy_sword.currentState = SwordState.INACTIVE;
	}
}

function MooseToDead()
{
	currentState = MooseState.DEAD;
	instance_deactivate_object(obj_enemy_hitbox);
	instance_deactivate_object(obj_enemy_hurtbox);
	instance_deactivate_object(obj_enemy_blockbox);
	SetMooseAnimation(global.moose_deathAnim, global.moose_deathAnimFPI, global.moose_deathAnimType);
}


function MooseToBlock()
{
	if !armed
	{
		MooseIdleToChargeAnti();
		return;
	}
	
	SetMooseAnimation(global.moose_blockLoAnim, global.moose_blockLoAnim_FPI, global.moose_blockLoAnim_type);
	
	currentState = MooseState.BLOCK;
}

function MooseChargeToWait()
{
	obj_enemy_sword.falling = true;
	
	SetMooseAnimation(global.moose_chargeAntiAnim, global.moose_chargeAntiAnim_FPI, global.moose_chargeAntiAnim_type);
	
	currentState = MooseState.WAITING;
}

function MooseIdleToChargeAnti()
{
	if obj_enemy_sword.x < x facing = Direction.LEFT;
	else facing = Direction.RIGHT;
	
	stateTimer = global.moose_chargeAntiTime;
	
	SetMooseAnimation(global.moose_chargeAntiAnim, global.moose_chargeAntiAnim_FPI, global.moose_chargeAntiAnim_type);
	
	currentState = MooseState.CHARGE_ANTI;
}

function MooseChargeAntiToCharge()
{
	SetMooseAnimation(global.moose_chargeAnim, global.moose_chargeAnim_FPI, global.moose_chargeAnim_type);
	
	currentState = MooseState.CHARGE;
}

function MooseIdleToWander()
{
	wanderCounter ++;
	
	// Decide direction to wander
	var distToPlayer = distance_to_object(obj_player);
	if distToPlayer < global.moose_minDistance
	{
		if obj_player.x < x wanderDir = Direction.RIGHT;
		else wanderDir = Direction.LEFT;
	}
	else if distToPlayer > global.moose_maxDistance
	{
		if obj_player.x < x wanderDir = Direction.LEFT;
		else wanderDir = Direction.RIGHT;
	}
	else 
	{
		if random_range(0,1) < 0.5 wanderDir = Direction.LEFT;
		else wanderDir = Direction.RIGHT;
	}
	
	// Decide wander duration
	stateTimer = floor(random_range(global.moose_minWanderTime, global.moose_maxWanderTime));
	
	currentState = MooseState.WANDER;
	PlayMooseWanderAnim();
}

function MooseWanderToIdle()
{
	stateTimer = floor(random_range(global.moose_minIdleTime, global.moose_maxIdleTime));
	
	currentState = MooseState.IDLE;
	PlayMooseIdleAnim();
}

function MooseWaitToIdle()
{
	stateTimer = floor(random_range(global.moose_minIdleTime, global.moose_maxIdleTime));
	
	wanderCounter = global.moose_wandersPerIdle - 1;
	
	currentState = MooseState.IDLE;
	PlayMooseIdleAnim();
}

function MooseIdleToSlideAnti()
{
	stateTimer = global.moose_slideAntiDuration;
	
	MooseFacePlayer();
	
	currentState = MooseState.SLIDE_ANTI;
	SetMooseAnimation(global.moose_slideAntiAnim, global.moose_slideAntiAnim_FPI, global.moose_slideAntiAnim_type);
}

function MooseSlideAntiToSlide()
{
	if facing == Direction.LEFT hspeed = -global.moose_slideImpulse;
	else hspeed = global.moose_slideImpulse;
	
	currentState = MooseState.SLIDE;
	SetMooseAnimation(global.moose_slideAnim, global.moose_slideAnim_FPI, global.moose_slideAnim_type);
}

function MooseSlideToIdle()
{
	stateTimer = floor(random_range(global.moose_minIdleTime, global.moose_maxIdleTime));
	
	currentState = MooseState.IDLE;
	PlayMooseIdleAnim();
}

function PlayMooseIdleAnim()
{
	var a = global.moose_idleAnim;
	if !armed a = global.moose_idleAnim_disar;
	SetMooseAnimation(a, global.moose_idleAnim_FPI, global.moose_idleAnim_type);
}

function PlayMooseWanderAnim()
{
	var a = global.moose_wanderAnim;
	if armed == false a = global.moose_wanderAnim_disar;
	SetMooseAnimation(a, global.moose_wanderAnim_FPI, global.moose_wanderAnim_type);
}

function SetMooseAnimation(animation, fpi, type)
{
	sprite_index = animation;
	currentFPI = fpi;
	currentAnimType = type;
	animFrameCounter = 0;
}

function update_animation() {
	switch(current_state) {
		case MooseState.IDLE:
			var a = armor > 0 ? global.moose_animation_idle : (armed==true ? global.moose_animation_idle_helmless : global.moose_animation_idle_disarmed);
			SetMooseAnimation(a, global.moose_animation_idle_FPI, global.moose_animation_idle_type);
			break;
		case MooseState.WANDER:
			var a = armor > 0 ? global.moose_animation_wander : (armed==true ? global.moose_animation_wander_helmless : global.moose_animation_wander_disarmed);
			SetMooseAnimation(a, global.moose_animation_wander_FPI, global.moose_animation_wander_type);
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
			var a = armor > 0 ? global.moose_animation_hit : (armed==true ? global.moose_animation_hit_helmless : global.moose_animation_hit_disarmed);
			SetMooseAnimation(a, global.moose_animation_hit_FPI, global.moose_animation_hit_type);
			break;
			
		case MooseState.LOCK:
			break;
			
		case MooseState.DEAD:
			var a = armor > 0 ? global.moose_animation_dead : (armed==true ? global.moose_animation_dead_helmless : global.moose_animation_dead_disarmed);
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
			var a = armor > 0 ? global.moose_animation_stabAnti : (armed==true ? global.moose_animation_stabAnti_helmless : global.moose_animation_stabAnti_disarmed);
			SetMooseAnimation(a, 1, AnimationType.FIRST_FRAME);
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
			var a = armor > 0 ? global.moose_animation_plunging : (armed==true ? global.moose_animation_plunging_helmless : global.moose_animation_plunging_disarmed);
			SetMooseAnimation(a, global.moose_animation_plunging_FPI, global.moose_animation_plunging_type);
			break;
		case MooseState.SPIN:
			var a = armor > 0 ? global.moose_animation_spinning : (armed==true ? global.moose_animation_spinning_helmless : global.moose_animation_spinning_disarmed);
			SetMooseAnimation(a, global.moose_animation_spinning_FPI, global.moose_animation_spinning_type);
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
		image_index ++;
		if image_index >= sprite_get_number(sprite_index)
		{
			if currentAnimType == AnimationType.LOOP image_index = 0;
			else if currentAnimType == AnimationType.HOLD image_index = sprite_get_number(sprite_index) - 1;
		}
	}
	
	
}

function GetMooseFriction()
{
	switch currentState
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
	}
	return global.moose_idleFriction;
}

function LimitMooseSpeed()
{
	var m = global.moose_wanderMaxSpeed;
	if currentState == MooseState.SLIDE m = global.moose_slideMaxSpeed;
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
	if invulnTimer <= 0
	{
		invuln = false;
		visible = true;
	}
}

function MakeMooseInvulnerable()
{
	invuln = true;
	invulnTimer = global.moose_invulTime;
}

function MooseGetHit()
{
	if invuln return;
	if armed
	{
		y-= 2;
		vspeed -= 20;
		if obj_player.x > x hspeed =  -20;
		else hspeed = 20;
		armed = false;
		h = -1;
		if obj_player.x < x h = 1;
		obj_enemy_sword.EnemySwordFling(h,-1.67,17);
		MakeMooseInvulnerable();
		currentState = MooseState.HIT;
		wanderCounter = 0;
		SetMooseAnimation(global.moose_hitAnim, global.moose_hitAnim_FPI, global.moose_hitAnim_type);
	}
	else
	{
		if obj_player.x > x hspeed =  -20;
		else hspeed = 20;
		vspeed = -20;
		MooseToDead();
		obj_player.currentState = PlayerState.LOCK;
	}
}

function get_hi_block() {
	// Moose is always blocking hi when he has his helmet
	if ( armor > 0 ) {
		return true;
	}
}