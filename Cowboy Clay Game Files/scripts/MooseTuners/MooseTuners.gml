// Idle
global.moose_wandersPerIdle = 5;
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

// Animations
global.moose_idleAnim = spr_Moose;
global.moose_idleAnim_FPI = 1;
global.moose_idleAnim_type = AnimationType.FIRST_FRAME;

global.moose_wanderAnim = spr_moose_walk;
global.moose_wanderAnim_disar = spr_moose_walk_disarmed;
global.moose_wanderAnim_FPI = 120;
global.moose_wanderAnim_type = AnimationType.LOOP;