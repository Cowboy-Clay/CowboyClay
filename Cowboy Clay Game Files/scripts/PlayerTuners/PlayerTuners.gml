// [sprite, fpi, type]
global.player_animation_idle = [spr_clay_f_idle, 20, animation_type.loop];
global.player_animation_idle_disarmed = [spr_clay_n_idle, 60, animation_type.first_frame];
global.player_animation_idle_sword_charge = [spr_player_charging, 60, animation_type.first_frame];
global.player_animation_idle_sling_charge = [spr_player_aim, 10, animation_type.loop];
global.player_animation_idle_sling_charge_disarmed = [spr_player_aim_disarmed, 10, animation_type.loop];

global.player_animation_stra_idle = [spr_player_strafe, 60, animation_type.first_frame];
global.player_animation_stra_idle_disarmed = [spr_player_strafe_disarmed, 60, animation_type.first_frame];

global.player_animation_walk = [spr_clay_f_step, 20, animation_type.loop];
global.player_animation_walk_disarmed = [spr_player_run_disarmed, 6, animation_type.loop];
global.player_animation_walk_sword_charge = [spr_player_charging, 5, animation_type.loop];
global.player_animation_walk_sling_charge = [spr_player_aimWalk, 10, animation_type.loop];
global.player_animation_walk_sling_charge_disarmed = [spr_player_aimWalk_disarmed, 10, animation_type.loop];

global.player_animation_strastep = [spr_player_strafe, 5, animation_type.loop];
global.player_animation_backstep = [spr_player_strafe, 5, animation_type.loop_reverse];
global.player_animation_strastep_disarmed = [spr_player_strafe_disarmed, 5, animation_type.loop];
global.player_animation_backstep_disarmed = [spr_player_strafe_disarmed, 5, animation_type.loop_reverse];
global.player_animation_strastep_sword_charge = [spr_player_charging, 5, animation_type.loop];
global.player_animation_backstep_sword_charge = [spr_player_charging, 5, animation_type.loop_reverse];
global.player_animation_strastep_sling_charge = [spr_player_aimWalk, 10, animation_type.loop];
global.player_animation_backstep_sling_charge = [spr_player_aimWalkBack, 10, animation_type.loop];
global.player_animation_backstep_sling_charge_disarmed = [spr_player_aimWalkBack_disarmed, 10, animation_type.loop];

global.player_animation_jump_anti = [spr_clay_f_idle, 60, animation_type.first_frame];
global.player_animation_jump_anti_disarmed = [spr_player_jumpAnti_disarmed, 60, animation_type.first_frame];
global.player_animation_jump_anti_sword_charge = [spr_player_chargeJumpAnti, 60, animation_type.first_frame];
global.player_animation_jump_anti_sling_charge = [spr_player_slingJumpAnti, 10, animation_type.loop];
global.player_animation_jump_anti_sling_charge_disarmed = [spr_player_slingJumpAnti_disarmed, 10, animation_type.loop];

global.player_animation_jump = [spr_clay_f_jump, 10, animation_type.loop];
global.player_animation_jump_disarmed = [spr_player_jump_disarmed, 30, animation_type.loop];
global.player_animation_jump_sword_charge = [spr_player_chargeJump, 60, animation_type.first_frame];
global.player_animation_jump_sling_charge = [spr_player_aimJump, 10, animation_type.loop];
global.player_animation_jump_sling_charge_disarmed = [spr_player_aimJump_disarmed, 10, animation_type.loop];

global.player_animation_fall = [spr_clay_f_jump, 10, animation_type.loop];
global.player_animation_fall_disarmed = [spr_player_falling_disarmed, 15, animation_type.loop];
global.player_animation_fall_sword_charge = [spr_player_chargeJump, 10, animation_type.first_frame];
global.player_animation_fall_sling_charge = [spr_player_aimFalling, 10, animation_type.loop];
global.player_animation_fall_sling_charge_disarmed = [spr_player_aimFalling_disarmed, 10, animation_type.loop];

#region New Attacks
global.player_animation_attack_high_anti = [spr_clay_f_hSlash_anti, 20, animation_type.hold];
global.player_animation_attack_high_swing = [spr_clay_f_hSlash_hit, 20, animation_type.hold];
global.player_animation_attack_high_follow = [spr_clay_f_hSlash_follow, 20, animation_type.hold];
global.player_animation_attack_high_blocked = [spr_clay_f_hSlash_blocked, 20, animation_type.hold];

