/// @description Insert description here
// You can write your code in this editor

enum MooseState { PULLING, WAIT, TAUNT, SLIDE, SPACE, AVOID, RETRIEVE, CHARGE, HIT };
currentState = MooseState.PULLING;

armed = true;

// Wait variables
waitTimer = 0;
waitTimeMinimum = 5;
waitTimeMaximum = 10;

enum WanderState {LEFT, RIGHT, WAIT};
currentWanderState = WanderState.WAIT;
wanderTimer = 0;
maxWanderTime = 1;
minWanderTime = 0.25;
maxWanderWait = .8;
minWanderWait = 0;
walkingAccel = .5;
walkingMaxVel = 3;

// Taunt variables
tauntTimer = 0;
tauntTime = 2;
// Slide variables
slideWaitTimer = 0;
slideWaitTime = 1;
slideVelocity = 25;
slideDeadening = 0.97;
slideFlag = false;
// Space variables
idealDistance = 400;
minDistance = 300;
maxDistance = 550;
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
		case MooseState.PULLING:
			if place_meeting(x,y,obj_Player)
			{
				GoToSpace();
			}
			break;
		case MooseState.WAIT:
			waitTimer -= delta_time/1000000;
			Wander();
			if waitTimer <= 0 GoToTaunt();
			break;
		case MooseState.TAUNT:
			tauntTimer -= delta_time/1000000;
			if instance_exists(obj_Sword) GoToSlide();
			if tauntTimer <= 0 GoToSlide();
			break;
		case MooseState.SLIDE:
			if slideWaitTimer > 0
			{
				slideWaitTimer -= delta_time/1000000;
			}
			else if slideFlag == false
			{
				slideFlag = true;
				if obj_Player.x > x hspeed = slideVelocity;
				else hspeed = - slideVelocity;
			}
			else
			{
				hspeed *= slideDeadening;
				if abs(hspeed) < 1 GoToSpace();
				if place_meeting(x,y,obj_Wall)
				{
					hspeed = 0;
					GoToSpace();
				}
			}
			break;
		case MooseState.SPACE:
			SpaceWalk();
			break;
		case MooseState.AVOID:
			avoidTimer -= delta_time/1000000;
			if avoidTimer <= 0 || instance_exists(obj_Sword) || place_meeting(x,y,obj_Wall)
				GoToRetrieve();
			break;
		case MooseState.RETRIEVE:
			Retrieve();
			break;
		case MooseState.CHARGE:
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
				show_debug_message("Sword should be falling");
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
		case MooseState.HIT:
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
	wanderTimer = random_range(minWanderWait, maxWanderWait);
	currentWanderState = WanderState.WAIT;
	currentState = MooseState.WAIT;
}

function GoToTaunt()
{
	hspeed = 0;
	currentWanderState = WanderState.WAIT;
	wanderTimer = 0;
	tauntTimer = tauntTime;
	currentState = MooseState.TAUNT;
}

function GoToSlide()
{
	slideFlag = false;
	slideWaitTimer = slideWaitTime;
	currentState = MooseState.SLIDE;
}

function GoToSpace()
{
	currentState = MooseState.SPACE;
}

function GoToAvoid()
{
	avoidTimer = avoidTime;
	currentState = MooseState.AVOID;
}

function GoToRetrieve()
{
	if armed 
	{
		GoToSpace();
		return;
	}
	if obj_EnemySword.my_sword_state != sword_state.stuck
	{
		GoToAvoid();
		return;
	}
	if (x < obj_Player.x && obj_Player.x < obj_EnemySword.x) || (x > obj_Player.x && obj_Player.x > obj_EnemySword.x) || (obj_EnemySword.stuckInWall && obj_EnemySword.my_sword_state == sword_state.stuck)
	{
		GoToCharge();
		return;
	}
	currentState = MooseState.RETRIEVE;
}

function GoToCharge()
{
	chargeWait = false;
	if obj_Player.x > x hspeed = -chargeVel;
	else hspeed = chargeVel;
	currentState = MooseState.CHARGE;
}

function GoToHit()
{
	if obj_Player.x > x-136 hspeed = -hitVel;
	if obj_Player.x < x-136 hspeed = hitVel;
	currentState = MooseState.HIT;
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
	if currentState == MooseState.PULLING sprite_index = PirateProtoPull;
	// Waiting animation
	if currentState == MooseState.WAIT
	{
		if currentWanderState == WanderState.WAIT sprite_index = spr_Moose;
		else sprite_index = moosewalk;
	}
	// Taunt animation
	if currentState == MooseState.TAUNT sprite_index = ProtoMooseTaunt;
	// Slide animation
	if currentState == MooseState.SLIDE
	{
		if abs(hspeed) > 1 sprite_index = ProtoMooseSlide;
		else sprite_index = PirateProtoDisarmed;
	}
	// Charge animation
	if currentState == MooseState.CHARGE sprite_index = ProtoMooseCharge;
	
	if currentState == MooseState.HIT sprite_index = ProtoMooseStruck;
	
	// Walking animations
	if (currentState == MooseState.SPACE || currentState == MooseState.AVOID)
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
		case MooseState.PULLING:
			show_debug_message("Pulling");
			break;
		case MooseState.WAIT:
			show_debug_message("Wait");
			break;
		case MooseState.TAUNT:
			show_debug_message("Taunt");
			break;
		case MooseState.SLIDE:
			show_debug_message("Slide");
			break;
		case MooseState.SPACE:
			show_debug_message("Space");
			break;
		case MooseState.AVOID:
			show_debug_message("Avoid");
			break;
		case MooseState.RETRIEVE:
			show_debug_message("Retrive");
			break;
		case MooseState.CHARGE:
			show_debug_message("Charge");
			break;
		case MooseState.HIT:
			show_debug_message("Hit");
			break;
	}
}

function TouchedPlayer()
{
	if currentState == MooseState.TAUNT || currentState == MooseState.CHARGE || currentState == MooseState.SLIDE
	{
		obj_Player.Hurt(x);
	}
}

function MoveInbounds()
{
	if x < minX x = minX;
	if x > maxX x = maxX;
}

function Wander()
{
	wanderTimer -= delta_time / 1000000;
	switch currentWanderState
	{
		case WanderState.WAIT:
			if wanderTimer <= 0	PickWander();
			break;
		case WanderState.LEFT:
			hspeed -= walkingAccel;
			if hspeed < -walkingMaxVel hspeed = -walkingMaxVel;
			if wanderTimer <= 0 WanderWait();
			break;
		case WanderState.RIGHT:
			hspeed += walkingAccel;
			if hspeed > walkingMaxVel hspeed = walkingMaxVel;
			if wanderTimer <= 0 WanderWait();
			break;
	}
}

function PickWander()
{
	if distance_to_object(obj_Player) < minDistance
	{
		if x < obj_Player.x currentWanderState = WanderState.LEFT;
		else currentWanderState = WanderState.RIGHT;
	}
	else if distance_to_object(obj_Player) > maxDistance
	{
		if x < obj_Player.x currentWanderState = WanderState.RIGHT;
		else currentWanderState = WanderState.LEFT;
	}
	
	if currentWanderState == WanderState.WAIT
	{
		if random(1) > 0.5 currentWanderState = WanderState.RIGHT;
		else currentWanderState = WanderState.LEFT;
	}
	wanderTimer = random_range(minWanderTime, maxWanderTime);
}
function WanderWait()
{
	hspeed = 0;
	wanderTimer = random_range(minWanderWait, maxWanderWait);
	currentWanderState = WanderState.WAIT;
}