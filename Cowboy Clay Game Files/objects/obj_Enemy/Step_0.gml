/// @description Insert description here
// You can write your code in this editor


Gravity();

//Collision with ground
if (place_meeting(x, y + vspeed, obj_Ground)){
		while (!place_meeting(x, y + sign(vspeed), obj_Ground)) {
			y += sign(vspeed);
		}
		vspeed = 0;
				
	}

//collision with sword
if instance_exists(obj_Sword) && obj_Sword.my_sword_state == sword_state.neutral && place_meeting(x, y, obj_Sword)
{
	instance_deactivate_object(self)
}



switch my_enemy_state
{
	case enemy_state.neutral: Approaching(); 
	break;
	
	case enemy_state.charging: Charging();
	break;
	
	case enemy_state.wander: Wander();
	break;
}

if abs(hspeed) > max_hspeed{
	hspeed = max_hspeed * sign(hspeed);
}

if !place_meeting(x-300,y+5, obj_Ground) || !place_meeting(x+300,y+5, obj_Ground){
	my_enemy_state = enemy_state.charging;
}

