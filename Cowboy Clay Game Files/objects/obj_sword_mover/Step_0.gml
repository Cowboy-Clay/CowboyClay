if place_meeting(x,y,obj_player_fighting)
{
	active = true;
}
if active
{
	timer --;
	if timer <= 0
	{
	obj_player_sword.teleport_to(xPos,yPos);
	instance_destroy(id,false);
	}
}