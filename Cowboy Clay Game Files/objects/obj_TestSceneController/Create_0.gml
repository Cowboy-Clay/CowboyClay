/// @description Insert description here
// You can write your code in this editor

state = 0;

function ToState1()
{
	obj_Enemy.hspeed = 30 * sign(x - obj_Player.x);
	obj_Enemy.my_enemy_state = enemy_state.neutral;
	instance_activate_object(obj_Sword);
	vspeed = - 40;
	state = 1;
}