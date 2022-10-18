enum SwordState { INACTIVE, FLYING, STUCK_FLOOR, STUCK_WALL_LEFT, STUCK_WALL_RIGHT, KICKED };
current_state = stuckOnStart ? SwordState.STUCK_FLOOR : SwordState.INACTIVE;
if stuckOnStart{
	sprite_index = spr_player_sword_stuck;
	if in_wall_on_start {
		current_state = left_wall ? SwordState.STUCK_WALL_LEFT : SwordState.STUCK_WALL_RIGHT;
	}
}

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
	if current_state != SwordState.INACTIVE return;
	// Set state
	current_state = SwordState.FLYING;
	// Set starting position
	x = obj_player_fighting.x;
	y = obj_player_fighting.y-100;
	// Normalize run and rise
	a = run;
	b = rise;
	c = sqrt((run*run) + (rise*rise));
	a = a/c;
	b = b/c;
	run = sign(a) * sqrt(1-(b*b));
	rise = sign(b) * sqrt(1-(a*a));
	// Apply impulse
	hspeed = run * m;
	vspeed = rise * m;
	// Set animation
	SetSwordAnimation(global.sword_spinAnim, global.sword_spinAnimFPI, global.sword_spinAnimType);
}

function PlayerSwordStickInWall(s)
{
	current_state = s;
	if s == SwordState.STUCK_WALL_LEFT x -= global.sword_stickInWallBump;
	else x += global.sword_stickInWallBump;
	SetSwordAnimation(spr_player_sword_stuck, global.sword_defaultAnimFPI, global.sword_defaultAnimType);
}

function PlayerSwordStickInGround()
{
	current_state = SwordState.STUCK_FLOOR;
	y += global.sword_stickInFloorBump;
	SetSwordAnimation(spr_player_sword_stuck, global.sword_defaultAnimFPI, global.sword_defaultAnimType);
}

function SetPlayerSwordRotation()
{
	switch current_state
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
		case SwordState.KICKED:	
			image_angle = 0;
			break;
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
	visible = current_state != SwordState.INACTIVE;
	
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
	
	return current_state == SwordState.STUCK_FLOOR || current_state == SwordState.STUCK_WALL_LEFT || current_state == SwordState.STUCK_WALL_RIGHT;
}

function teleport_to(xPos,yPos)
{
	PlayerSwordStickInGround();
	x=xPos;
	y=yPos;
}

function to_kicked() {
	if current_state != SwordState.STUCK_WALL_LEFT && current_state != SwordState.STUCK_WALL_RIGHT return;
	SetSwordAnimation(spr_player_sword_spin,global.sword_spinAnimFPI,AnimationType.LOOP);
	if current_state == SwordState.STUCK_WALL_LEFT {
		while(collision_check_edge(x,y,sprite_index, Direction.LEFT,collision_mask)) {
			x++;
		}
	} else {
		while(collision_check_edge(x,y,sprite_index, Direction.RIGHT,collision_mask)) {
			x--;
		}
	}
	current_state = SwordState.KICKED;
}

function kicked() {
	Gravity(global.sword_grav, global.sword_grav_max,sprite_index,collision_mask);
	if collision_check_edge(x,y,spr_player_sword,Direction.DOWN,collision_mask){
		PlayerSwordStickInGround();
		return;
	}
}
