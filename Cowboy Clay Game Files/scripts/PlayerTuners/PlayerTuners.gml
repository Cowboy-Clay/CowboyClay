// [sprite, fpi, type]
global.player_animation_idle = [spr_player_idle, 1, AnimationType.FIRST_FRAME];
global.player_animation_idle_disarmed = [spr_player_idle_disarmed, 1, AnimationType.FIRST_FRAME];
global.player_animation_idle_sword_charge = [spr_player_charging, 1, AnimationType.FIRST_FRAME];
global.player_animation_idle_sling_charge = [spr_player_aim, 6, AnimationType.LOOP];
global.player_animation_idle_sling_charge_disarmed = [spr_player_aim_disarmed, 6, AnimationType.LOOP];

global.player_animation_stra_idle = [spr_player_strafe, 1, AnimationType.FIRST_FRAME];
global.player_animation_stra_idle_disarmed = [spr_player_strafe_disarmed, 1, AnimationType.FIRST_FRAME];

global.player_animation_walk = [spr_player_run, 6, AnimationType.LOOP];
global.player_animation_walk_disarmed = [spr_player_run_disarmed, 6, AnimationType.LOOP];
global.player_animation_walk_sword_charge = [spr_player_charging, 12, AnimationType.LOOP];
global.player_animation_walk_sling_charge = [spr_player_aimWalk, 6, AnimationType.LOOP];
global.player_animation_walk_sling_charge_disarmed = [spr_player_aimWalk_disarmed, 6, AnimationType.LOOP];

global.player_animation_strastep = [spr_player_strafe, 12, AnimationType.LOOP];
global.player_animation_backstep = [spr_player_strafe, 12, AnimationType.REVERSE_LOOP];
global.player_animation_strastep_disarmed = [spr_player_strafe_disarmed, 12, AnimationType.LOOP];
global.player_animation_backstep_disarmed = [spr_player_strafe_disarmed, 12, AnimationType.REVERSE_LOOP];
global.player_animation_strastep_sword_charge = [spr_player_charging, 12, AnimationType.LOOP];
global.player_animation_backstep_sword_charge = [spr_player_charging, 12, AnimationType.REVERSE_LOOP];
global.player_animation_strastep_sling_charge = [spr_player_aimWalk, 6, AnimationType.LOOP];
global.player_animation_backstep_sling_charge = [spr_player_aimWalkBack, 6, AnimationType.LOOP];
global.player_animation_backstep_sling_charge_disarmed = [spr_player_aimWalkBack_disarmed, 6, AnimationType.LOOP];

global.player_animation_jump_anti = [spr_player_jumpAnti, 1, AnimationType.FIRST_FRAME];
global.player_animation_jump_anti_disarmed = [spr_player_jumpAnti_disarmed, 1, AnimationType.FIRST_FRAME];
global.player_animation_jump_anti_sword_charge = [spr_player_chargeJumpAnti, 1, AnimationType.FIRST_FRAME];
global.player_animation_jump_anti_sling_charge = [spr_player_slingJumpAnti, 6, AnimationType.LOOP];
global.player_animation_jump_anti_sling_charge_disarmed = [spr_player_slingJumpAnti_disarmed, 6, AnimationType.LOOP];

global.player_animation_jump = [spr_player_jump, 2, AnimationType.LOOP];
global.player_animation_jump_disarmed = [spr_player_jump_disarmed, 2, AnimationType.LOOP];
global.player_animation_jump_sword_charge = [spr_player_chargeJump, 1, AnimationType.FIRST_FRAME];
global.player_animation_jump_sling_charge = [spr_player_aimJump, 6, AnimationType.LOOP];
global.player_animation_jump_sling_charge_disarmed = [spr_player_aimJump_disarmed, 6, AnimationType.LOOP];

global.player_animation_fall = [spr_player_falling, 6, AnimationType.LOOP];
global.player_animation_fall_disarmed = [spr_player_falling_disarmed, 6, AnimationType.LOOP];
global.player_animation_fall_sword_charge = [spr_player_chargeJump, 6, AnimationType.FIRST_FRAME];
global.player_animation_fall_sling_charge = [spr_player_aimFalling, 6, AnimationType.LOOP];
global.player_animation_fall_sling_charge_disarmed = [spr_player_aimFalling_disarmed, 6, AnimationType.LOOP];

global.player_animation_sword_anti = [spr_player_charging, 1, AnimationType.FIRST_FRAME];
global.player_animation_sword_swing = [spr_player_slash, 1, AnimationType.FIRST_FRAME];
global.player_animation_sword_follow = [spr_player_slashFollow, 1, AnimationType.FIRST_FRAME];
global.player_animation_sword_hi_anti = [spr_player_jumpAttack_Anti, 1, AnimationType.FIRST_FRAME];
global.player_animation_sword_hi_swing = [spr_player_jumpAttack_Swing, 1, AnimationType.FIRST_FRAME];
global.player_animation_sword_hi_follow = [spr_player_jumpAttack_Follow, 6, AnimationType.LOOP];

global.player_animation_sling_anti = [spr_player_aim, 1, AnimationType.FIRST_FRAME];
global.player_animation_sling_anti_disarmed = [spr_player_aim_disarmed, 1, AnimationType.FIRST_FRAME];
global.player_animation_sling_swing = [spr_player_sling, 1, AnimationType.FIRST_FRAME];
global.player_animation_sling_swing_disarmed = [spr_player_sling_disarmed, 1, AnimationType.FIRST_FRAME];
global.player_animation_sling_follow = [spr_player_slingFollow, 1, AnimationType.FIRST_FRAME];
global.player_animation_sling_follow_disarmed = [spr_player_slingFollow_disarmed, 1, AnimationType.FIRST_FRAME];

global.player_animation_sling_hi_anti = [spr_player_aim, 1, AnimationType.FIRST_FRAME];
global.player_animation_sling_hi_anti_disarmed = [spr_player_aim_disarmed, 1, AnimationType.FIRST_FRAME];
global.player_animation_sling_hi_swing = [spr_player_shootJump, 1, AnimationType.FIRST_FRAME];
global.player_animation_sling_hi_swing_disarmed = [spr_player_shootJump, 1, AnimationType.FIRST_FRAME];
global.player_animation_sling_hi_follow = [spr_player_shootFall, 6, AnimationType.LOOP];
global.player_animation_sling_hi_follow_disarmed = [spr_player_shootFall_disarmed, 6, AnimationType.LOOP];

global.player_animation_attack_cancel = [spr_player_blockMiss, 1, AnimationType.FIRST_FRAME];
global.player_animation_attack_cancel_disarmed = [spr_player_blockMiss, 1, AnimationType.FIRST_FRAME];

global.player_animation_block_hi = [spr_player_hiBlock, 3, AnimationType.HOLD];
global.player_animation_block_lo = [spr_player_loBlock, 3, AnimationType.HOLD];
global.player_animation_block_hi_recoil = [spr_player_hiBlock_stun, 1, AnimationType.FIRST_FRAME];
global.player_animation_block_lo_recoil = [spr_player_loBlock_stun, 1, AnimationType.FIRST_FRAME];
global.player_animation_block_failure = [spr_player_blockMiss, 1, AnimationType.FIRST_FRAME];

global.player_animation_death = [spr_player_death, 6, AnimationType.HOLD];
