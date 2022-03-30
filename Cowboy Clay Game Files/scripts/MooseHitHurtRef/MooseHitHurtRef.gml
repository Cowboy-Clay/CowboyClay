global.mooseSprRef = 
[
	[global.moose_animation_idle, spr_moose_idle_hitbox, spr_moose_idle_hurtbox],
	[global.moose_animation_idle_helmless, noone, noone],
	[global.moose_animation_idle_disarmed, spr_moose_idle_disarmed_hitbox, spr_moose_idle_disarmed_hurtbox],
	[global.moose_animation_wander, spr_moose_walk_hitbox, spr_moose_walk_hurtbox],
	[global.moose_animation_wander_disarmed, spr_moose_walk_hitbox, spr_moose_walk_hurtbox],
	[global.moose_animation_slideAnti, spr_moose_slideAnti_hitbox, spr_moose_slideAnti_hurtbox],
	[global.moose_animation_slide, spr_moose_slide_hitbox, spr_moose_slide_hurtbox],
	[global.moose_animation_chargeAnti, spr_moose_chargeAnti_hurtbox],
	[global.moose_animation_charge, spr_moose_charge_hitbox, spr_moose_charge_hurtbox],
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