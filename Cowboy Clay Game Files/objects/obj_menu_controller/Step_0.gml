if load_flag
{
	menu_timer --;
	if menu_timer <= 0 load_game_room();
}

if keyboard_check_pressed(ord("Z")) begin_load();