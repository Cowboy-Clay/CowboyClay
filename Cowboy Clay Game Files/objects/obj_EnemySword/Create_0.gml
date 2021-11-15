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

stuckInWall = false;

function Flung()
{
	if(my_sword_state == sword_state.neutral){
		x = obj_Moose.x;
		y = obj_Moose.y - 100;
		hspeed = flinging_h_accel * sign(obj_Moose.x - obj_NewPlayer.x);
		vspeed = -flinging_v_accel;
		my_sword_state = sword_state.flung;
	}
}

function Flinging(){
	
	Gravity(grav, max_gravity);
	
	if place_meeting(x + hspeed, y, obj_Wall)
	{
		stuckInWall = true;
		
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
		stuckInWall = false;
		
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

function MoveInbounds()
{
	if x < minX -25 x = minX;
	if x > maxX +25 x = maxX;
	if y < minY -25 y = minY;
	if y > maxY +25 y = maxY;
}