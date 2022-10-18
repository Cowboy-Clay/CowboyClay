if audio_group_is_loaded(sfx_elevator) == false {
	audio_group_load(sfx_elevator);
}

enum elevator_state { falling, rising, holding, broken, sitting };
current_state = elevator_state.sitting;

grounded = false;

collision_mask = [obj_Ground, obj_Wall, obj_plate, obj_door,obj_box, obj_tile_coll, obj_elevatorBlocker];

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

frames_per_image_up = 4;
frames_per_image_down = 2;
animation_counter = 0;

function check_mounted()
{
	mounted = collision_check_edge(x,y-1,spr_mech_elevator_coll,Direction.UP,[obj_player_fighting]);
}

function get_hit()
{
	cooldown_timer = cooldown;
	current_state = elevator_state.rising;
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
	collision_check_elevator(spr_mech_elevator_coll, collision_mask,false, false);
	if mounted obj_player_fighting.vspeed = vspeed;
}

function go_to_holding()
{
	holding_timer = holding_time;
	current_state = elevator_state.holding;
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
	current_state = elevator_state.falling;
}

function fall()
{
	Gravity(1,10,spr_mech_elevator_coll,collision_mask);
	collision_check_elevator(spr_mech_elevator_coll, collision_mask, false, false);
	if collision_check_edge(x,y,spr_mech_elevator_coll, Direction.DOWN, collision_mask) {
		current_state = elevator_state.sitting;
		audio_play_sound(sfx_elevator_crash,-10,false);
		//show_debug_message("Going to sitting");
	}
	if mounted obj_player_fighting.vspeed = vspeed;
}

function sit()
{
	cooldown_timer = -1;
	vspeed = 0;
	if !collision_check_edge(x,y,spr_mech_elevator_coll, Direction.DOWN, collision_mask) {
		go_to_falling();
	}
}