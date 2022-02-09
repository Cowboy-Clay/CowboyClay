global.playerSprRef = 
[
	[global.player_idleAnim, spr_empty, spr_player_collision],
	[global.player_idleAnim_disarmed, spr_empty, spr_player_collision],
	[global.player_attackAntiAnim, spr_empty, spr_player_collision],
	[global.player_attackSwingAnim, spr_player_attackSwing_hitbox, spr_player_collision],
	[global.player_attackFollowAnim, spr_empty, spr_player_collision],
	[global.player_jumpAnim, spr_empty, spr_player_collision],
	[global.player_fallAnim, spr_empty, spr_player_collision],
	[global.player_jumpAntiAnim, spr_empty, spr_player_collision],
	[global.player_walkAnim, spr_empty, spr_player_collision],
	[global.player_walkAnim_disarmed, spr_empty, spr_player_collision],
	[global.player_kickAntiAnim, spr_empty, spr_player_collision],
	[global.player_kickSwingAnim, spr_empty, spr_player_collision],
	[global.player_kickFollowAnim, spr_empty, spr_player_collision]
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