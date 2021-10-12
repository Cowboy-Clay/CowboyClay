enum player_state
{
	neutral, hurt, disarmed
};

function Run()
{
	// Left movement
	if keyboard_check(vk_left) && !keyboard_check(vk_right)
	{
		hspeed -= h_accel; 
		if hspeed < -max_velocity
		{
			hspeed = -max_velocity;
		}
		sprite_index = spr_Run;
	}
	// Right movement
	else if keyboard_check(vk_right) && !keyboard_check(vk_left)
	{
		hspeed += h_accel;
		if hspeed > max_velocity
		{
			hspeed = max_velocity;
		}
		sprite_index = spr_Run;
	}
	
	frict();
	zero_velocity();
}

function Jump(){
	if (place_meeting(x, y + vspeed, obj_Ground)) && keyboard_check_pressed(ord("X"))
	{
		vspeed -= jump_accel;
	}
	
	if !keyboard_check(ord("X")) && vspeed < 0 
	{
		vspeed /= 1.7;
	}
}

function AttackControls(){	
	//Sword
	if keyboard_check_pressed(ord("Z")) && armed
	{
		//instance_create_layer(x,y,"Instances",obj_Sword);
		instance_activate_object(obj_Sword);
		obj_Sword.Reset();
		sprite_index = spr_FrontSlash;
	}
}

//Add Hurt State - On Collision, Switch State, Push Away From Enemy Weapon, length of invincibility

function Knockback(enemy_x){
//Collision Between Player and Enemy Sword, if invincibility is inactive
		//Apply Knockback
		hspeed += 30 * sign(obj_Player.x - enemy_x);
		vspeed -= 50;
		invin = true;
		invin_timer = 30;
		show_debug_message("Knockback")
		my_player_state = player_state.disarmed;
		instance_activate_object(obj_Sword);
		obj_Sword.Flung(enemy_x);
}

function Hurt(enemy_x)
{
	//my_player_state = player_state.hurt;
	Knockback(enemy_x);
	armed = false;
}

function Retrieve_Sword()
{
	show_debug_message("Got Sword");
	my_player_state = player_state.neutral;
	armed = true;
}

function turn_sprite()
{
	if image_xscale < 0 && hspeed > 0
	{
		image_xscale *= -1;
	}
	else if image_xscale > 0 && hspeed < 0
	{
		image_xscale *= -1;
	}
}

function frict()
{
	if hspeed >= frict_value
	{
		hspeed -= frict_value;
	}
	if hspeed <= -frict_value
	{
		 hspeed += frict_value;
	}
}

function zero_velocity()
{
	if (!keyboard_check(vk_left) && !keyboard_check(vk_right)) && (hspeed < 0 && hspeed > -frict_value || hspeed > 0 && hspeed < frict_value)
	{
		hspeed = 0;
	}
}

function invin_update()
{
	if invin_timer > 0
	{
		invin_timer--;
	}
	if invin_timer <= 0 
	{
		invin = false;
	}
}