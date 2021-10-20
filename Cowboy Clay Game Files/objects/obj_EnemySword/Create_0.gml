/// @description Insert description here
// You can write your code in this editor
default_offset = 30;
offset = default_offset;
default_image_scale = image_xscale;
swordTime = 7;
swordTrue = false;
my_sword_state = sword_state.neutral;
flinging_h_accel = 35;
flinging_v_accel = 25;
max_gravity = 160;
grav = 0.95;

function Flung()
{
	if(my_sword_state == sword_state.neutral){
		x = obj_Enemy.x;
		y = obj_Enemy.y;
		hspeed = flinging_h_accel * sign(obj_Enemy.x - obj_Player.x);
		vspeed = -flinging_v_accel;
		my_sword_state = sword_state.flung;
	}
}

function Flinging(){
	
	Gravity();
	
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

function Gravity()
{
	if !place_meeting(x,y, obj_Ground) && vspeed < max_gravity
	{
		vspeed += grav;
	}
}