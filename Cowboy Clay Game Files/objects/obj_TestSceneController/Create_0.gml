/// @description Insert description here
// You can write your code in this editor

state = 0;

function ToState1()
{
	obj_Moose.GoToHit();
	instance_activate_object(obj_Sword);
	state = 1;
}