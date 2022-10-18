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
	else if obj_Moose.current_state == MooseState.PANIC_WAIT {}
	
	// check for matching attacks and blocks
	else if (get_instance_hi_block(obj_Moose.id) && get_instance_hi_attack(obj_player_fighting.id)) ||
	(get_instance_lo_block(obj_Moose.id) && get_instance_lo_attack(obj_player_fighting.id)) {
		// succesful block recoil
		if get_instance_hi_attack(obj_player_fighting.id) instance_create_layer(x,y,layer,obj_moose_block_spark_hi);
		if get_instance_lo_attack(obj_player_fighting.id) instance_create_layer(x,y,layer,obj_moose_block_spark_lo);
		audio_play_sound(sfx_moose_block, 5, false);
		knock_away_from(obj_player_fighting,x,y+400,15);
		
	}else {
	
		// Check for hit box overlap
		with (obj_enemy_hitbox) {
			if place_meeting(x,y,obj_player_hitbox) {
				//clash recoil
				audio_play_sound(sfx_moose_block, 5, false);
				knock_away_from(obj_Moose, obj_player_fighting.x,obj_player_fighting.y,5);
				return;
			}
		}
	
		// Take an actual hit
		if obj_player_fighting.current_state == PlayerState.KICK_SWING && !obj_player_hitbox.wallkick_cooldown{
			obj_Moose.take_hit_minor();
			//obj_player_fighting.to_kick_follow();
			var xx = (x + obj_player_fighting.x)/2;
			var yy = (y + obj_player_fighting.y)/2;
			knock_away_from(obj_Moose, obj_player_fighting.x, obj_player_fighting.y+100, 20);
			var inst = instance_create_depth(xx,yy,obj_player_fighting.depth-100,obj_moose_hit_effect);
			inst.image_xscale = .5;
			inst.image_yscale = .5;
		} else if obj_player_fighting.current_state == PlayerState.BASIC_ATTACK_SWING{
			var xx = (x + obj_player_fighting.x)/2;
			var yy = (y + obj_player_fighting.y)/2;
			var inst = instance_create_depth(xx,yy,obj_player_fighting.depth-100,obj_moose_hit_effect);
			inst.image_xscale = 1;
			inst.image_yscale = 1;
			obj_Moose.take_hit_major();
			//hitstun(.30);
		}
	}
}

if place_meeting(x,y,obj_player_projectile) {
	if obj_player_projectile.y < y - 100 {
		// Hi projectile
		if get_instance_hi_block(obj_Moose) {
			audio_play_sound(sfx_moose_block, 5, false);
			instance_destroy(instance_nearest(x,y,obj_player_projectile));
			return;
		}
	} else {
		// Lo projectile
		if get_instance_lo_block(obj_Moose) {
			audio_play_sound(sfx_moose_block, 5, false);
			instance_destroy(instance_nearest(x,y,obj_player_projectile));
			return;
		}
	}
	instance_destroy(instance_nearest(x,y,obj_player_projectile));
	obj_Moose.take_hit_minor();
}
