/// @description Insert description here
// You can write your code in this editor

state = 0;
flag = false;

function ToState1()
{
	obj_Moose.GoToHit();
	instance_activate_object(obj_Sword);
	obj_Sword.visible = true;
	state = 1;
}