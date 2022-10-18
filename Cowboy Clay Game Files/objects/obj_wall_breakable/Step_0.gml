if place_meeting(x,y,obj_player_hitbox) && (obj_player_fighting.current_state == PlayerState.BASIC_ATTACK_SWING){
	var a = instance_create_depth(x,y-100,depth, obj_wall_broken);
	a.half = 1;
	knock_away_from(a, obj_player_hitbox.x, obj_player_hitbox.y,10);
	
	var b = instance_create_depth(x,y+100,depth, obj_wall_broken);
	b.half = 2;
	knock_away_from(b, obj_player_hitbox.x, obj_player_hitbox.y, 10);
	
	audio_play_sound(sfx_wall_smash_1,-4,false);
	
	instance_destroy(id);
}
