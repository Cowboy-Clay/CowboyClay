state = 0;
flag = false;

function ToState1()
{
	obj_Moose.GoToHit();
	instance_activate_object(obj_player_sword);
	obj_Sword.visible = true;
	state = 1;
}