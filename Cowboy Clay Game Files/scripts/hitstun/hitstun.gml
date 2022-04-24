function hitstun(seconds){
	var microseconds = seconds * power(10,6);
	instance_create_depth(0,0,0,obj_hit_stun_controller);
	global.music_controller.pause();
	game_set_speed(microseconds, gamespeed_microseconds);
}