global.mooseSprRef = 
[
	[global.moose_idleAnim, spr_empty, spr_empty],
	[global.moose_wanderAnim, spr_empty, spr_empty],
	[global.moose_wanderAnim_disar, spr_empty, spr_empty],
	[global.moose_slideAntiAnim, spr_moose_slideAnti_hitbox, spr_empty],
	[global.moose_slideAnim, spr_moose_slide_hitbox, spr_empty],
]

function GetMooseHitBox()
{
	var a = obj_Moose.sprite_index;
	for (i = 0; i < 5; i+=1)
	{
		if global.mooseSprRef[i][0] == a return global.mooseSprRef[i][1];
	}
	return spr_empty;
}

function GetMooseHurtBox()
{
	var a = obj_Moose.sprite_index;
	for (i = 0; i < 5; i += 1)
	{
		if global.mooseSprRef[i][0] == a
		{
			if global.mooseSprRef[i][2] == spr_empty return spr_enemy_collision;
			return global.mooseSprRef[i][2];
		}
	}
	return spr_enemy_collision;
}