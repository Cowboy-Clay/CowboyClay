/// @description Insert description here
// You can write your code in this editor
if !global.paused
{
	UpdateMooseState();
	MooseStateBasedActions();
	
	Friction(GetMooseFriction());
	Gravity(1,10);
	LimitMooseSpeed();
	
	PlayMooseAnimation();
	
	SetMooseDirection();
}

CheckEnvironCollisions(spr_enemy_collision);