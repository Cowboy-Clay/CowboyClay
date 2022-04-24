if flag {
	game_set_speed(60, gamespeed_fps);
	if variable_global_exists("music_controller") && global.music_controller != noone global.music_controller.resume();
	instance_destroy(id);
} else {
	flag = true;
}
