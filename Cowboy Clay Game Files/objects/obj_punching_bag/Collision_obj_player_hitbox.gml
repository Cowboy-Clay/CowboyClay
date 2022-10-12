/// @description Insert description here
// You can write your code in this editor

var left_x = x - sprite_width/2;
var right_x = x + sprite_width/2;
var y_0 = y - sprite_height;
var y_1 = y_0 + sprite_height/3;
var y_2 = y_1 + sprite_height/3;
var y_3 = y;

show_debug_message("Punching bag hit");
if collision_rectangle(left_x, y_1, right_x, y_2, obj_player_hitbox, true, true) and obj_player_hitbox.sprite_index != noone {
	mid_trigger = true;
} else {
	if collision_rectangle(left_x, y_0, right_x, y_1, obj_player_hitbox, true, true) and obj_player_hitbox.sprite_index != noone {
		top_trigger = true;
	}
	if collision_rectangle(left_x, y_2, right_x, y_3, obj_player_hitbox, true, true) and obj_player_hitbox.sprite_index != noone {
		bot_trigger = true;
	}
}