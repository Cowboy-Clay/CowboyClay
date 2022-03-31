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
	(get_instance_lo_block(obj_player) && get_instance_lo_attack(obj_Moose)) {
		// succesful block recoil
		knock_away_from(obj_player,obj_Moose.x, obj_Moose.y, 15)
		return;
	}
	
	// Check for hit box overlap
	with (obj_player_hitbox) {
		if place_meeting(x,y,obj_enemy_hitbox) {
			//clash recoil
			return;
		}
	}
	
	// Take an actual hit
	obj_player.PlayerGetHit();
}