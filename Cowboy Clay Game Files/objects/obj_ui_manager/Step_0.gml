/// @description Insert description here
// You can write your code in this editor

#region Health Bars
// The player's health bar should be drawn if the player exists and their hp is below max or they are disarmed
draw_player_health_bar = instance_exists(obj_player) && (obj_player.hp < obj_player.max_hp || !obj_player.armed);
// If an enemy exists we should always draw both bars
if tag_exists("enemy") {
	draw_player_health_bar = true;
	draw_enemy_health_bar = true;
}
#endregion

if draw_player_health_bar {
	frame_bottom_padding = 60;
}
else {
	frame_bottom_padding = 0;
}