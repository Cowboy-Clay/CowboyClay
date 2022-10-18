global.playerSprRef = 
[
	[global.player_animation_idle, spr_empty, spr_clay_n_collision],
	[global.player_animation_idle_disarmed, spr_empty, spr_clay_n_collision],
	[global.player_animation_attack_mid_anti, spr_empty, spr_clay_n_collision],
	[global.player_animation_attack_mid_swing, spr_player_attackSwing_hitbox, spr_clay_n_collision],
	[global.player_animation_attack_mid_follow , spr_empty, spr_clay_n_collision],
	[global.player_animation_sword_hi_swing, spr_player_jumpAttack_Slash, spr_clay_n_collision],
	[global.player_animation_kick_swing, spr_player_kickHitbox,spr_clay_n_collision],
	[global.player_animation_kick_swing_disarmed, spr_player_kickHitbox,spr_clay_n_collision],
]

function GetPlayerHitBox()
{
	var target = noone;
	if instance_exists(obj_player_neutral) target = obj_player_neutral;
	else if instance_exists(obj_player_sitting) target = obj_player_sitting;
	else if instance_exists(obj_player_fighting) target = obj_player_fighting;
	else return;

	var a = target.sprite_index;
	for (i = 0; i < array_length(global.playerSprRef); i+=1)
	{
		if global.playerSprRef[i][0][0] == a return global.playerSprRef[i][1];
	}
	return spr_empty;
}

function GetPlayerHurtBox()
{
	var target = noone;
	if instance_exists(obj_player_neutral) target = obj_player_neutral;
	else if instance_exists(obj_player_sitting) target = obj_player_sitting;
	else if instance_exists(obj_player_fighting) target = obj_player_fighting;
	else return;
	
	var a = target.sprite_index;
	for (i = 0; i < array_length(global.playerSprRef); i += 1)
	{
		if global.playerSprRef[i][0][0] == a return global.playerSprRef[i][2];
	}
	return spr_clay_n_collision;
}