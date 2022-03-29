/// @description Insert description here
// You can write your code in this editor
if !global.paused
{
	if current_state != MooseState.LOCK && current_state != MooseState.DEAD
	{
		UpdateMooseState();
		MooseStateBasedActions();
		MoosePickupSword();
	}
	else if current_state == MooseState.LOCK
	{
		MooseWanderToIdle();
	}
	else if current_state == MooseState.DEAD obj_player.current_state = PlayerState.LOCK;
	
	Friction(GetMooseFriction());
	Gravity(get_gravity(),50,spr_enemy_collision, collision_mask);
	//LimitMooseSpeed();
	
	update_animation();
	PlayMooseAnimation();
	
	SetMooseDirection();
	
	MooseInvuln();
}

collision_check(spr_enemy_collision,collision_mask, false, false);

message_state();