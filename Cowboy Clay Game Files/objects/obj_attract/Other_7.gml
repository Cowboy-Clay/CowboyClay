if array_length(sequence) == 0 return;

if sprite_index == sequence[array_length(sequence)-1] {
	instance_create_layer(x,y,layer,obj_menu_title);
	instance_destroy(id);
	return;
}

for (var i = 0; i < array_length(sequence)-1; i++) {
	if sprite_index == sequence[i] {
		sprite_index = sequence[i+1];
		image_index = 0;
		break;
	}
}
