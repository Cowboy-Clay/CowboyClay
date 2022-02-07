global.music_controller = self;

audio_group_load(sfx);

current_track = track;

if start_on_create audio_play_sound(current_track, 100, true);