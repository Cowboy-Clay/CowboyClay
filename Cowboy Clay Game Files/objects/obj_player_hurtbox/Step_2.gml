target = noone;
if instance_exists(obj_player_neutral) target = obj_player_neutral;
else if instance_exists(obj_player_sitting) target = obj_player_sitting;
else if instance_exists(obj_player_fighting) target = obj_player_fighting;
else return;

x = target.x;
y = target.y;
image_xscale = target.image_xscale;
image_yscale = target.image_yscale;
sprite_index = GetPlayerHurtBox();
image_index = obj_player_hitbox.image_index;

// If hurtbox is overlapping enemy hitbox and the enemy hitbox is not empty
if place_meeting(x,y,obj_enemy_hitbox) && obj_enemy_hitbox.sprite_index != noone {
	// If you are invuln nothing happens
	if variable_instance_exists(target.id, "invulnerability") && variable_instance_get(target.id, "invulnerability") == true {
		return;
	}
	
	// check for matching attacks and blocks
	if get_instance_lo_block(target) && (get_instance_hi_attack(obj_Moose) || (get_instance_lo_attack(obj_Moose) && ((target.facing == Direction.LEFT && target.x > obj_Moose.x)||(target.facing == Direction.RIGHT && target.x < obj_Moose.x))))
	 {
		// succesful block recoil
		if get_instance_hi_block(target) instance_create_layer(x,y,layer,obj_player_block_spark_hi);
		else if get_instance_lo_block(target) instance_create_layer(x,y,layer,obj_player_block_spark_lo);
		audio_play_sound(sfx_clay_block, 5, false);
		target.to_block_follow(true);
		knock_away_from(obj_Moose,x,y,15);
		obj_Moose.take_hit_minor();
		//knock_away_from(target,obj_Moose.x, obj_Moose.y, 15)
		return;
	}
	
	// Check for hit box overlap
	with (obj_player_hitbox) {
		if place_meeting(x,y,obj_enemy_hitbox) {
			audio_play_sound(sfx_clay_block, 5, false);
			//clash recoil
			knock_away_from(target,obj_Moose.x,obj_Moose.y+400,15);
			return;
		}
	}
	
	// Take an actual hit
	if target.current_state == PlayerState.BLOCK {
		target.to_idle();
	}
	
	if obj_Moose.armed {
		target.PlayerGetHit();
	} else {
		knock_away_from(target ,obj_Moose.x, obj_Moose.y, 12);
		target.to_pain();
	}
}

if place_meeting(x,y,obj_moose_projectile) {
	if target.current_state == PlayerState.BLOCK {
		target.to_idle();
	}
	target.PlayerGetHit();
}
