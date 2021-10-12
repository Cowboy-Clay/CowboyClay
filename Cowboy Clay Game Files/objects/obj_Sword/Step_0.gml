/// @description Insert description here
// You can write your code in this editor

timer--;



switch my_sword_state{
	
	case sword_state.neutral:
	
		if timer <= 0 {
		obj_Player.attacking = false;
		instance_deactivate_object(obj_Sword);
		
					}
	break;
	
	case sword_state.flung:
		Flinging();
		
	break;
	
	case sword_state.stuck:
		hspeed = 0;
		vspeed = 0;
		sprite_index = spr_StuckSword;
	break;
	
}


//show_debug_message("Sword Location: " + string(x) + " , " + string(y));
show_debug_message(string(my_sword_state));

if my_sword_state == sword_state.stuck && abs(obj_Player.x - x) < retrieve_distance {
	//my_sword_state = sword_state.neutral;
	sprite_index = spr_Sword;
	my_sword_state = sword_state.neutral;
	obj_Player.Retrieve_Sword();
}