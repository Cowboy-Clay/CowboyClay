/// @description Insert description here
// You can write your code in this editor

state = 0;

function ToState1()
{
	obj_Enemy.hspeed = 30 * sign(x - obj_Player.x);
	vspeed = - 40;
	state = 1;
}