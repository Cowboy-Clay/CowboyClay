/// @description Insert description here
// You can write your code in this editor

//Gravity
if !place_meeting(x,y, obj_Ground) && vspeed < max_gravity
{
	vspeed += grav;
}

Run();
Jump();
AttackControls();

if keyboard_check(vk_nokey){
	sprite_index = spr_SwordIdle;
}

if(!place_meeting(x+1,y+1, obj_Ground)){
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
	
if(keyboard_check_pressed(ord("E"))){
	instance_activate_object(obj_Enemy);
}

if place_meeting(x, y, obj_EnemySword) {
	my_player_state = player_state.hurt;
}

//show_debug_message ("Invincibility is " + string(invin_timer));
