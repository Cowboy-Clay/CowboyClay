// Idle
global.moose_wandersPerIdle = 4;
global.moose_minIdleTime = 40;
global.moose_maxIdleTime = 70;
global.moose_idleFriction = .11;

// Wander
global.moose_minWanderTime = 60;
global.moose_maxWanderTime = 90;
global.moose_minDistance = 400;
global.moose_maxDistance = 600;
global.moose_wanderAccel = .4;
global.moose_wanderMaxSpeed = 1.4;
global.moose_wanderFriction = .1;

// Slide
global.moose_slideAntiDuration = 40;
global.moose_slideImpulse = 30;
global.moose_slideMaxSpeed = 30;
global.moose_slideFriction = .6;

global.moose_chargeAntiTime = 37;
global.moose_chargeAccel = 8;

global.moose_invulTime = 60;

// Animations
global.moose_idleAnim = spr_moose_idle;
global.moose_idleAnim_disar = spr_moose_idle_disarmed;
global.moose_idleAnim_FPI = 1;
global.moose_idleAnim_type = AnimationType.FIRST_FRAME;


global.moose_wanderAnim = spr_moose_walk;
global.moose_wanderAnim_disar = spr_moose_walk_disarmed;
global.moose_wanderAnim_FPI = 120;
global.moose_wanderAnim_type = AnimationType.LOOP;

global.moose_slideAntiAnim = spr_moose_slideAnti;
global.moose_slideAntiAnim_FPI = 1;
global.moose_slideAntiAnim_type = AnimationType.FIRST_FRAME;

global.moose_slideAnim = spr_moose_slide;
global.moose_slideAnim_FPI = 1;
global.moose_slideAnim_type = AnimationType.HOLD;

global.moose_chargeAntiAnim = spr_moose_chargeAnti;
global.moose_chargeAntiAnim_FPI = 1;
global.moose_chargeAntiAnim_type = AnimationType.FIRST_FRAME;

global.moose_chargeAnim = spr_moose_charge;
global.moose_chargeAnim_FPI = 1;
global.moose_chargeAnim_type = AnimationType.FIRST_FRAME;

global.moose_hitAnim = spr_moose_hit;
global.moose_hitAnim_FPI = 1;
global.moose_hitAnim_type = AnimationType.FIRST_FRAME;