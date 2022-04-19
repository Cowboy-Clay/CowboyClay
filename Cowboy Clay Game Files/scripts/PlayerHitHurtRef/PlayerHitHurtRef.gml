global.playerSprRef = 
[
	[global.player_animation_idle, spr_empty, spr_player_collision],
	[global.player_animation_idle_disarmed, spr_empty, spr_player_collision],
	[global.player_animation_sword_anti, spr_empty, spr_player_collision],
	[global.player_animation_sword_swing, spr_player_attackSwing_hitbox, spr_player_collision],
	[global.player_animation_sword_follow , spr_empty, spr_player_collision],
]

function GetPlayerHitBox()
{
	var a = obj_player.sprite_index;
	for (i = 0; i < array_length(global.playerSprRef); i+=1)
	{
		if global.playerSprRef[i][0] == a return global.playerSprRef[i][1];
	}
	return spr_empty;
}

function GetPlayerHurtBox()
{
	var a = obj_player.sprite_index;
	for (i = 0; i < array_length(global.playerSprRef); i += 1)
	{
		if global.playerSprRef[i][0] == a return global.playerSprRef[i][2];
	}
	return spr_player_collision;
}