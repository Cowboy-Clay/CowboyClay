audio_falloff_set_model(audio_falloff_exponent_distance_clamped);

#region Image based
image_based_sounds = [
	[obj_player,[ 
		[global.player_walkAnim, 0, sfx_clay_walk_disarmed],
		[global.player_walkAnim, 1, sfx_clay_walk_disarmed],
		[global.player_walkAnim_disarmed, 1, sfx_clay_walk_disarmed],
	]],
];

image_based_instances = [
	// [instance, sprite, image]
];

function check_image_based_sounds() {
	for (var i = 0; i < array_length(image_based_sounds); i ++) {
		var current_object = image_based_sounds[i][0];
		var number_of_instances = instance_number(current_object);
		
		for (var j = 0; j < number_of_instances; j++) {
			var current_instance = instance_find(current_object,j);
			
			// Find instance position in instance array if it is there
			var instance_index = -1;
			for (var k = 0; k < array_length(image_based_instances); k++) {
				if current_instance == image_based_instances[k][0] {
					instance_index = k;
					break;
				}
			}
			// If it was not in there then we add an entry
			if instance_index == -1 {
				image_based_instances[array_length(image_based_instances)] = [current_instance, -1, -1];
				instance_index = array_length(image_based_instances) -1;
			}
			
			// Check if the animation has changed since last frame
			if current_instance.sprite_index != image_based_instances[instance_index][1] || current_instance.image_index != image_based_instances[instance_index][2] {
				image_based_instances[instance_index] = [current_instance, current_instance.sprite_index, current_instance.image_index];
				for (var l = 0; l < array_length(image_based_sounds[i][1]); l++) {
					if current_instance.sprite_index == image_based_sounds[i][1][l][0] && current_instance.image_index == image_based_sounds[i][1][l][1] {
						audio_play_sound(image_based_sounds[i][1][l][2], 100, false);
					}
				}
			}
		}
	}
}
#endregion

#region Collision based
collision_based_sounds = [
	[obj_player_hitbox,[ 
		[obj_tile_coll, sfx_clay_walk_disarmed],
	]],
];

collision_based_instances = [
	// [instance, other, last]
];

function check_collision_based_sounds() {
	for (var i = 0; i < array_length(collision_based_sounds); i++) {
		var current_object = collision_based_sounds[i][0];
		for (var j = 0; j < array_length(collision_based_sounds[i][1]); j++) {
			var current_other = collision_based_sounds[i][1][j][0];
			var current_sfx = collision_based_sounds[i][1][j][1];
			for(var k = 0; k < instance_number(current_object); k++) {
				var current_instance = instance_find(current_object, k);
				
				var colliding = false;
				with(current_instance) {
					colliding = place_meeting(x,y,current_other);
				}
				
				var index = -1;
				for (var l = 0; l < array_length(collision_based_instances); k++) {
					if (collision_based_instances[k][0].id == current_instance.id && collision_based_instances[k][1].object_index == current_other.object_index) {
						index = k;
						break;
					}
				}
				// If it wasn't found, then add it
				if index == -1 {
					index = array_length(collision_based_instances);
					collision_based_instances[array_length(collision_based_instances)] = [current_instance, current_other, colliding];
				}
				
				if collision_based_instances[index][2] == false && colliding == true {
					collision_based_instances[index][2] = true;
					audio_play_sound_at(current_sfx, current_instance.x, current_instance.y, 0, 500, 2000, 1.25, false, 100);
				}
				collision_based_instances[index][2] = colliding;
			}
		}
	}
}
#endregion