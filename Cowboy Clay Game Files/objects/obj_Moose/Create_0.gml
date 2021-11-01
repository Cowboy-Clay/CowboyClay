/// @description Insert description here
// You can write your code in this editor

enum State { PULLING, WAIT, TAUNT, SLIDE, SPACE, AVOID, RETRIEVE, CHARGE, HIT };
currentState = State.PULLING;

armed = true;

// Wait variables
waitTimer = 0;
waitTimeMinimum = 2;
waitTimeMaximum = 5;
// Taunt variables
tauntTimer = 0;
tauntTime = 2;
// Slide variables
slideWaitTimer = 0;
slideWaitTime = 0.5;
slideVelocity = 5;
slideDeadening = 0.95;
// Space variables
idealDistance = 500;
spaceAccell = 1;
spaceMaxVel = 10;
spaceDeadening = 0.9;
// Avoid variables
avoidTimer = 0;
avoidTime = 10;
// Hit variables
hitVel = 10;
hitDeadening = 0.9;

function UpdateState()
{
	switch currentState
	{
		case State.PULLING:
			if place_meeting(x,y,obj_Player)
			{
				GoToSpace();
			}
			break;
		case State.WAIT:
			waitTimer -= delta_time/1000000;
			if waitTimer <= 0 GoToTaunt();
			break;
		case State.TAUNT:
			tauntTimer -= delta_time/1000000;
			if instance_exists(obj_Sword) GoToSlide();
			if tauntTimer <= 0 GoToWait();
			break;
		case State.SLIDE:
			if slideWaitTimer > 0
			{
				slideWaitTimer -= delta_time/1000000;
			}
			else
			{
				hspeed *= slideDeadening;
				if hspeed < 0.01 GoToSpace();
			}
			break;
		case State.SPACE:
			SpaceWalk();
			break;
		case State.AVOID:
			avoidTimer -= delta_time/1000000;
			if avoidTimer <= 0 || instance_exists(obj_Sword) || place_meeting(x,y,obj_Wall)
				GoToRetrieve();
			break;
		case State.RETRIEVE:
			break;
		case State.CHARGE:
			break;
		case State.HIT:
			hspeed *= hitDeadening;
			if hspeed < 0.05 && !armed
			{
				ZeroVelocity();
				GoToAvoid();
			}
			if hspeed < 0.05 && armed
			{
				ZeroVelocity();
				GoToSpace();
			}
			break;
	}
}

function GoToWait()
{
	waitTimer = random_range(waitTimeMinimum, waitTimeMaximum);
	currentState = State.WAIT;
}

function GoToTaunt()
{
	tauntTimer = tauntTime;
	currentState = State.TAUNT;
}

function GoToSlide()
{
	slideWaitTimer = slideWaitTime;
	if obj_Player.x > x hspeed = slideVelocity;
	else hspeed = - slideVelocity;
	currentState = State.SLIDE;
}

function GoToSpace()
{
	currentState = State.SPACE;
}

function GoToAvoid()
{
	avoidTimer = avoidTime;
	currentState = State.AVOID;
}

function GoToRetrieve()
{
	if armed 
	{
		GoToSpace();
		return;
	}
	if (x < obj_Player.x && obj_Player.x < obj_EnemySword.x) || (x > obj_Player.x && obj_Player.x > obj_EnemySword.x)
	{
		GoToCharge();
		return;
	}
	currentState = State.RETRIEVE;
}

function GoToCharge()
{
	currentState = State.CHARGE;
}

function GoToHit()
{
	if obj_Player.x > x hspeed = -hitVel;
	if obj_Player.x < x hspeed = hitVel;
	currentState = State.HIT;
}

function TakeHit()
{
	if !armed 
	{
		Die();
		return;
	}
	
	armed = false;
	GoToHit();
}

function SpaceWalk()
{
	if distance_to_object(obj_Player) < idealDistance
	{
		if obj_Player.x < x
		{
			hspeed += spaceAccell;
			if hspeed > spaceMaxVel hspeed = spaceMaxVel;
		}
		else
		{
			hspeed -= spaceAccell;
			if hspeed < -spaceMaxVel hspeed = - spaceMaxVel;
		}
	}
	else
	{
		hspeed *= spaceDeadening;
		if hspeed <= 0.05
		{
			ZeroVelocity();
			GoToWait();
		}
	}
}

function SetAnimation()
{
	// Pulling animation
	if currentState == State.PULLING sprite_index = PirateProtoPull;
	// Waiting animation
	if currentState == State.WAIT sprite_index = spr_Moose;
	// Taunt animation
	if currentState == State.TAUNT sprite_index = ProtoMooseTaunt;
	// Slide animation
	if currentState == State.SLIDE sprite_index = ProtoMooseSlide;
	// Charge animation
	if currentState == State.CHARGE sprite_index = ProtoMooseCharge;
	
	if currentState == State.HIT sprite_index = ProtoMooseStruck;
	
	// Walking animations
	if (currentState == State.SPACE || currentState == State.AVOID)
	{
		if abs(hspeed) > 0.05
		{
			sprite_index = moosewalk;
		}
		else
		{
			sprite_index = spr_Moose;
		}
	}
}

function ZeroVelocity()
{
	hspeed = 0;
}

function Die()
{
}

function PrintState()
{
	switch currentState
	{
		case State.PULLING:
			show_debug_message("Pulling");
			break;
		case State.WAIT:
			show_debug_message("Wait");
			break;
		case State.TAUNT:
			show_debug_message("Taunt");
			break;
		case State.SLIDE:
			show_debug_message("Slide");
			break;
		case State.SPACE:
			show_debug_message("Space");
			break;
		case State.AVOID:
			show_debug_message("Avoid");
			break;
		case State.RETRIEVE:
			show_debug_message("Retrive");
			break;
		case State.CHARGE:
			show_debug_message("Charge");
			break;
		case State.HIT:
			show_debug_message("Hit");
			break;
	}
}