/// @description Insert description here
// You can write your code in this editor

switch (my_sword_state)
{
	case sword_state.neutral:
		if !swordTrue {
			instance_deactivate_object(obj_EnemySword);
		}
		break;
		
	case sword_state.flung:
		Flinging();
		break;
		
	case sword_state.stuck:
		hspeed = 0;
		vspeed = 0;
		break;
}