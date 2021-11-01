/// @description Insert description here
// You can write your code in this editor


switch my_sword_state{
	
	case sword_state.neutral:
		if obj_Player.sprite_index != spr_FrontSlash
		{
			obj_Player.attacking = false;
			instance_deactivate_object(obj_Sword);
		}
		break;
	
	case sword_state.flung:
		Flinging();
		sprite_index = protospin;
		break;
	
	case sword_state.stuck:
		hspeed = 0;
		vspeed = 0;
		sprite_index = protoswordstuck;
		break;
	}


//show_debug_message("Sword Location: " + string(x) + " , " + string(y));
//show_debug_message(string(my_sword_state));

// The sword is ready to be picked up
if my_sword_state == sword_state.stuck && place_meeting(x,y,obj_Player){
	
	if keyboard_check_pressed(ord("Z"))
	{
		image_angle = 0;
		sprite_index = spr_Sword;
		my_sword_state = sword_state.neutral;
		obj_Player.attacking = false;
		obj_Player.Retrieve_Sword();
		instance_deactivate_object(obj_Sword);
	}
}

