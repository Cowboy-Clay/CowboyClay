/// @description Insert description here
// You can write your code in this editor
x = obj_player.x;
y = obj_player.y;
image_xscale = obj_player.image_xscale;
image_yscale = obj_player.image_yscale;

if obj_player.current_state != PlayerState.BASIC_ATTACK_SWING
{
	HidePlayerAttack();
}