global.player_animation_attack_mid_anti = [spr_clay_f_mStab_anti, 20, animation_type.hold];
global.player_animation_attack_mid_swing = [spr_clay_f_mStab_hit, 20, animation_type.hold];
global.player_animation_attack_mid_follow = [spr_clay_f_mStab_follow, 20, animation_type.hold];
global.player_animation_attack_mid_blocked = [spr_clay_f_mStab_blocked, 20, animation_type.hold];

global.player_animation_attack_low_anti = [spr_clay_f_LSlash_anti, 20, animation_type.hold];
global.player_animation_attack_low_swing = [spr_clay_f_LSlash_hit, 20, animation_type.hold];
global.player_animation_attack_low_follow = [spr_clay_f_LSlash_follow, 20, animation_type.hold];
global.player_animation_attack_low_blocked = [spr_clay_f_hSlash_blocked, 20, animation_type.hold];
#endregion

global.player_animation_sword_hi_anti = [spr_player_jumpAttack_Anti, 60, animation_type.first_frame];
global.player_animation_sword_hi_swing = [spr_player_jumpAttack_Swing, 60, animation_type.first_frame];
global.player_animation_sword_hi_follow = [spr_player_jumpAttack_Follow, 10, animation_type.loop];

global.player_animation_sling_anti = [spr_player_aim, 60, animation_type.first_frame];
global.player_animation_sling_anti_disarmed = [spr_player_aim_disarmed, 60, animation_type.first_frame];
global.player_animation_sling_swing = [spr_player_sling, 60, animation_type.first_frame];
global.player_animation_sling_swing_disarmed = [spr_player_sling_disarmed, 60, animation_type.first_frame];
global.player_animation_sling_follow = [spr_player_slingFollow, 60, animation_type.first_frame];
global.player_animation_sling_follow_disarmed = [spr_player_slingFollow_disarmed, 60, animation_type.first_frame];

global.player_animation_sling_hi_anti = [spr_player_aim, 60, animation_type.first_frame];
global.player_animation_sling_hi_anti_disarmed = [spr_player_aim_disarmed, 60, animation_type.first_frame];
global.player_animation_sling_hi_swing = [spr_player_shootJump, 60, animation_type.first_frame];
global.player_animation_sling_hi_swing_disarmed = [spr_player_shootJump, 60, animation_type.first_frame];
global.player_animation_sling_hi_follow = [spr_player_shootFall, 10, animation_type.loop];
global.player_animation_sling_hi_follow_disarmed = [spr_player_shootFall_disarmed, 10, animation_type.loop];

global.player_animation_attack_cancel = [spr_player_blockMiss, 60, animation_type.first_frame];
global.player_animation_attack_cancel_disarmed = [spr_player_blockMiss, 60, animation_type.first_frame];

global.player_animation_block_hi = [spr_player_hiBlock, 20, animation_type.hold];
global.player_animation_block_lo = [spr_player_parryAnti, 10, animation_type.hold];
global.player_animation_block_hi_recoil = [spr_player_hiBlock_stun, 60, animation_type.first_frame];
global.player_animation_block_lo_recoil = [spr_player_parry, 60, animation_type.first_frame];
global.player_animation_block_failure = [spr_player_parryFollow, 60, animation_type.first_frame];

global.player_animation_block_lo_disarmed = [spr_player_parryAnti_disarmed, 10, animation_type.hold];
global.player_animation_block_lo_recoil_disarmed = [spr_player_parry_disarmed, 60, animation_type.first_frame];
global.player_animation_block_lo_failure_disarmed = [spr_player_parryFollow_disarmed, 60, animation_type.first_frame];

global.player_animation_pain = [spr_player_damaged, 60, animation_type.first_frame];
global.player_animation_pain_disarmed = [spr_player_damaged_disarmed, 60, animation_type.first_frame];
global.player_animation_death = [spr_player_death, 15, animation_type.hold];

global.player_animation_kick_anti = [spr_player_kickAnti,60,animation_type.first_frame];
global.player_animation_kick_anti_disarmed = [spr_player_kickAnti_disarmed,60,animation_type.first_frame];

global.player_animation_kick_swing = [spr_player_kick,10,animation_type.hold];
global.player_animation_kick_swing_disarmed = [spr_player_kick_disarmed,10,animation_type.hold];
global.player_animation_kick_follow = [spr_player_kickAnti,60,animation_type.first_frame];
global.player_animation_kick_follow_disarmed = [spr_player_kickAnti_disarmed,60,animation_type.first_frame];
