/// @description Insert description here
// You can write your code in this editor

enum MooseState { PULLING, WAIT, TAUNT, SLIDE, SPACE, AVOID, RETRIEVE, CHARGE, HIT };
currentState = MooseState.PULLING;

armed = true;

facing = Direction.LEFT;

// Wait variables
waitTimer = 0;
global.mooseWaitTimeMin = 300;
global.mooseWaitTimeMax = 600;

enum WanderState {LEFT, RIGHT, WAIT};
currentWanderState = WanderState.WAIT;
wanderTimer = 0;
global.moose_wanderTimeMax = 1;
global.moose_wanderTimeMin = 0.25;
global.moose_wanderWaitMax = .8;
global.moose_wanderWaitMin = 0;
global.moose_walkAccel = .5;
global.moose_walkMaxVel = 3;

// Block sub variable
blockTimer = 0;
global.moose_blockTime = 01;

// Taunt variables
tauntTimer = 0;
global.moose_tauntTime = 2;
// Slide variables
slideWaitTimer = 0;
global.moose_slideWaitTime = 60;
global.moose_slideVelocity = 25;
slideFlag = false;
// Space variables
global.moose_idealDistance = 400;
global.moose_minDistance = 300;
global.moose_maxDistance = 550;
global.moose_spaceAccell = 1;
global.moose_spaceMaxVel = 10;
global.moose_spaceDeadening = 0.75;
// Avoid variables
global.moose_minAvoidTime = 1;
avoidTimer = 0;
global.moose_avoidTime = 10;
// Hit variables
global.moose_hitVel = 20;
global.moose_hitDeadening = 0.9;
// Retrieve variables
global.moose_retrAcc = 1;
global.moose_retrMaxVel = 10;
// Charge variables
global.moose_chargeVel = 10;
chargeWait = false;

///////LEFT HERE
global.moose_slideEffect = spr_FrontSlashEffect;
global.moose_slideHitbox = spr_moose_slide_hitbox;
global.moose_tauntEffect = spr_FrontSlashEffect;
global.moose_tauntHitbox = spr_moose_taunt_hitbox;
global.moose_chargeEffect = spr_FrontSlashEffect;
global.moose_chargeHitbox = spr_moose_chargeAnti_hitbox;

