// Checks if the instance that called this is hi attacking.
// Compares the instance's object_index to a list of objects and compares its sprite to a list of applicable sprites.
// Returns true if hi attacking and false if not.
function get_hi_attack(){
	var a = noone;
	
	switch object_index {
		case global.player_object:
			a = global.player_hi_attack_sprites;
			break;
		case global.moose_object:
			a = global.moose_hi_attack_sprites;
			break;
	}
	
	// If no definition for that object exists
	if a == noone {
		show_debug_message("Attempted to check hi block for object not found in reference.");
		return false;
	}
	
	for (var i = 0; i < array_length(a); i++) {
		if sprite_index == a[i] return true;
	}
	return false;
}

// Sprites where the player is hi blocking
global.player_hi_attack_sprites = [
								  global.player_animation_sword_hi_swing[0],
								  ];

// Sprites where Moose is hi blocking
global.moose_hi_attack_sprites = [

								 //stab
								 spr_moose_stab,
								 spr_moose_stab_noHelm,
								 spr_moose_stab_empty,
								 
								 //plunge
								 spr_moose_plunging,
								 spr_moose_plunging_noHelm
								 
								 ];