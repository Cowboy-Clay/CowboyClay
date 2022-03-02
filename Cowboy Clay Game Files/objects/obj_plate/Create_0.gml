on_sprite = spr_mech_pressurePlate1;
off_sprite = spr_mech_pressurePlate2;

up_sound = sfx_switch_up;
down_sound = sfx_switch_down;

on = false;

valid_objects = [obj_player, obj_player_sword, obj_box];

door_instance = noone;

for (i = 0; i < obj_door.instance_count; i++)
{
	if door_instance == noone
	{
		door_instance = obj_door.instance_id[i];
	}
	else if distance_to_object(door_instance) > distance_to_object(obj_door.instance_id[i])
	{
		door_instance = obj_door.instance_id[i];
	}
}