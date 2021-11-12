/// @description Insert description here
// You can write your code in this editor

UpdateState();
SetAnimation();

// PrintState();

if instance_exists(obj_Sword) && place_meeting(x,y,obj_Sword) && !(currentState == MooseState.WAIT && blockTimer > blockTime) && obj_Sword.my_sword_state == sword_state.neutral
{
	TakeHit();
}

if instance_exists(obj_EnemySword) && obj_EnemySword.my_sword_state == sword_state.stuck && place_meeting(x,y,obj_EnemySword) && !armed == false
{
	obj_EnemySword.my_sword_state = sword_state.neutral;
	armed = true;
	instance_deactivate_object(obj_EnemySword);
	GoToSpace();
}