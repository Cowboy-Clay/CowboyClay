global.mooseSprRef = 
[
	[global.moose_idleAnim, spr_moose_idle_hitbox, spr_moose_idle_hurtbox],
	[global.moose_idleAnim_disar, spr_moose_idle_disarmed_hitbox, spr_moose_idle_disarmed_hurtbox],
	[global.moose_wanderAnim, spr_moose_walk_hitbox, spr_moose_walk_hurtbox],
	[global.moose_wanderAnim_disar, spr_moose_walk_hitbox, spr_moose_walk_hurtbox],
	[global.moose_slideAntiAnim, spr_moose_slideAnti_hitbox, spr_moose_slideAnti_hurtbox],
	[global.moose_slideAnim, spr_moose_slide_hitbox, spr_moose_slide_hurtbox],
	[global.moose_chargeAntiAnim, spr_moose_chargeAnti_hitbox, spr_moose_chargeAnti_hurtbox],
//	[global.moose_chargeAnim, spr_moose_charge_hitbox, spr_moose_charge_hurtbox],
//	[global.moose_blockLoAnim, spr_empty, spr_moose_idle_hurtbox, spr_moose_block_blockbox]
]

function GetMooseHitBox()
{
	var a = obj_Moose.sprite_index;
	for (i = 0; i < array_length(global.mooseSprRef); i+=1)
	{
		if global.mooseSprRef[i][0] == a return global.mooseSprRef[i][1];
	}
	return spr_empty;
}

function GetMooseHurtBox()
{
	var a = obj_Moose.sprite_index;
	for (i = 0; i < array_length(global.mooseSprRef); i += 1)
	{
		if global.mooseSprRef[i][0] == a
		{
			if global.mooseSprRef[i][2] == spr_empty return spr_enemy_collision;
			return global.mooseSprRef[i][2];
		}
	}
	return spr_enemy_collision;
}

function GetMooseBlockBox()
{
	var a = obj_Moose.sprite_index;
	for (i = 0; i < array_length(global.mooseSprRef); i += 1)
	{
		if global.mooseSprRef[i][0] == a
		{
			if array_length(global.mooseSprRef[i]) < 4 return spr_empty;
			return global.mooseSprRef[i][3];
		}
	}
	return spr_empty;
}