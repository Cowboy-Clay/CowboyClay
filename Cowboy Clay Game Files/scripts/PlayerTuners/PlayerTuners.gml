// Idle animations
global.player_idleAnim = spr_player_walk_loBlock3;
global.player_idleAnim_disarmed = spr_player_idle_disarmed;
global.player_idleFPI = 1;
global.player_idleAnimType = AnimationType.FIRST_FRAME;
// Run animations
global.player_walkAnim = spr_player_walk_loBlock3;
global.player_walkAnim_disarmed = spr_player_walk_disarmed;
global.player_walkFPI = 12;
global.player_walkAnimType = AnimationType.LOOP;
// Attack animations
global.player_attackAntiAnim = spr_player_attackAnti;
global.player_attackSwingAnim = spr_player_attackSwing;
global.player_attackFollowAnim = spr_player_attackFollow;
// Kick animations
global.player_kickAntiAnim = spr_player_idle;
global.player_kickSwingAnim = spr_player_idle;
global.player_kickFollowAnim = spr_player_idle;
// Jump anti anims
global.player_jumpAntiAnim = spr_player_jumpAnti;
global.player_jumpAntiAnim_disarmed = spr_player_jumpAnti_disarmed;
global.player_jumpAntiFPI = 1;
global.player_jumpAntiAnimType = AnimationType.HOLD;
global.player_jumpAnim = spr_player_jump;
global.player_jumpAnim_disarmed = spr_player_jump_disarmed;
global.player_jumpFPI = 1;
global.player_jumpAnimType = AnimationType.HOLD;
global.player_fallAnim = spr_player_fall;
global.player_fallAnim_disarmed = spr_player_jumpDown_disarmed;
global.player_fallFPI = 1;
global.player_fallAnimType = AnimationType.HOLD;
// Dash anims
global.player_dashAnim = spr_player_dash;
global.player_dashAnim_disarmed = spr_player_dash_disarmed;
global.player_dashAnimFPI = 1;
global.player_dashAnimType = AnimationType.FIRST_FRAME;

global.player_dashAntiAnim = spr_player_dash_anti;
global.player_dashAntiAnim_disarmed = spr_player_dash_anti_disarmed;
global.player_dashAntiAnimFPI = 1;
global.player_dashAntiAnimType = AnimationType.FIRST_FRAME;

global.player_dashFollowAnim = spr_player_dash_follow;
global.player_dashFollowAnim_disarmed = spr_player_dash_follow_disarmed;
global.player_dashFollowAnimFPI = 1;
global.player_dashFollowAnimType = AnimationType.FIRST_FRAME;

global.player_deathAnim = spr_player_death;
global.player_deathAnimFPI = 6;
global.player_deadAnimType = AnimationType.HOLD;

global.player_highGuardAnim = global.player_idleAnim;
global.player_highGuardAnimFPI = global.player_idleFPI;
global.player_highGuardAnimType = global.player_idleAnimType;