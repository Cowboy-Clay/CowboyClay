// Checks if the instance that called this is hi blocking.
// Compares the instance's object_index to a list of objects and compares its sprite to a list of applicable sprites.
// Returns true if hi blocking and false if not.
function get_hi_block(){
	var a = noone;
	
	switch object_index {
		case global.player_object:
			a = global.player_hi_block_sprites;
			break;
		// Moose has a specific override if he has his helmet
		case global.moose_object:
			if armor > 0 return true;
			a = global.moose_hi_block_sprites;
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
global.player_object = obj_player;
global.player_hi_block_sprites = [
								 spr_player_blockHi,
								 spr_player_walk_hiBlock,
								 spr_player_blockHiStun
								 ];

// Sprites where Moose is hi blocking
global.moose_object = obj_Moose;
global.moose_hi_block_sprites = [
								spr_moose_hiBlock,
								spr_moose_walk_hiBlock
								];