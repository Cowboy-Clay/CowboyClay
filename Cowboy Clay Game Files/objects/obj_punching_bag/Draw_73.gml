/// @description Insert description here
// You can write your code in this editor

var left_x = x - sprite_width/2;
var right_x = x + sprite_width/2;
var y_0 = y - sprite_height;
var y_1 = y_0 + sprite_height/3;
var y_2 = y_1 + sprite_height/3;
var y_3 = y;

draw_set_color(c_red);
if top_trigger {
	draw_rectangle(left_x, y_0, right_x, y_1, false);
	top_trigger = false;
}
if mid_trigger {
	draw_rectangle(left_x, y_1, right_x, y_2, false);
	mid_trigger = false;
}
if bot_trigger {
	draw_rectangle(left_x, y_2, right_x, y_3, false);
	bot_trigger = false;
}