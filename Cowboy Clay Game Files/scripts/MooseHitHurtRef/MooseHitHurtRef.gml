global.mooseSprRef = 
[
//idle
	[global.moose_animation_idle, noone, spr_moose_idle_hurtbox],
	[global.moose_animation_idle_helmless, noone, spr_moose_idle_hurtbox],
	[global.moose_animation_idle_disarmed, noone, spr_moose_idle_disarmed_hurtbox],
//wander
	[global.moose_animation_wander, noone, spr_moose_walk_hurtbox],
	[global.moose_animation_wander_helmless, noone, spr_moose_walk_hurtbox],
	[global.moose_animation_wander_disarmed, noone, spr_moose_walk_hurtbox],
	
//slideAnti
	[global.moose_animation_slideAnti, noone, spr_moose_slideAnti_hurtbox],
	[global.moose_animation_slideAnti_helmless, noone, spr_moose_slideAnti_hurtbox],
	[global.moose_animation_slideAnti_disarmed, noone, spr_moose_slideAnti_hurtbox],

//slide
	[global.moose_animation_slide, spr_moose_slide_hitbox, spr_moose_slide_hurtbox],
	[global.moose_animation_slide_helmless, spr_moose_slide_hitbox, spr_moose_slide_hurtbox],
	[global.moose_animation_slide_disarmed, noone, spr_moose_slide_hurtbox],
	

//chargeAnti
	[global.moose_animation_chargeAnti, noone, spr_moose_chargeAnti_hurtbox],
	[global.moose_animation_chargeAnti_helmless, noone, spr_moose_chargeAnti_hurtbox],
	[global.moose_animation_chargeAnti_disarmed, noone, spr_moose_chargeAnti_hurtbox],
	
//charge
	[global.moose_animation_charge, spr_moose_charge_hitbox, spr_moose_charge_hurtbox],
	[global.moose_animation_charge_helmless, spr_moose_charge_hitbox, spr_moose_charge_hurtbox],
	[global.moose_animation_charge_disarmed, spr_moose_charge_hitbox, spr_moose_charge_hurtbox],

//idle - blockLo
	[global.moose_animation_idle_blockLo, noone, spr_moose_idle_hurtbox],
	[global.moose_animation_idle_blockLo, noone, spr_moose_idle_hurtbox],
	
//wander - blockLo
	[global.moose_animation_walk_blockLo = noone, spr_moose_walk_hurtbox],
	[global.moose_animation_walk_blockLo_helmless = noone, spr_moose_walk_hurtbox],

//idle - blockHi
	[global.moose_animation_idle_blockHi = noone, spr_moose_idle_hurtbox],

//wander - blockHi
	[global.moose_animation_walk_blockHi = noone, spr_moose_idle_hurtbox],
	
//stabAnti
	[global.moose_animation_stabAnti = noone, spr_moose_stabAnti_hurtbox],
	[global.moose_animation_stabAnti_helmless = noone, spr_moose_stabAnti_hurtbox],
	[global.moose_animation_stabAnti_disarmed = noone, spr_moose_stabAnti_hurtbox],
	
//stab
	[global.moose_animation_stab = spr_moose_stab_hitbox, spr_moose_stab_hurtbox],
	[global.moose_animation_stab_helmless = spr_moose_stab_hitbox, spr_moose_stab_hurtbox],
	[global.moose_animation_stab_disarmed = spr_moose_stab_hitbox, spr_moose_stab_hurtbox],

//jumpAnti
	[global.moose_animation_jumpAnti = noone, spr_moose_jumpAnti_hurtbox],
	[global.moose_animation_jumpAnti_helmless = noone, spr_moose_jumpAnti_hurtbox],
	[global.moose_animation_jumpAnti_disarmed = noone, spr_moose_jumpAnti_hurtbox],
	
//jumping
	[global.moose_animation_jumping = spr_moose_jumping_hitbox, spr_moose_jumping_hurtbox],
	[global.moose_animation_jumping_helmless = spr_moose_jumping_hitbox, spr_moose_jumping_hurtbox],
	[global.moose_animation_jumping_disarmed = spr_moose_jumping, spr_moose_jumping_hurtbox],
	
//plunging
	[global.moose_animation_plunging = spr_moose_plunging_hitbox, spr_moose_plunging_hurtbox],
	[global.moose_animation_plunging_helmless = spr_moose_plunging_hitbox, spr_moose_plunging_hurtbox],

//plunge bumping
	[global.moose_animation_plungeBumping = noone, spr_moose_plungeStuck_hurtbox],
	[global.moose_animation_plungeBumping_helmless = noone, spr_moose_plungeStuck_hurtbox],
	
//plunge Stuck
	[global.moose_animation_plungeBumping = noone, spr_moose_plungeStuck_hurtbox],
	[global.moose_animation_plungeBumping_helmless = noone, spr_moose_plungeStuck_hurtbox],

//spinning
	[global.moose_animation_spinning = spr_moose_spinning_hitbox, spr_moose_spinning_hurtbox],
	[global.moose_animation_spinning_helmless = spr_moose_spinning_hitbox, spr_moose_spinning_hurtbox],
	[global.moose_animation_spinning_disarmed = spr_moose_spinning_hitbox, spr_moose_spinning_hurtbox],

//staggered
	[global.moose_animation_staggered = noone, spr_moose_staggered_hurtbox],
	[global.moose_animation_staggered_helmless = noone, spr_moose_staggered_hurtbox],
	[global.moose_animation_staggered_disarmed = noone, spr_moose_staggered_hurtbox],
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