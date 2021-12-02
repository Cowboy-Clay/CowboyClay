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
	Gravity(1,10);
	LimitMooseSpeed();
	
	PlayMooseAnimation();
	
	SetMooseDirection();
	
	MooseInvuln();
}

CheckEnvironCollisions(spr_enemy_collision);