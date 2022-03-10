if menu_state == 0 && keyboard_check_pressed(vk_enter) 
{
	menu_state = 1;
	instance_destroy(obj_menu_title);
}
else if menu_state == 1
{
	if keyboard_check_pressed(vk_down) next();
	if keyboard_check_pressed(vk_up) previous();
	if keyboard_check_pressed(vk_enter)
	{
		menu_state = 2;
		obj_menu_controls.visible = true;
	}
}
else if menu_state == 2
{
	timer--;
	if timer <= 0 || keyboard_check_pressed(vk_enter) load();
}