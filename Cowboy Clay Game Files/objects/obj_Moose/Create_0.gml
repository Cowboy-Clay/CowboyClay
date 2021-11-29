enum MooseState { IDLE, WANDER };

currentState = MooseState.IDLE;
armed = true;
facing = Direction.LEFT;
stateTimer = 0;

// Idle
wanderCounter = 0;

// Wander
wanderDir = Direction.LEFT;

currentFPI = 1;
currentAnimType = AnimationType.FIRST_FRAME;
animFrameCounter = 0;

// Animations

function UpdateMooseState()
{
	stateTimer --;
	if stateTimer > 0 return;
	switch currentState
	{
		case MooseState.IDLE:
			MooseIdleToWander();
			return;
			break;
		case MooseState.WANDER:
			MooseWanderToIdle();
			return;
			break;
	}
}

function MooseStateBasedActions()
{
	switch currentState
	{
		case MooseState.WANDER:
			MooseWander();
			break;
	}
}

function MooseWander()
{
	if wanderDir == Direction.LEFT hspeed -= global.moose_wanderAccel;
	else hspeed += global.moose_wanderAccel;
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
	}
	return global.moose_idleFriction;
}

function LimitMooseSpeed()
{
	var m = global.moose_wanderMaxSpeed;
	if abs(hspeed) > m
	{
		var s = sign(hspeed)
		var v = lerp(abs(hspeed), m, 0.2);
		hspeed = s * v;
	}
}