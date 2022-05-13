current_state = SwordState.INACTIVE;

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
	if current_state != SwordState.INACTIVE return;
	// Set state
	falling = false;
	current_state = SwordState.FLYING;
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
	// Apply impulse
	hspeed = run * m;
	vspeed = rise * m;
	// Set animation
	SetEnemySwordAnimation(global.enemy_sword_spinAnim, global.enemy_sword_spinAnimFPI, global.enemy_sword_spinAnimType);
}

function EnemySwordStickInWall(s)
{
	current_state = s;
	if s == SwordState.STUCK_WALL_LEFT x -= global.enemy_sword_stickInWallBump;
	else x += global.enemy_sword_stickInWallBump;
	SetEnemySwordAnimation(global.enemy_sword_defaultAnim, global.enemy_sword_defaultAnimFPI, global.enemy_sword_defaultAnimType);
}

function EnemySwordStickInGround()
{
	current_state = SwordState.STUCK_FLOOR;
	y += global.enemy_sword_stickInFloorBump;
	SetEnemySwordAnimation(global.enemy_sword_defaultAnim, global.enemy_sword_defaultAnimFPI, global.enemy_sword_defaultAnimType);
}

function SetEnemySwordRotation()
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
			image_angle = 90;
			break;
		case SwordState.STUCK_WALL_LEFT:
			image_angle = 0;
			break;
		case SwordState.STUCK_WALL_RIGHT:
			image_angle = 180;
			break;
		case SwordState.KICKED:
			image_angle = 0;
	}
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

function EnemySwordCanBePickedUp()
{
	if current_state == SwordState.FLYING || current_state == SwordState.INACTIVE return false;
	return true;
}

function to_fall() {
	if current_state == SwordState.STUCK_WALL_LEFT {
		while collision_check_edge(x,y,sprite_index,Direction.LEFT,collision_mask) {
			x++;
		}
	}
	if current_state == SwordState.STUCK_WALL_RIGHT {
		while collision_check_edge(x,y,sprite_index,Direction.RIGHT,collision_mask) {
			x--;
		}
	}
	
	current_state = SwordState.KICKED;
}
