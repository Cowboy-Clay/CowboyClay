image_based_sounds = [
	[obj_player,[ 
		[global.player_walkAnim, 0, sfx_clay_walk_disarmed],
		[global.player_walkAnim, 1, sfx_clay_walk_disarmed],
		[global.player_walkAnim_disarmed, 1, sfx_clay_walk_disarmed]
	]]
];

instances_to_check = [
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
			for (var k = 0; k < array_length(instances_to_check); k++) {
				if current_instance == instances_to_check[k][0] {
					instance_index = k;
					break;
				}
			}
			// If it was not in there then we add an entry
			if instance_index == -1 {
				instances_to_check[array_length(instances_to_check)] = [current_instance, -1, -1];
				instance_index = array_length(instances_to_check) -1;
			}
			
			// Check if the animation has changed since last frame
			if current_instance.sprite_index != instances_to_check[instance_index][1] || current_instance.image_index != instances_to_check[instance_index][2] {
				instances_to_check[instance_index] = [current_instance, current_instance.sprite_index, current_instance.image_index];
				for (var l = 0; l < array_length(image_based_sounds[i][1]); l++) {
					if current_instance.sprite_index == image_based_sounds[i][1][l][0] && current_instance.image_index == image_based_sounds[i][1][l][1] {
						audio_play_sound(image_based_sounds[i][1][l][2], 100, false);
					}
				}
			}
		}
	}
}