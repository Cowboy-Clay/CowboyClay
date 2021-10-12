/// @description Insert description here
// You can write your code in this editor
frict = .45;
h_accel = 1;
v_accel = 25;
grav = 0.95;
max_velocity = 20;
max_gravity = 160;
max_vertical_velocity = 10;
grounded = true;
jump_buffer = 20;
jump_buffer_counter = 0;
attacking = false;
my_player_state = player_state.neutral;
invin = false;
invin_timer = 0;
is_neutral = true;



enum player_state
{
	neutral, hurt, disarmed
};

function MovementControls(){
	
	//Horizontal Movement
	if keyboard_check(vk_left) && hspeed > -max_velocity{
		hspeed -= h_accel; 	
	
	}

	else if keyboard_check(vk_right) && hspeed < max_velocity{
		hspeed += h_accel;

	}

	//Variable Jump
if (place_meeting(x, y + vspeed, obj_Ground)) && keyboard_check_pressed(ord("X"))
{
	vspeed -= v_accel;
}
}

function AttackControls(){
		
//Sword
if(keyboard_check_pressed(ord("Z")))
{
//instance_create_layer(x,y,"Instances",obj_Sword);
instance_activate_object(obj_Sword);
obj_Sword.Reset();
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
	
}

function Retrieve_Sword()
{
	show_debug_message("Got Sword");
	my_player_state = player_state.neutral;
}