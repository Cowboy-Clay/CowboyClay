/// @description Insert description here
// You can write your code in this editor

offset = 30;
swordTime = 7;
timer = swordTime;
my_sword_state = sword_state.neutral;
grav = 0.95;
max_gravity = 160;
flinging_h_accel = 50;
flinging_v_accel = 70;
retrieve_distance = 8;

enum sword_state
{
	neutral, flung, stuck
};

function Reset()
{
	timer = swordTime;
	obj_Player.attacking = true;
}

function Flung(enemy_x)
{
	if(my_sword_state == sword_state.neutral){
		x = obj_Player.x;
		y = obj_Player.y;
		hspeed = flinging_h_accel * sign(obj_Player.x - enemy_x);
		vspeed = -flinging_v_accel;
		my_sword_state = sword_state.flung;
	}
}

function Flinging(){
	
	Gravity();
	//Collision with ground
	if (place_meeting(x, y + vspeed, obj_Ground))
		{
			while (!place_meeting(x, y + sign(vspeed), obj_Ground)) 
			{
				y += sign(vspeed);
			}

		my_sword_state = sword_state.stuck;
	}
}



