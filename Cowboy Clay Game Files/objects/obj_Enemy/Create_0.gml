/// @description Insert description here
// You can write your code in this editor

//Give him a sword!
frict = 0;
h_accel = 1;
max_hspeed = 20;
grav = 0.95;
max_gravity = 160;
approach_distance = 375;
attacking_distance = 120;
retreat_distance = 350;
my_enemy_state = enemy_state.neutral;
player_is_attacking = false;

enum enemy_state
{
	neutral, charging, attacking, wander, search
};

function Approaching(){
	
	if obj_Player.attacking
	{
		player_is_attacking = true;
	}

	else if player_is_attacking
	{
		// Attack if armed
		if(armed)
			my_enemy_state = enemy_state.charging;
		else if !armed && invuln_timer<= 0
			my_enemy_state = enemy_state.search;
		player_is_attacking = false;
	}

	
	if abs(obj_Player.x - x) > approach_distance{
	
		var player_dir = 1;
	
		if obj_Player.x < x{
			player_dir = -1;
		}
	
		hspeed += h_accel * player_dir;
	
	}
	
	else if abs(obj_Player.x - x) < retreat_distance{
		
		var player_dir = 1;
	
		if obj_Player.x < x{
			player_dir = -1;
		}
	
		hspeed += h_accel * player_dir * -1;
	
	}

	else {
		hspeed = 0;
	}
	

}

function Charging()
{
	
	instance_activate_object(obj_EnemySword);
	obj_EnemySword.swordTrue = true;
	if abs(obj_Player.x - x) > attacking_distance {
		var player_dir = 1;
	
	
		if obj_Player.x < x{
			player_dir = -1;
			
		}
	
		hspeed += h_accel * player_dir;
		
		if place_meeting (obj_Player.x, obj_Player.y, obj_EnemySword){
			my_enemy_state = enemy_state.wander;
			obj_EnemySword.swordTrue = false;
			show_debug_message("Hit")
			obj_Player.Hurt(x);
			

		}
	}
	
	else
	{
		my_enemy_state = enemy_state.neutral;
		obj_EnemySword.swordTrue = false;
		//obj_EnemySword.EnemyReset();
	}
}

function Wander(){
	
	hspeed = 0;
	if obj_Player.invin 
	{
		 return;
	}
	my_enemy_state = enemy_state.neutral;
	
}

function TakeHit()
{
	if armed
	{
		instance_activate_object(obj_EnemySword);
		obj_EnemySword.Flung();
		invuln_timer = invuln_time;
		armed = false;
	}
	
	// Kill self when hit while disarmed
	else if(!armed && invuln_timer <= 0)
	{
		instance_deactivate_object(self)
	}
}

function Search()
{
	if instance_exists(obj_EnemySword) 
	{
		if obj_EnemySword.x < x hspeed -= h_accel;
		else if obj_EnemySword.x > x hspeed += h_accel;
			
		if hspeed < -1 * max_hspeed hspeed = -1 * max_hspeed;
		else if hspeed > max_hspeed hspeed = max_hspeed;
		
		if place_meeting(x+hspeed, obj_EnemySword.y, obj_EnemySword) && obj_EnemySword.my_sword_state == sword_state.stuck
		{
			armed = true;
			my_enemy_state = enemy_state.neutral;
			obj_EnemySword.my_sword_state = sword_state.neutral;
			instance_deactivate_object(obj_EnemySword);
		}
	}
}