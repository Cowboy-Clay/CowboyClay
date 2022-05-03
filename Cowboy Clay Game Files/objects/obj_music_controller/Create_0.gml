currently_playing = noone;


audio_stop_all();if start_on_create {
	currently_playing = audio_play_sound(track,0,true);
}

function switch_track(next_track) {
	audio_sound_gain(currently_playing, 0, 500);
	currently_playing = audio_play_sound(next_track,0,true);
	audio_sound_gain(currently_playing,0,0);
	audio_sound_gain(currently_playing,1,1000);
}
