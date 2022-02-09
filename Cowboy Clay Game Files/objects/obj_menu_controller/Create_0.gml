menu_timer = 120;
load_flag = false;

function begin_load()
{
	obj_menu_title.visible = false;
	obj_menu_press_to_start.visible = false;
	obj_menu_controls.visible = true;
	load_flag = true;
}

function load_game_room()
{
	room_goto_next();
}