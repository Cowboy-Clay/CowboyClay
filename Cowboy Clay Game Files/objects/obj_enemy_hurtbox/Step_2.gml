x = obj_Moose.x;
y = obj_Moose.y;
image_xscale = obj_Moose.image_xscale;
image_yscale = obj_Moose.image_yscale;
sprite_index = GetMooseHurtBox();
image_index = obj_Moose.image_index;

if place_meeting(x,y,obj_player_hitbox) && obj_player_hitbox.sprite_index != spr_empty
{
	// If you are invuln nothing happens
	if variable_instance_exists(obj_Moose.id, "invuln") && variable_instance_get(obj_Moose.id, "invuln") == true {
		
	}
	
	// check for matching attacks and blocks
	else if (get_instance_hi_block(obj_Moose.id) && get_instance_hi_attack(obj_player.id)) ||
	(get_instance_lo_block(obj_Moose.id) && get_instance_lo_attack(obj_player.id)) {
		// succesful block recoil
		audio_play_sound(sfx_moose_block, 5, false);
		knock_away_from(obj_player,x,y+400,15);
		
	}else {
	
	// Check for hit box overlap
	with (obj_enemy_hitbox) {
		if place_meeting(x,y,obj_player_hitbox) {
			//clash recoil
			audio_play_sound(sfx_moose_block, 5, false);
			knock_away_from(obj_Moose, obj_player.x,obj_player.y,5);
			return;
		}
	}
	
	// Take an actual hit
	obj_Moose.MooseGetHit();
	hitstun(.3);
	}
}

if place_meeting(x,y,obj_player_projectile) {
	if obj_player_projectile.y < y - 100 {
		// Hi projectile
		if get_instance_hi_block(obj_Moose) {
	instance_destroy(instance_nearest(x,y,obj_player_projectile));
			return;
		}
	} else {
		// Lo projectile
		if get_instance_lo_block(obj_Moose) {
			instance_destroy(instance_nearest(x,y,obj_player_projectile));
			return;
		}
	}
	instance_destroy(instance_nearest(x,y,obj_player_projectile));
	obj_Moose.to_stun();
}
