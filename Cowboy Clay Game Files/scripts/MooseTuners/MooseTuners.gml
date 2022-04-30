// Idle
global.moose_wandersPerIdle = 4;
global.moose_minIdleTime = 40;
global.moose_maxIdleTime = 70;
global.moose_idleFriction = .5;

// Wander
global.moose_minWanderTime = 30;
global.moose_maxWanderTime = 80;
global.moose_minDistance = 400;
global.moose_maxDistance = 600;
global.moose_wanderAccel = .8;
global.moose_wanderMaxSpeed = 1.4;
global.moose_wanderFriction = .7;

global.moose_attack_close_distance = 350;
global.moose_attack_far_distance = 950;
global.moose_attack_safe_distance = 600;
global.moose_attack_distance_threshold = 500;

// Stab
global.moose_lunge_anti_frames = 5;
global.moose_lunge_speed = 15;
global.moose_lunge_distance_max = 900;
global.moose_lunge_target_distance_to_player = 100;
global.moose_stab_anti_frames = 25;
global.moose_stab_frames = 20;

// Jump
global.moose_jump_anti_frames = 10;
global.moose_jump_y_height = 500;
global.moose_jump_x_speed = 20;
global.moose_jump_y_speed = 10;
global.moose_dive_anti_frames = 0;
global.moose_dive_speed = 20;
global.moose_stuck_frames = 60;
global.moose_spin_x_speed = 10;
global.moose_spin_y_speed = -10;
global.moose_spin_y_offset = 25;

// Slide
global.moose_slideAntiDuration = 40;
global.moose_slideImpulse = 30;
global.moose_slideMaxSpeed = 30;
global.moose_slideFriction = .6;

global.moose_chargeAntiTime = 37;
global.moose_chargeAccel = 1;

global.moose_invulTime = 180;

global.moose_blockDistance = 300;

global.moose_stun_time = 120;

global.moose_too_many_head_jumps = 10;
global.moose_player_jump_charge_too_long_time = 240;
global.moose_player_basic_charge_too_long_time = 220;
global.moose_player_sling_charge_too_long_time = 200;
global.moose_player_too_close_distance = 200;
global.moose_player_too_close_time = 60;

global.moose_burp_anti_time = 12;
global.moose_burp_swing_time = 25;
global.moose_burp_follow_time = 16;

// Animations

// Idle
global.moose_animation_idle = spr_moose_idle;
global.moose_animation_idle_helmless = spr_moose_idle_helmless;
global.moose_animation_idle_disarmed = spr_moose_idle_empty;
global.moose_animation_idle_blockHi = spr_moose_hiBlock;
	global.moose_animation_idle_FPI = 1;
	global.moose_animation_idle_type = AnimationType.FIRST_FRAME;

//Wander
global.moose_animation_wander = spr_moose_walk;
global.moose_animation_wander_helmless = spr_moose_walk_noHelm;
global.moose_animation_wander_disarmed = spr_moose_walk_empty;
global.moose_animation_wander_blockHi = spr_moose_walk_hiBlock;
	global.moose_animation_wander_FPI = 20;
	global.moose_animation_wander_type = AnimationType.LOOP;


//SlideAnti
global.moose_animation_slideAnti = spr_moose_slideAnti;
global.moose_animation_slideAnti_helmless = spr_moose_slideAnti_helmless;
global.moose_animation_slideAnti_disarmed = spr_moose_slideAnti_empty;
	global.moose_animation_slideAnti_FPI = 1;
	global.moose_animation_slideAnti_type = AnimationType.FIRST_FRAME;


//Slide
global.moose_animation_slide = spr_moose_slide;
global.moose_animation_slide_helmless = spr_moose_slide_noHelm;
global.moose_animation_slide_disarmed = spr_moose_slide_empty;
	global.moose_animation_slide_FPI = 1;
	global.moose_animation_slide_type = AnimationType.HOLD;


//ChargeAnti
global.moose_animation_chargeAnti = spr_moose_chargeAnti;
global.moose_animation_chargeAnti_helmless = spr_moose_chargeAnti_noHelm;
global.moose_animation_chargeAnti_disarmed = spr_moose_chargeAnti_empty;
	global.moose_animation_chargeAnti_FPI = 1;
	global.moose_animation_chargeAnti_type = AnimationType.FIRST_FRAME;


//Charge
global.moose_animation_charge = spr_moose_charge;
global.moose_animation_charge_helmless = spr_moose_charge_noHelm;
global.moose_animation_charge_disarmed = spr_moose_charge_empty;
	global.moose_animation_charge_FPI = 8;
	global.moose_animation_charge_type = AnimationType.LOOP;


//Hit
global.moose_animation_hit = spr_moose_hit;
global.moose_animation_hit_helmless = spr_moose_hit_disarmed;
	global.moose_animation_hit_FPI = 1;
	global.moose_animation_hit_type = AnimationType.FIRST_FRAME;


//Death
global.moose_animation_dead = spr_moose_dead;
	global.moose_animation_dead_FPI = 20;
	global.moose_animation_dead_type = AnimationType.HOLD;
	
	
