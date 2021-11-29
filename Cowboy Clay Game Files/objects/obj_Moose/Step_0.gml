/// @description Insert description here
// You can write your code in this editor
if !global.paused
{
	UpdateMooseState();
	MooseStateBasedActions();
	
	Friction(GetMooseFriction());
	LimitMooseSpeed();
	
	PlayMooseAnimation();
	
	SetMooseDirection();
}

CheckEnvironCollisions(spr_enemy_collision);