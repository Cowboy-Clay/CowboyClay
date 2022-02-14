last_on = on;

for (i = 0; i < array_length(valid_objects); i ++)
{
	if place_meeting(x,y,valid_objects[i])
	{
		on = true;
		break;
	}
	on = false;
}

if last_on && !on
{
	if audio_is_playing(up_sound) audio_stop_sound(up_sound);
	if audio_is_playing(down_sound) audio_stop_sound(down_sound);
	audio_play_sound(up_sound,10,false);
}
else if !last_on && on
{
	if audio_is_playing(up_sound) audio_stop_sound(up_sound);
	if audio_is_playing(down_sound) audio_stop_sound(down_sound);
	audio_play_sound(down_sound,10,false);
}

if on
{
	sprite_index = on_sprite;
	door_instance.open_door();
}
else
{
	sprite_index = off_sprite;
	door_instance.close_door();
}