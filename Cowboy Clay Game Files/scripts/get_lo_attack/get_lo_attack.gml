// Checks if the instance that called this is lo attacking.
// Compares the instance's object_index to a list of objects and compares its sprite to a list of applicable sprites.
// Returns true if lo attacking and false if not.
function get_lo_attack(){
	var a = noone;
	
	switch object_index {
		case global.player_object:
			a = global.player_lo_attack_sprites;
			break;
		case global.moose_object:
			a = global.moose_lo_attack_sprites;
			break;
	}
	
	// If no definition for that object exists
	if a == noone {
		show_debug_message("Attempted to check lo attack for object not found in reference.");
		return false;
	}
	
	for (var i = 0; i < array_length(a); i++) {
		if sprite_index == a[i] return true;
	}
	return false;
}

// Sprites where the player is lo attacking
global.player_lo_attack_sprites = [];

// Sprites where Moose is lo attacking
global.moose_lo_attack_sprites = [];