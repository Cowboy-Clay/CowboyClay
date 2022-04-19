// [sprite, fpi, type]
global.player_animation_idle = [spr_player_idle, 1, AnimationType.FIRST_FRAME];
global.player_animation_idle_disarmed = [spr_player_idle_disarmed, 1, AnimationType.FIRST_FRAME];
global.player_animation_idle_sword_charge = noone;
global.player_animation_idle_sling_charge = noone;

global.player_animation_walk = [spr_player_walk, 12, AnimationType.LOOP];
global.player_animation_walk_disarmed = noone;
global.player_animation_walk_sword_charge = noone;
global.player_animation_walk_sling_charge = noone;

global.player_animation_backstep = noone;
global.player_animation_backstep_disarmed = noone;
global.player_animation_backstep_sword_charge = noone;
global.player_animation_backstep_sling_charge = noone;

global.player_animation_jump = noone;
global.player_animation_jump_disarmed = noone;
global.player_animation_jump_sword_charge = noone;
global.player_animation_jump_sling_charge = noone;

global.player_animation_fall = noone;
global.player_animation_fall_disarmed = noone;
global.player_animation_fall_sword_charge = noone;
global.player_animation_fall_sling_charge = noone;

global.player_animation_sword_anti = noone;
global.player_animation_sword_swing = noone;
global.player_animation_sword_follow = noone;

global.player_animation_sling_anti = noone;
global.player_animation_sling_swing = noone;
global.player_animation_sling_follow = noone;

global.player_animation_attack_cancel = noone;
global.player_animation_attack_cancel_disarmed = noone;

global.player_animation_block_hi = noone;
global.player_animation_block_lo = noone;
global.player_animation_block_hi_recoil = noone;
global.player_animation_block_lo_recoil = noone;
global.player_animation_block_failure = noone;

// Idle animations
global.player_idleAnim = spr_player_idle;
global.player_idleAnim_disarmed = spr_player_idle_disarmed;
global.player_idleFPI = 1;
global.player_idleAnimType = AnimationType.FIRST_FRAME;
// Run animations
global.player_walkAnim = spr_player_walk_armed;
global.player_walkAnim_disarmed = spr_player_walk_disarmed;
global.player_walkFPI = 12;
global.player_walkAnimType = AnimationType.LOOP;
// Attack animations
global.player_attackAntiAnim = spr_player_attackAnti;
global.player_attackSwingAnim = spr_player_attackSwing;
global.player_attackFollowAnim = spr_player_attackFollow;
// Hi Attack animations
global.player_hiattackAntiAnim = spr_player_jumpAttack_Anti;
global.player_hiattackSwingAnim = spr_player_jumpAttack_Swing;
global.player_hiattackFollowAnim = spr_player_jumpAttack_Follow;
// Kick animations
global.player_kickAntiAnim = spr_player_idle;
global.player_kickSwingAnim = spr_player_idle;
global.player_kickFollowAnim = spr_player_idle;
// Jump anti anims
global.player_jumpAntiAnim = spr_player_jumpAnti;
global.player_jumpAntiAnim_disarmed = spr_player_jumpAnti_disarmed;
global.player_jumpAntiFPI = 1;
global.player_jumpAntiAnimType = AnimationType.HOLD;
// Jump animations
global.player_jumpAnim = spr_player_jump;
global.player_jumpAnim_disarmed = spr_player_jump_disarmed;
global.player_jumpFPI = 1;
global.player_jumpAnimType = AnimationType.HOLD;
// Fall animations
global.player_fallAnim = spr_player_fall;
global.player_fallAnim_disarmed = spr_player_jumpDown_disarmed;
global.player_fallFPI = 1;
global.player_fallAnimType = AnimationType.HOLD;
// Dash anims
global.player_dashAnim = spr_player_dash;
global.player_dashAnim_disarmed = spr_player_dash_disarmed;
global.player_dashAnimFPI = 1;
global.player_dashAnimType = AnimationType.FIRST_FRAME;
// Dash anticipation animations
global.player_dashAntiAnim = spr_player_dash_anti;
global.player_dashAntiAnim_disarmed = spr_player_dash_anti_disarmed;
global.player_dashAntiAnimFPI = 1;
global.player_dashAntiAnimType = AnimationType.FIRST_FRAME;
// Dash follow animations
global.player_dashFollowAnim = spr_player_dash_follow;
global.player_dashFollowAnim_disarmed = spr_player_dash_follow_disarmed;
global.player_dashFollowAnimFPI = 1;
global.player_dashFollowAnimType = AnimationType.FIRST_FRAME;
// Death animations
global.player_deathAnim = spr_player_death;
global.player_deathAnimFPI = 6;
global.player_deadAnimType = AnimationType.HOLD;
// Block animations
global.player_animation_hi_block = spr_player_hiBlock;
global.player_animation_lo_block = spr_player_loBlock;
global.player_animation_block_FPI = 1;
global.player_animation_block_type = AnimationType.FIRST_FRAME;
// Block success animations
global.player_animation_hi_block_success = spr_player_hiBlock_stun;
global.player_animation_lo_block_success = spr_player_loBlock_stun;
global.player_animation_block_success_FPI = 12;
global.player_animation_block_success_type = AnimationType.HOLD;
// Block failure animations
global.player_animation_hi_block_failure = noone;
global.player_animation_lo_block_failure = noone;
global.player_animation_block_failure_FPI = 12;
global.player_animation_block_failure_type = AnimationType.HOLD;