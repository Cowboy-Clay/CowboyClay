x = obj_player.x;
y = obj_player.y;
image_xscale = obj_player.image_xscale;
image_yscale = obj_player.image_yscale;
sprite_index = GetPlayerHurtBox();
image_index = obj_player_hitbox.image_index;

// If hurtbox is overlapping enemy hitbox and the enemy hitbox is not empty
if place_meeting(x,y,obj_enemy_hitbox) && obj_enemy_hitbox.sprite_index != noone {
	// If you are invuln nothing happens
	if variable_instance_exists(obj_player.id, "invulnerability") && variable_instance_get(obj_player.id, "invulnerability") == true {
		return;
	}
	
	// check for matching attacks and blocks
	if (get_instance_hi_block(obj_player) && get_instance_hi_attack(obj_Moose)) ||
	(get_instance_lo_block(obj_player) && get_instance_lo_attack(obj_Moose) && 
	((obj_player.facing == Direction.LEFT && obj_Moose.x < obj_player.x) || (obj_player.facing == Direction.RIGHT && obj_player.x < obj_Moose.x))) {
		// succesful block recoil
		if get_instance_hi_block(obj_player) instance_create_layer(x,y,layer,obj_player_block_spark_hi);
		else if get_instance_lo_block(obj_player) instance_create_layer(x,y,layer,obj_player_block_spark_lo);
		audio_play_sound(sfx_clay_block, 5, false);
		obj_player.to_block_follow(true);
		knock_away_from(obj_Moose,x,y,15);
		obj_Moose.take_hit_minor();
		//knock_away_from(obj_player,obj_Moose.x, obj_Moose.y, 15)
		return;
	}
	
	// Check for hit box overlap
	with (obj_player_hitbox) {
		if place_meeting(x,y,obj_enemy_hitbox) {
			audio_play_sound(sfx_clay_block, 5, false);
			//clash recoil
			knock_away_from(obj_player,obj_Moose.x,obj_Moose.y+400,15);
			return;
		}
	}
	
	// Take an actual hit
	if obj_player.current_state == PlayerState.BLOCK {
		obj_player.to_idle();
	}
	
	if obj_Moose.armed {
		obj_player.PlayerGetHit();
	} else {
		knock_away_from(obj_player ,obj_Moose.x, obj_Moose.y, 12);
		obj_player.to_pain();
	}
}

if place_meeting(x,y,obj_moose_projectile) {
	if obj_player.current_state == PlayerState.BLOCK {
		obj_player.to_idle();
	}
	obj_player.PlayerGetHit();
}
