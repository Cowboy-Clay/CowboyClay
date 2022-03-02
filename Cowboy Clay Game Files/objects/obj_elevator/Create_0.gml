enum elevator_state { falling, rising, holding };
state = elevator_state.falling;

collision_mask = [obj_Ground, obj_Wall, obj_plate, obj_door,obj_box, obj_tile_coll];

cooldown = 30;
cooldown_timer = 0;

impulse_speed = 8;
impulse_speed = 8;
impulse_speed = 8;
curr_speed = 0;
time_before_slow = 30;
rising_timer = 0;
deceleration = .5;

holding_time = 60;
holding_timer = 0;

mounted = false;

function check_mounted()
{
	mounted = place_meeting(x,y-5,obj_player) &&
		obj_player.y < y &&
		abs(obj_player.x - x) <= sprite_get_width(spr_mech_elevator_coll)/2;
}

function get_hit()
{
	cooldown_timer = cooldown;
	state = elevator_state.rising;
	rising_timer = time_before_slow;
	curr_speed = impulse_speed;
}

function rise()
{
	if rising_timer > 0
	{
		rising_timer--;
	}
	else
	{
		curr_speed -= deceleration;
	}
	
	vspeed = -curr_speed;
	
	if vspeed >= 0
	{
		vspeed = 0;	
		go_to_holding();
	}
	if mounted obj_player.vspeed = vspeed;
}

function go_to_holding()
{
	holding_timer = holding_time;
	state = elevator_state.holding;
}

function hold()
{
	holding_timer--;
	if holding_timer <= 0
	{
		go_to_falling();
	}
}

function go_to_falling()
{
	state = elevator_state.falling();
}

function fall()
{
	Gravity(1,10,spr_mech_elevator_coll,collision_mask);
	CheckEnvironCollisions(spr_mech_elevator_coll, collision_mask);
	if mounted obj_player.vspeed = vspeed;
}