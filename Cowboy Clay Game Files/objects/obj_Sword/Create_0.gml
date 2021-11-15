/// @description Insert description here
// You can write your code in this editor

offset = 49;

if stuckOnStart
	my_sword_state = sword_state.stuck;
else
	my_sword_state = sword_state.neutral;

grav = 0.95; 
max_gravity = 160;
flinging_h_accel = 35;
flinging_v_accel = 25;

enum sword_state
{
	neutral, flung, stuck
};

function Flung(enemy_x)
{
		x = obj_NewPlayer.x;
		y = obj_NewPlayer.y;
		hspeed = flinging_h_accel * sign(obj_NewPlayer.x - enemy_x);
		vspeed = -flinging_v_accel;
		my_sword_state = sword_state.flung;
}

function Flinging(){
	
	Gravity(grav, max_gravity);
	
	// Collision with wall
	if place_meeting(x + hspeed, y, obj_Wall)
	{
		if hspeed > 0
		{
			image_angle = 90;
		}
		else
		{
			image_angle = -90;
		}
		
		while place_meeting(x + hspeed, y, obj_Wall)
		{
			x -= 0.1 * sign(hspeed);
		}
		while place_meeting(x, y + vspeed, obj_Ground)
		{
			y -= 0.1 * sign(vspeed);
		}
		
		my_sword_state = sword_state.stuck;
	}
	
	//Collision with ground
	if (place_meeting(x, y + vspeed, obj_Ground))
	{
		image_angle = 0;
		
		while place_meeting(x + hspeed, y, obj_Wall)
		{
			x -= 0.1 * sign(hspeed);
		}
		while place_meeting(x, y + vspeed, obj_Ground)
		{
			y -= 0.1 * sign(vspeed);
		}
		
		//hspeed = 0;
		//vspeed = 0;
			
		my_sword_state = sword_state.stuck;
	}
}