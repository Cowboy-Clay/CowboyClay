if array_length(sequence) == 0 return;

if sprite_index == sequence[array_length(sequence)-1] {
	room_goto(FinalLevelDesign);
	return;
}

for (var i = 0; i < array_length(sequence)-1; i++) {
	if sprite_index == sequence[i] {
		sprite_index = sequence[i+1];
		image_index = 0;
		break;
	}
}
