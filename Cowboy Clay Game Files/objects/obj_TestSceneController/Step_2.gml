/// @description Insert description here
// You can write your code in this editor

if state == 0
{
	if obj_Player.vspeed > 1 && obj_Player.y < obj_Enemy.y && obj_Player.place_meeting(obj_Player.x, obj_Player.y, obj_Enemy)
	{
		obj_Enemy.vspeed = -100;
		obj_Enemy.hspeed = 100;
		if obj_Player.x > obj_Enemy.x 
			obj_Enemy.hspeed *= -1;
		state = 1;
	}
}