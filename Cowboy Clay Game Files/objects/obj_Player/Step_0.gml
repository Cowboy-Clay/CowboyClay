/// @description Insert description here
// You can write your code in this editor


//Gravity
if !place_meeting(x,y, obj_Ground) && vspeed < max_gravity
{
	vspeed += grav;
}

//Switch
switch my_player_state{
	
	case player_state.neutral: 
		MovementControls();
		AttackControls();
	break;
	
	case player_state.hurt:
		//Knockback();
		
	break;
	
	case player_state.disarmed:
		MovementControls();
	break;
	
	
}

//sprite changes
if keyboard_check(vk_left) || keyboard_check(vk_right){
	sprite_index = spr_Run;
}

if keyboard_check(vk_nokey){
	sprite_index = spr_SwordIdle;
}
//Attack Animation
if(keyboard_check_pressed(ord("Z"))){
	sprite_index = spr_FrontSlash;
}
if(!place_meeting(x+1,y+1, obj_Ground)){
	sprite_index = spr_ProtoJump;
}


//Turning Around/Flipping Sprite	

if image_xscale < 0 && hspeed > 0{
		image_xscale *= -1;
	}
else if image_xscale > 0 && hspeed < 0{
		image_xscale *= -1;
	}


//Apply Friction
if hspeed >= frict {
	hspeed -= frict;
}

if hspeed <= -frict {
	hspeed += frict;
}

//Zeroing out intertia 
if !keyboard_check(vk_left) || !keyboard_check(vk_right)
{
if hspeed < 0 && hspeed > -frict || hspeed > 0 && hspeed < frict
{
	hspeed = 0;
}
}

//Decrease invincibility
if invin_timer > 0
{
	invin_timer--;
}

if invin_timer <= 0 
{
	invin = false;
}



//Falling
if !keyboard_check(ord("X")) && vspeed < 0 
{
	vspeed /= 1.7;
}

//Collision with ground
if (place_meeting(x, y + vspeed, obj_Ground)){
		while (!place_meeting(x, y + sign(vspeed), obj_Ground)) {
			y += sign(vspeed);
		}
		vspeed = 0;
		grounded = true;		
	}
	
if(keyboard_check_pressed(ord("E"))){
	instance_activate_object(obj_Enemy);
}

if place_meeting(x, y, obj_EnemySword) {
	my_player_state = player_state.hurt;
}

//show_debug_message ("Invincibility is " + string(invin_timer));
