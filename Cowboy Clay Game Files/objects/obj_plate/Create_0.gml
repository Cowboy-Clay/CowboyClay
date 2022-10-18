on_sprite = spr_mech_pressurePlate1;
off_sprite = spr_mech_pressurePlate2;

up_sound = sfx_switch_up;
down_sound = sfx_switch_down;

on = false;

valid_objects = [obj_player_fighting, obj_player_sword, obj_box, obj_Moose];

door_instance = noone;

for (i = 0; i < instance_number(obj_door); i++)
{
	if door_instance == noone
	{
		door_instance = instance_find(obj_door,i);
	}
	else if point_distance(door_x, door_y, door_instance.x,door_instance.y) > point_distance(door_x, door_y,instance_find(obj_door,i).x,instance_find(obj_door,i).y) 
	{
		door_instance = instance_find(obj_door,i);
	}
}