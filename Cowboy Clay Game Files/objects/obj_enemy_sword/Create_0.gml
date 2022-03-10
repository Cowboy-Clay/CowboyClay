currentState = SwordState.INACTIVE;

falling = false;

animFrameCounter = 0;
currentFPI = 1;
currentAnimType = AnimationType.FIRST_FRAME;

global.enemy_sword_grav = .3;
global.enemy_sword_grav_max = 5;

global.enemy_sword_stickInWallBump = 50;
global.enemy_sword_stickInFloorBump = 30;

global.enemy_sword_defaultAnim = spr_enemy_sword;
global.enemy_sword_defaultAnimFPI = 1;
global.enemy_sword_defaultAnimType = AnimationType.FIRST_FRAME;
global.enemy_sword_spinAnim = spr_enemy_sword;
global.enemy_sword_spinAnimFPI = 4;
global.enemy_sword_spinAnimType = AnimationType.LOOP;
collision_mask = [obj_tile_coll, obj_plate, obj_elevator, obj_box, obj_door];

function EnemySwordFling(run, rise, m)
{
	if currentState != SwordState.INACTIVE return;
	show_debug_message(run);
	// Set state
	falling = false;
	currentState = SwordState.FLYING;
	// Set starting position
	x = obj_Moose.x;
	y = obj_Moose.y;
	// Normalize run and rise
	a = run;
	b = rise;
	c = sqrt((run*run) + (rise*rise));
	a = a/c;
	b = b/c;
	run = sign(a) * sqrt(1-(b*b));
	rise = sign(b) * sqrt(1-(a*a));
	show_debug_message(run);
	// Apply impulse
	hspeed = run * m;
	vspeed = rise * m;
	// Set animation
	SetEnemySwordAnimation(global.enemy_sword_spinAnim, global.enemy_sword_spinAnimFPI, global.enemy_sword_spinAnimType);
}

function EnemySwordStickInWall(s)
{
	currentState = s;
	if s == SwordState.STUCK_WALL_LEFT x -= global.enemy_sword_stickInWallBump;
	else x += global.enemy_sword_stickInWallBump;
	SetEnemySwordAnimation(global.enemy_sword_defaultAnim, global.enemy_sword_defaultAnimFPI, global.enemy_sword_defaultAnimType);
}

function EnemySwordStickInGround()
{
	currentState = SwordState.STUCK_FLOOR;
	y += global.enemy_sword_stickInFloorBump;
	SetEnemySwordAnimation(global.enemy_sword_defaultAnim, global.enemy_sword_defaultAnimFPI, global.enemy_sword_defaultAnimType);
}

function SetEnemySwordRotation()
{
	switch currentState
	{
		case SwordState.INACTIVE:
			image_angle = 0;
			break;
		case SwordState.FLYING:
			image_angle = 0;
			break;
		case SwordState.STUCK_FLOOR:
			image_angle = 90;
			break;
		case SwordState.STUCK_WALL_LEFT:
			image_angle = 0;
			break;
		case SwordState.STUCK_WALL_RIGHT:
			image_angle = 180;
			break;
	}
}

function CheckEnemySwordCollisions()
{
//	// If the sword won't collide with anything this frame return
//	if place_meeting_mask(x+hspeed, y+vspeed, collision_mask) == false return;
//	// Otherwise move it and stop it motion
//	x = x+hspeed;
//	hspeed = 0;
//	y = y+vspeed;
//	vspeed = 0;
//	// Find the nearest object we could have collided with
//	c = instance_nearest_mask(x,y,collision_mask);
//	if c == noone
//	{
//		show_error("Sword thought it collided with something but no objects were found.", false);
//		return;
//	}
//	// Calculate the difference in the x and y directions
//	dx = abs(x-c.x);
//	dy = abs(y-c.y);
//	// We will assume that if the dx is larger that means we've hit a wall and if dy is larger we've hit a floor
//	if dx > dy
//	{
//		if x > c.x return 1;
//		else return 2;
//	}
//	else
//	{
//		return 3;
//	}
}

function SetEnemySwordAnimation(a, f, t)
{
	sprite_index = a;
	currentFPI = f;
	currentAnimType = t;
	animFrameCounter = 0;
}

function EnemySwordAnimate()
{
	visible = currentState != SwordState.INACTIVE;
	
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

function EnemySwordCanBePickedUp()
{
	return currentState == SwordState.STUCK_FLOOR || currentState == SwordState.STUCK_WALL_LEFT || currentState == SwordState.STUCK_WALL_RIGHT;
}