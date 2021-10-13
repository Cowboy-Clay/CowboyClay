/// @description Insert description here
// You can write your code in this editor

//Gravity
if !place_meeting(x,y, obj_Ground) && vspeed < max_gravity
{
	vspeed += grav;
}

// Basic controls
Run();
Jump();
AttackControls();

// If no inputs are being pushed play the idle animation
if keyboard_check(vk_nokey){
	sprite_index = spr_SwordIdle;
}

if !instance_exists(obj_Sword) && sprite_index == spr_FrontSlash
{
	sprite_index = spr_SwordIdle;
}

// Plays jump sprite if not on ground
if(!place_meeting(x,y+1, obj_Ground)){
	sprite_index = spr_ProtoJump;
}

turn_sprite();

invin_update();

//Collision with ground
if (place_meeting(x, y + vspeed, obj_Ground)){
		//while (!place_meeting(x, y + sign(vspeed), obj_Ground)) {
		//	y += sign(vspeed);
		//}
		vspeed = 0;
		grounded = true;		
}
else
{
	grounded = false;
}

// Debugging code to respawn enemy
if(keyboard_check_pressed(ord("E")))
{
	instance_activate_object(obj_Enemy);
	obj_Enemy.armed = true;
}