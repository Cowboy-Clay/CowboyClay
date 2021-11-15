/// @description Insert description here
// You can write your code in this editor

if state == 0
{
	instance_deactivate_object(obj_Sword);
}
if state == 1 && !flag
{
	instance_activate_object(obj_Sword);
	obj_Sword.visible = true;
}