current_stance = stance.sitting;

collision_mask = [obj_wall_breakable, obj_Ground, obj_Wall, obj_plate, obj_door,obj_box, obj_elevator, obj_tile_coll, obj_house, obj_tallHouse, obj_longHouse, obj_midHouse, obj_punching_bag];


enum player_sitting_states { idle, falling };
current_state = player_sitting_states.idle;

#region Physics Variables
global.player_gravityAccel = 1; // The basic rate of acceloration due to gravity
global.player_gravityMax = 20; // The basic maximum of gravity
#endregion

#region Walk Variables
global.player_frictionValue = .40; // The basic rate of friction
facing = Direction.RIGHT;
#endregion

animation_set(global.player_animation_sitting_idle);

function friction_get()
{
	var fVal = global.player_frictionValue;
	switch current_state
	{
		case player_sitting_states.falling:
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
	if current_state == player_sitting_states.idle {
		animation_set(global.player_animation_sitting_idle);
		return;
	}
}