enum MooseState { IDLE, WANDER, SLIDE_ANTI, SLIDE };

currentState = MooseState.IDLE;
armed = true;
facing = Direction.LEFT;
stateTimer = 0;

invuln = false;
invulnTimer = 0;

// Idle
wanderCounter = 0;

// Wander
wanderDir = Direction.LEFT;

// Animations
currentFPI = 1;
currentAnimType = AnimationType.FIRST_FRAME;
animFrameCounter = 0;

function UpdateMooseState()
{
	stateTimer --;
	switch currentState
	{
		case MooseState.IDLE:
			if stateTimer <= 0
			{
				if wanderCounter >= global.moose_wandersPerIdle
				{
					wanderCounter = 0;
					MooseIdleToSlideAnti();
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
	}
}

function MooseStateBasedActions()
{
	switch currentState
	{
		case MooseState.IDLE:
			MooseFacePlayer();
			break;
		case MooseState.WANDER:
			MooseFacePlayer();
			MooseWander();
			break;
	}
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
		vspeed -= 15;
		if obj_Moose.x > x hspeed =  20;
		else hspeed = -20;
		armed = false;
		h = 1;
		if obj_Moose.x < x h = -1;
		obj_enemy_sword.EnemySwordFling(h,-1.67,17);
		MakeMooseInvulnerable();
	}
}