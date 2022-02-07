for (i = 0; i < array_length(valid_objects); i ++)
{
	if place_meeting(x,y,valid_objects[i])
	{
		on = true;
		break;
	}
	on = false;
}

if on sprite_index = on_sprite;
else sprite_index = off_sprite;