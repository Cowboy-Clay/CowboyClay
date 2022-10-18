/// @description Insert description here
// You can write your code in this editor
if !global.paused{
	target = noone;
	if instance_exists(obj_player_neutral) target = obj_player_neutral;
	else if instance_exists(obj_player_sitting) target = obj_player_sitting;
	else if instance_exists(obj_player_fighting) target = obj_player_fighting;
	else return;
	
	x = target.x;
	y = target.y;
	image_xscale = target.image_xscale;
	image_yscale = target.image_yscale;

	if target.current_state != PlayerState.BASIC_ATTACK_SWING
	{
		HidePlayerAttack();
	}
}
