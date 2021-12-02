if currentState == SwordState.FLYING
{
	Gravity(global.sword_grav, global.sword_grav_max);
	sc = CheckSwordCollisions();
	if sc == 1 PlayerSwordStickInWall(SwordState.STUCK_WALL_LEFT);
	else if sc == 2 PlayerSwordStickInWall(SwordState.STUCK_WALL_RIGHT);
	else if sc == 3 PlayerSwordStickInGround();
}

SetPlayerSwordRotation();

SwordAnimate();