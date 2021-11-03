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
slideWaitTime = 1;
slideVelocity = 10;
slideDeadening = 0.9;
// Space variables
idealDistance = 500;
spaceAccell = 1;
spaceMaxVel = 10;
spaceDeadening = 0.75;
// Avoid variables
avoidTimer = 0;
avoidTime = 10;
// Hit variables
hitVel = 20;
hitDeadening = 0.9;
// Retrieve variables
retrAcc = 1;
retrMaxVel = 10;
// Charge variables
chargeVel = 10;
chargeWait = false;

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
				if hspeed < 1 GoToSpace();
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
			Retrieve();
			break;
		case State.CHARGE:
			if(!chargeWait)
			{
				if place_meeting(x+vspeed, y, obj_Wall)
				{
					vspeed = 0;
					if obj_EnemySword.image_angle == 90 obj_EnemySword.x -= 10;
					else obj_EnemySword.x += 10;
					chargeWait = true;
				}
			}
			else
			{
				if obj_EnemySword.image_angle == 90 x-= 10;
				else x += 10;
				obj_EnemySword.y += 15;
				if obj_EnemySword.y >= y
				{
					show_debug_message("FUCK");
	obj_EnemySword.my_sword_state = sword_state.neutral;
	armed = true;
	instance_deactivate_object(obj_EnemySword);
	GoToSpace();
				}
			}
			break;
		case State.HIT:
			hspeed *= hitDeadening;
			if abs(hspeed) < 1 && !armed
			{
				ZeroVelocity();
				GoToAvoid();
			}
			if abs(hspeed) < 1 && armed
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
	if (x < obj_Player.x && obj_Player.x < obj_EnemySword.x) || (x > obj_Player.x && obj_Player.x > obj_EnemySword.x) || (obj_EnemySword.stuckInWall && obj_EnemySword.my_sword_state == sword_state.stuck)
	{
		GoToCharge();
		return;
	}
	currentState = State.RETRIEVE;
}

function GoToCharge()
{
	chargeWait = false;
	if obj_Player.x > x hspeed = -chargeVel;
	else hspeed = chargeVel;
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
	instance_activate_object(obj_EnemySword);
	obj_EnemySword.Flung();
	GoToHit();
}

function SpaceWalk()
{
	if place_meeting(x,y,obj_Wall)
	{
		hspeed = 0;
		GoToWait();
		return;
	}
	
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

function Retrieve()
{
	if instance_exists(obj_EnemySword) && obj_EnemySword.x > x
	{
		hspeed += retrAcc;
		if hspeed > retrMaxVel hspeed = retrMaxVel;
	}
	else if instance_exists(obj_EnemySword)
	{
		hspeed -= retrAcc;
		if hspeed < -retrMaxVel hspeed = - retrMaxVel;
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

function TouchedPlayer()
{
	if currentState == State.TAUNT || currentState == State.CHARGE || currentState == State.SLIDE
	{
		obj_Player.Hurt(x);
	}
}