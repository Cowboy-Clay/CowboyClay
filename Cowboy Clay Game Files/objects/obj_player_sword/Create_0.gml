currentState = SwordState.INACTIVE;

collision_mask = [obj_tile_coll, obj_plate, obj_elevator, obj_box, obj_door];

animFrameCounter = 0;
currentFPI = 1;
currentAnimType = AnimationType.FIRST_FRAME;

plungeFlag = false;

global.sword_grav = .3;
global.sword_grav_max = 5;

global.sword_stickInWallBump = 50;
global.sword_stickInFloorBump = 30;

global.sword_defaultAnim = spr_player_sword;
global.sword_defaultAnimFPI = 1;
global.sword_defaultAnimType = AnimationType.FIRST_FRAME;
global.sword_spinAnim = spr_player_sword_spin;
global.sword_spinAnimFPI = 4;
global.sword_spinAnimType = AnimationType.LOOP;

function PlayerSwordFling(run, rise, m)
{
	if currentState != SwordState.INACTIVE return;
	show_debug_message(run);
	// Set state
	currentState = SwordState.FLYING;
	// Set starting position
	x = obj_player.x;
	y = obj_player.y;
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
	SetSwordAnimation(global.sword_spinAnim, global.sword_spinAnimFPI, global.sword_spinAnimType);
}

function PlayerSwordStickInWall(s)
{
	currentState = s;
	if s == SwordState.STUCK_WALL_LEFT x -= global.sword_stickInWallBump;
	else x += global.sword_stickInWallBump;
	SetSwordAnimation(global.sword_defaultAnim, global.sword_defaultAnimFPI, global.sword_defaultAnimType);
}

function PlayerSwordStickInGround()
{
	currentState = SwordState.STUCK_FLOOR;
	y += global.sword_stickInFloorBump;
	SetSwordAnimation(global.sword_defaultAnim, global.sword_defaultAnimFPI, global.sword_defaultAnimType);
}

function SetPlayerSwordRotation()
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
			image_angle = 0;
			break;
		case SwordState.STUCK_WALL_LEFT:
			image_angle = -90;
			break;
		case SwordState.STUCK_WALL_RIGHT:
			image_angle = 90;
			break;
	}
}

function CheckSwordCollisions()
{
	// If the sword won't collide with anything this frame return
	if place_meeting_mask(x+hspeed, y+vspeed, collision_mask) == false return;
	// Otherwise move it and stop it motion
	x = x+hspeed;
	hspeed = 0;
	y = y+vspeed;
	vspeed = 0;
	// Find the nearest object we could have collided with
	c = instance_nearest_mask(x,y,collision_mask);
	if c == noone
	{
		show_error("Sword thought it collided with something but no objects were found.", false);
		return;
	}
	// Calculate the difference in the x and y directions
	dx = abs(x-c.x);
	dy = abs(y-c.y);
	// We will assume that if the dx is larger that means we've hit a wall and if dy is larger we've hit a floor
	if dx > dy
	{
		if x > c.x return 1;
		else return 2;
	}
	else
	{
		return 3;
	}
}

function SetSwordAnimation(a, f, t)
{
	sprite_index = a;
	currentFPI = f;
	currentAnimType = t;
	animFrameCounter = 0;
}

function SwordAnimate()
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

function SwordCanBePickedUp()
{
	if plungeFlag
	{
		plungeFlag = false;
		return false;
	}
	
	return currentState == SwordState.STUCK_FLOOR || currentState == SwordState.STUCK_WALL_LEFT || currentState == SwordState.STUCK_WALL_RIGHT;
}

function teleport_to(xPos,yPos)
{
	PlayerSwordStickInGround();
	x=xPos;
	y=yPos;
}