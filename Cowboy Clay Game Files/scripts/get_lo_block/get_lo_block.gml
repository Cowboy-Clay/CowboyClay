// Checks if the instance that called this is lo blocking.
// Compares the instance's object_index to a list of objects and compares its sprite to a list of applicable sprites.
// Returns true if lo blocking and false if not.
function get_lo_block(){
	var a = noone;
	
	switch object_index {
		case global.player_object:
			a = global.player_lo_block_sprites;
			break;
		case global.moose_object:
			a = global.moose_lo_block_sprites;
			break;
	}
	
	// If no definition for that object exists
	if a == noone {
		show_debug_message("Attempted to check lo block for object not found in reference.");
		return false;
	}
	
	for (var i = 0; i < array_length(a); i++) {
		if sprite_index == a[i] return true;
	}
	return false;
}

// Sprites where the player is hi blocking
global.player_object = obj_player;
global.player_lo_block_sprites = [];

// Sprites where Moose is hi blocking
global.moose_object = obj_Moose;
global.moose_lo_block_sprites = [
								spr_moose_hiBlock,
								spr_moose_walk_hiBlock
								];