function UpdateState()
{
	switch currentState
	{
		case MooseState.PULLING:
			HideMooseAttack();
			break;
		case MooseState.WAIT:
			FacePlayer();
			HideMooseAttack();
			waitTimer -= 1;
			Wander();
			if waitTimer <= 0 GoToTaunt();
			break;
		case MooseState.TAUNT:
			ShowMooseAttack(global.moose_tauntEffect, global.moose_tauntHitbox);
			tauntTimer -= 1;
			if instance_exists(obj_Sword) GoToSlide();
			if tauntTimer <= 0 GoToSlide();
			break;
		case MooseState.SLIDE:
			if slideWaitTimer > 0
			{
				HideMooseAttack();
				slideWaitTimer -= 1;
			}
			else if slideFlag == false
			{
				HideMooseAttack();
				slideFlag = true;
				if obj_player.x > x hspeed = global.moose_slideVelocity;
				else hspeed = - global.moose_slideVelocity;
			}
			else
			{
				ShowMooseAttack(global.moose_slideEffect, global.moose_slideHitbox);
				if abs(hspeed) < 1 GoToSpace();
				if place_meeting(x,y,obj_Wall)
				{
					hspeed = 0;
					GoToSpace();
				}
			}
			break;
		case MooseState.SPACE:
			FacePlayer();
			HideMooseAttack();
			SpaceWalk();
			break;
		case MooseState.AVOID:
			FacePlayer();
			HideMooseAttack();
			avoidTimer -= 1;
			if (avoidTimer <= 0 || obj_player.currentState == PlayerState.BASIC_ATTACK_ANTI || obj_Player.currentState == PlayerState.BASIC_ATTACK_SWING || obj_Player.currentState == PlayerState.BASIC_ATTACK_FOLLOW || place_meeting(x,y,obj_Wall)) && avoidTimer < global.moose_avoidTime - global.moose_minAvoidTime
				GoToRetrieve();
			break;
		case MooseState.RETRIEVE:
			HideMooseAttack();
			Retrieve();
			break;
		case MooseState.CHARGE:
			ShowMooseAttack(global.moose_chargeEffect, global.moose_chargeHitbox);
			if(!chargeWait)
			{
				if place_meeting(x+vspeed, y, obj_Wall)
				{
					vspeed = 0;
					if obj_enemy_sword.image_angle == 90 obj_enemy_sword.x -= 10;
					else obj_enemy_sword.x += 10;
					chargeWait = true;
				}
			}
			else
			{
				show_debug_message("Sword should be falling");
				if obj_enemy_sword.image_angle == 90 x-= 10;
				else x += 10;
				obj_enemy_sword.y += 15;
				if obj_enemy_sword.y >= y
				{
					show_debug_message("FUCK");
					obj_enemy_sword.my_sword_state = sword_state.neutral;
					armed = true;
					instance_deactivate_object(obj_enemy_sword);
					GoToSpace();
				}
			}
			break;
		case MooseState.HIT:
			HideMooseAttack();
			hspeed *= global.moose_hitDeadening;
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
	waitTimer = random_range(global.mooseWaitTimeMin, global.mooseWaitTimeMax);
	wanderTimer = random_range(global.moose_wanderWaitMin, global.moose_wanderWaitMax);
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
	if obj_enemy_sword.my_sword_state != sword_state.stuck
	{
		GoToAvoid();
		return;
	}
	if (x < obj_player.x && obj_player.x < obj_enemy_sword.x) || (x > obj_player.x && obj_player.x > obj_enemy_sword.x) || (obj_enemy_sword.stuckInWall && obj_enemy_sword.my_sword_state == sword_state.stuck)
	{
		GoToCharge();
		return;
	}
	currentState = MooseState.RETRIEVE;
}

function GoToCharge()
{
	chargeWait = false;
	if obj_enemy_sword.x < x hspeed = -global.moose_chargeVel;
	else hspeed = global.moose_chargeVel;
	currentState = MooseState.CHARGE;
}

function GoToHit()
{
	if obj_player.x > x-136 hspeed = -global.moose_hitVel;
	if obj_player.x < x-136 hspeed = global.moose_hitVel;
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
	instance_activate_object(obj_enemy_sword);
	obj_enemy_sword.Flung();
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
	
	if distance_to_object(obj_player) < global.moose_idealDistance
	{
		if obj_player.x < x
		{
			hspeed += global.moose_spaceAccell;
			if hspeed > global.moose_spaceMaxVel hspeed = global.moose_spaceMaxVel;
		}
		else
		{
			hspeed -= global.moose_spaceAccell;
			if hspeed < -global.moose_spaceMaxVel hspeed = - global.moose_spaceMaxVel;
		}
	}
	else
	{
		hspeed *= global.moose_spaceDeadening;
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
	if currentState == MooseState.PULLING sprite_index = spr_moose_pull;
	// Waiting animation
	if currentState == MooseState.WAIT
	{
		if blockTimer > global.moose_blockTime sprite_index = spr_moose_block;
		else if (currentWanderState == WanderState.WAIT) || (distance_to_object(obj_player) < minDistance) sprite_index = spr_Moose;
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

function MoveInbounds()
{
	if x < minX x = minX;
	if x > maxX x = maxX;
}

function Wander()
{
	if distance_to_object(obj_Player) < minDistance
	{
		blockTimer += delta_time / 1000000;
		hspeed = 0;
		return;
	}
	
	blockTimer = 0;
	
	wanderTimer -= delta_time / 1000000;
	switch currentWanderState
	{
		case WanderState.WAIT:
			if wanderTimer <= 0	PickWander();
			break;
		case WanderState.LEFT:
			hspeed -= global.moose_walkAccel;
			if hspeed < -global.moose_walkMaxVel hspeed = -global.moose_walkMaxVel;
			if wanderTimer <= 0 WanderWait();
			break;
		case WanderState.RIGHT:
			hspeed += global.moose_walkAccel;
			if hspeed > global.moose_walkMaxVel hspeed = global.moose_walkMaxVel;
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
	wanderTimer = random_range(global.moose_wanderTimeMin, global.moose_wanderTimeMax);
}
function WanderWait()
{
	hspeed = 0;
	wanderTimer = random_range(global.moose_wanderWaitMin, global.moose_wanderWaitMax);
	currentWanderState = WanderState.WAIT;
}

function MoveHitsToMoose()
{
	obj_EnemyAttackEffect.x = x;
	obj_EnemyAttackEffect.y = y;
	obj_EnemyHitbox.x = x;
	obj_EnemyHitbox.y = y;
}

function ShowMooseAttack(Anim, Hitbox)
{
	obj_EnemyAttackEffect.ShowEnemyAttack(Anim, 1);
	obj_EnemyHitbox.SpawnEnemyHitbox(Hitbox, 1);
}
function HideMooseAttack()
{
	obj_EnemyAttackEffect.HideEnemyAttack();
	obj_EnemyHitbox.DespawnEnemyHitbox();
}

function FacePlayer()
{
	if obj_Player.x > x 
	{
		image_xscale = -1;
		facing = Direction.RIGHT;
	}
	else
	{
		image_xscale = 1;
		facing = Direction.LEFT;
	}
}