/// @description Insert description here
// You can write your code in this editor
if !global.paused
{
	if currentState != MooseState.LOCK && currentState != MooseState.DEAD
	{
		UpdateMooseState();
		MooseStateBasedActions();
		MoosePickupSword();
	}
	else if currentState == MooseState.LOCK
	{
		MooseWanderToIdle();
	}
	else if currentState == MooseState.DEAD obj_player.currentState = PlayerState.LOCK;
	
	Friction(GetMooseFriction());
	Gravity(1,10,spr_enemy_collision, collision_mask);
	LimitMooseSpeed();
	
	update_animation();
	PlayMooseAnimation();
	if currentState == MooseState.PULLING
	{
		image_index = spr_moose_pull;
	}
	else
	{
		
		
	}
	
	SetMooseDirection();
	
	MooseInvuln();
}

collision_check(spr_enemy_collision,collision_mask, false, false);