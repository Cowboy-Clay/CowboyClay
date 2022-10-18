/// @description Insert description here
// You can write your code in this editor

var arr = animation_player_cels(sprite_get_name(sprite_index));

if arr = noone {
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0,c_white, 1);
	return;
}

if typeof(arr) != "array" return;
for (var i = 0; i < array_length(arr); i++) {
	if typeof(arr[i]) == "number" {
		draw_sprite_ext(arr[i], image_index, x,y,image_xscale,image_yscale,0,c_white,1);
	} else if typeof(arr[i]) == "array" {
		var v = true;
		var s = arr[i][0]
		if string_char_at(s, 0) == "!"{
			v = false;
			s = string_copy(s,2, string_length(s) - 1);
		}
		if variable_instance_exists(id, s) {
			if variable_instance_get(id, s) == v {
				draw_sprite_ext(arr[i][1], image_index, x,y,image_xscale,image_yscale,0,c_white,1);
			}
		}
	}
}