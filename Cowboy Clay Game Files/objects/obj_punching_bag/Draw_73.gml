/// @description Insert description here
// You can write your code in this editor

var left_x = x - sprite_width/2;
var right_x = x + sprite_width/2;
var y_0 = y - sprite_height;	// First y is the top of the sprite
var y_1 = y_0 + sprite_height * top_percent;	// Second y is the top + the top percentage of the height
var y_3 = y;	// The last y is the bottom of the sprite
var y_2 = y_3 - sprite_height * bot_percent;	// The second to last y is the bottom - the bot percentage

if top_trigger {
	draw_set_color(c_red);
	top_trigger = false;
} else {
	draw_set_color(c_green);
}
draw_rectangle(left_x, y_0, right_x, y_1, false);

if mid_trigger {
	draw_set_color(c_red);
	mid_trigger = false;
} else {
	draw_set_color(c_yellow);
}
draw_rectangle(left_x, y_1, right_x, y_2, false);

if bot_trigger {
	draw_set_color(c_red);
	bot_trigger = false;
} else {
	draw_set_color(c_green);
}
draw_rectangle(left_x, y_2, right_x, y_3, false);