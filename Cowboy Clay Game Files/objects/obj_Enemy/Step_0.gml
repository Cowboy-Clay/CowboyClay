/// @description Insert description here
// You can write your code in this editor

if armed 
		sprite_index = spr_PirateIdle;
else
		sprite_index = PirateProtoDisarmed;
	
if my_enemy_state = enemy_state.inactive{
		sprite_index = PirateProtoPull;
}
Gravity();

//Collision with ground
if (place_meeting(x, y + vspeed, obj_Ground)){
	while (!place_meeting(x, y + sign(vspeed), obj_Ground)) {
		y += sign(vspeed);
	}
	vspeed = 0;		
}

//Collisions with walls
if place_meeting(x + hspeed, y, obj_Wall)
{
	while !place_meeting(x + hspeed, y, obj_Wall)
	{
		y -= 0.1 * sign(vspeed);
	}
}

//collision with sword
if instance_exists(obj_Sword) && obj_Sword.my_sword_state == sword_state.neutral && place_meeting(x, y, obj_Sword)
{
	TakeHit();
}

if(invuln_timer > 0)
{
	invuln_timer--;
}

switch my_enemy_state
{
	case enemy_state.neutral: Approaching(); 
	break;
	
	case enemy_state.charging: Charging();
	break;
	
	case enemy_state.wander: Wander();
	break;
	
	case enemy_state.search: Search();
	break;
	
	case enemy_state.inactive:
	break;
}

if abs(hspeed) > max_hspeed{
	hspeed = max_hspeed * sign(hspeed);
}

if !place_meeting(x-300,y+5, obj_Ground) || !place_meeting(x+300,y+5, obj_Ground) && my_enemy_state != enemy_state.inactive{
	if(armed)
			my_enemy_state = enemy_state.charging;
		else if !armed && invuln_timer= 0
			my_enemy_state = enemy_state.search;
}

