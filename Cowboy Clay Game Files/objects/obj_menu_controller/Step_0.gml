if menu_state == 0 && button_check_pressed(buttons.jump)
{
	menu_state = 1;
	instance_destroy(obj_menu_title);
}
else if menu_state == 1
{
	if button_check_pressed(buttons.down) next();
	if button_check_pressed(buttons.up) previous();
	if button_check_pressed(buttons.jump)
	{
		menu_state = 2;
		obj_menu_controls.visible = true;
	}
}
else if menu_state == 2
{
	timer--;
	if timer <= 0 || button_check_pressed(buttons.jump) load();
}