if sprite_index == wipe_out{
	current_state = 1;
	sprite_index = GameOverScreen;
} else if sprite_index == GameOverScreen {
	image_speed = 0;
	image_index = sprite_get_number(sprite_index) - 1;
	current_state = 2;
}
