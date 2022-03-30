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
		return;
	}
	
	show_debug_message("M HI: " + string(get_instance_hi_block(obj_Moose.id)));
	show_debug_message("P HI: " + string(get_instance_hi_attack(obj_player.id)));
	show_debug_message("M LO: " + string(get_instance_lo_block(obj_Moose.id)));
	show_debug_message("P LO: " + string(get_instance_lo_attack(obj_player.id)));
	
	// check for matching attacks and blocks
	if (get_instance_hi_block(obj_Moose.id) && get_instance_hi_attack(obj_player.id)) ||
	(get_instance_lo_block(obj_Moose.id) && get_instance_lo_attack(obj_player.id)) {
		// succesful block recoil
		return;
	}
	
	// Check for hit box overlap
	with (obj_enemy_hitbox) {
		if place_meeting(x,y,obj_player_hitbox) {
			//clash recoil
			return;
		}
	}
	
	// Take an actual hit
	obj_Moose.MooseGetHit();
}