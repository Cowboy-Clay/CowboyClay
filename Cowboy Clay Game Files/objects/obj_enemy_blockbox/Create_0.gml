/// @description Insert description here
// You can write your code in this editor

function EnemyBlocking()
{
	if sprite_index == spr_empty return false;
	if place_meeting(x,y,obj_player_hitbox) return true;
	return false;
}