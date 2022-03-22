options = [asset_get_index("ShopScene")];

menu_state = 0;

timer = 420;

current_option = 0;

function next()
{
	current_option ++;
	if current_option >= array_length(options) current_option = 0;
}

function previous()
{
	current_option --;
	if current_option < 0 current_option = array_length(options) - 1;
}

function load()
{
	room_goto(options[current_option]);
}