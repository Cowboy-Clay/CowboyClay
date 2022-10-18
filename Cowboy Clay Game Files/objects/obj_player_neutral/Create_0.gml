current_stance = stance.neutral;

collision_mask = [obj_wall_breakable, obj_Ground, obj_Wall, obj_plate, obj_door,obj_box, obj_elevator, obj_tile_coll, obj_house, obj_tallHouse, obj_longHouse, obj_midHouse, obj_punching_bag];

global.player_stance_switch_flag = false;

enum player_neutral_states { idle, walking, jump_anti, jumping, falling };
current_state = player_neutral_states.idle;

#region Physics Variables
global.player_gravityAccel = 1; // The basic rate of acceloration due to gravity
global.player_gravityMax = 20; // The basic maximum of gravity
#endregion

#region Walk Variables
facing = Direction.RIGHT;
global.player_frictionValue = .40; // The basic rate of friction
global.player_walkAccel = .8; // The basic rate of acceloration from walking
global.player_maxWalkSpeed = 8; // The basic max walking speed
#endregion

animation_set(global.player_animation_neutral_idle);

function walk()
{
	var curAc = global.player_walkAccel;
	
	switch current_state
	{
		case player_neutral_states.jumping:
			curAc = curAc * global.player_speedMulti_jumping;
			break;
		case player_neutral_states.falling:
			curAc = curAc * global.player_speedMulti_falling;
			break;
	}
	// Left movement
	if input_check(input_action.left) && !input_check(input_action.right)
	{
		hspeed -= curAc;
	}
	// Right movement
	else if input_check(input_action.right) && !input_check(input_action.left)
	{
		hspeed += curAc;
	}
	
	if hspeed > 0 && input_check(input_action.right)  facing = Direction.RIGHT;
	else if hspeed < 0 && input_check(input_action.left) facing = Direction.LEFT;
	
	var max_speed = global.player_maxWalkSpeed;

	if abs(hspeed) > max_speed && current_state != player_neutral_states.jumping && current_state != player_neutral_states.falling
	{
		hspeed = sign(hspeed) * lerp(abs(hspeed), max_speed, .2);
		//hspeed = sign(hspeed) * global.player_maxWalkSpeed;
	}
}

function friction_get()
{
	var fVal = global.player_frictionValue;
	switch current_state
	{
		case player_neutral_states.jump_anti:
			fVal *= global.player_frictMulti_jumpAnti;
			break;
		case player_neutral_states.jumping:
			fVal *= global.player_frictMulti_jumping;
			break;
		case player_neutral_states.falling:
			fVal *= global.player_frictMulti_jumping;
			break;
	}
	return fVal;
}

function gravity_get()
{
	var g = global.player_gravityAccel;
	if vspeed < 0 return g;
	return g;
}

function SetPlayerFacingDirection()
{
	if facing == Direction.RIGHT
		image_xscale = 1;
	else image_xscale = -1;
}

function animation_update(){
	if current_state == player_neutral_states.idle {
		animation_set(global.player_animation_neutral_idle);
		return;
	}
	
	if current_state == player_neutral_states.walking {
		animation_set(global.player_animation_neutral_run);
		return;
	}
}