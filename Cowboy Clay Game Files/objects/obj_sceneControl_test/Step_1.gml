if state == 0
{
	instance_deactivate_object(obj_player_sword);
}
if state == 1 && !flag
{
	instance_activate_object(obj_player_sword);
	obj_Sword.visible = true;
}