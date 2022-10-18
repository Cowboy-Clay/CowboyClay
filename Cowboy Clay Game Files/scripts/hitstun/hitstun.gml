function hitstun(seconds, pause_music){
	insure_visibility();
	
	var microseconds = seconds * power(10,6);
	instance_create_depth(0,0,0,obj_hit_stun_controller);
	
	if pause_music && variable_global_exists("music_controller") && global.music_controller != noone global.music_controller.pause();
	game_set_speed(microseconds, gamespeed_microseconds);
}

function insure_visibility() {
	if instance_exists(obj_player_fighting) {
		obj_player_fighting.visible = true;
	}
	
	if instance_exists(obj_Moose) {
		obj_Moose.visible = true;
	}
}
