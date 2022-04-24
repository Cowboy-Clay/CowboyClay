if variable_global_exists("music_controller") {
	if global.music_controller != noone instance_destroy(id);
}

global.music_controller = self;
current_track = track;
sound_instance = noone;

if start_on_create {
	sound_instance = audio_play_sound(current_track, 100, true);
}

function resume() {
	audio_resume_sound(sound_instance);
}
function pause() {
	audio_pause_sound(sound_instance);
}
