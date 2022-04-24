if flag {
	game_set_speed(60, gamespeed_fps);
	global.music_controller.resume();
	instance_destroy(id);
} else {
	flag = true;
}