//Idle - BlockLo
global.moose_animation_idle_blockLo = spr_moose_blockLo;
global.moose_animation_idle_blockLo_helmless = spr_moose_blockLo_helmless;
	global.moose_animation_idle_blockLo_FPI = 1;
	global.moose_animation_idle_blockLo_type = AnimationType.FIRST_FRAME;

//Walk - BlockLo
global.moose_animation_walk_blockLo = spr_moose_walkBlock;
global.moose_animation_walk_blockLo_helmless = spr_moose_walkBlock_noHelm;
	global.moose_animation_walk_blockLo_FPI = 20;
	global.moose_animation_walk_blockLo_type = AnimationType.LOOP;

//Idle - BlockHi
global.moose_animation_idle_blockHi_helmless = spr_moose_hiBlock;
	global.moose_animation_idle_blockHi_helmless_FPI = 1;
	global.moose_animation_idle_blockHi_helmless_type = AnimationType.FIRST_FRAME;

//Walk - BlockHi
global.moose_animation_walk_blockHi_helmless = spr_moose_walk_hiBlock;
	global.moose_animation_walk_blockHi_helmless_FPI = 20;
	global.moose_animation_walk_blockHi_helmless_type = AnimationType.LOOP;

//StabAnti
global.moose_animation_stabAnti = spr_moose_stabAnti;
global.moose_animation_stabAnti_helmless = spr_moose_stabAnti_noHelm;
global.moose_animation_stabAnti_disarmed = spr_moose_stabAnti_empty;
	global.moose_animation_stabAnti_FPI = 20;
	global.moose_animation_stabAnti_type = AnimationType.HOLD;

//Stab
global.moose_animation_stab = spr_moose_stab;
global.moose_animation_stab_helmless = spr_moose_stab_noHelm;
global.moose_animation_stab_disarmed = spr_moose_stab_empty;
	global.moose_animation_stab_FPI = 5;
	global.moose_animation_stab_type = AnimationType.HOLD;

//JumpAnti
global.moose_animation_jumpAnti = spr_moose_jumpAnti;
global.moose_animation_jumpAnti_helmless = spr_moose_jumpAnti;
global.moose_animation_jumpAnti_disarmed = spr_moose_jumpAnti;
	global.moose_animation_jumpAnti_FPI = 1;
	global.moose_animation_jumpAnti_type = AnimationType.FIRST_FRAME;
	
//Jumping
global.moose_animation_jumping = spr_moose_jumping;
global.moose_animation_jumping_helmless = spr_moose_jumping_nohelm;
global.moose_animation_jumping_disarmed = spr_moose_jumping_empty;
	global.moose_animation_jumping_FPI = 1;
	global.moose_animation_jumping_type = AnimationType.FIRST_FRAME;

//Plunging
global.moose_animation_plunging = spr_moose_plunging;
global.moose_animation_plunging_helmless = spr_moose_plunging_noHelm;
global.moose_animation_plunging_disarmed = spr_moose_plunging_noHelm;
	global.moose_animation_plunging_FPI = 1;
	global.moose_animation_plunging_type = AnimationType.FIRST_FRAME;

//Plunge Bumping
global.moose_animation_plungeBumping = spr_moose_plungeBumping;
global.moose_animation_plungeBumping_helmless = spr_moose_plungeBumping_helmless;
	global.moose_animation_plungeBumping_FPI = 20;
	global.moose_animation_plungeBumping_type = AnimationType.HOLD;

//Plunge Stuck
global.moose_animation_plungeStuck = spr_moose_plungeStuck;
global.moose_animation_plungeStuck_helmless = spr_moose_plungeStuck_helmless;
	global.moose_animation_plungStuck_FPI = 20;
	global.moose_animation_plungeStuck_type = AnimationType.LOOP;

//Spinning
global.moose_animation_spinning = spr_moose_spin;
global.moose_animation_spinning_helmless = spr_moose_spin_noHelm;
global.moose_animation_spinning_disarmed = spr_moose_spin_noHelm;
	global.moose_animation_spinning_FPI = 8;
	global.moose_animation_spinning_type = AnimationType.LOOP;
	
//Pulling
global.moose_animation_pulling = spr_moose_pull;
	global.moose_animation_pulling_FPI = 1;
	global.moose_animation_pulling_type = AnimationType.FIRST_FRAME;
	
//Staggered
global.moose_animation_staggered = spr_moose_staggered;
global.moose_animation_staggered_helmless = spr_moose_staggered_helmless;
global.moose_animation_staggered_disarmed = spr_moose_staggered_empty;
	global.moose_animation_staggered_FPI = 20;
	global.moose_animation_staggered_type = AnimationType.LOOP;
	
global.moose_animation_stuck = spr_moose_plungeStuck;
global.moose_animation_stuck_helmless = spr_moose_plungeStuck_helmless
	global.moose_animation_stuck_FPI = 15;
	global.moose_animation_stuck_type = AnimationType.LOOP;
