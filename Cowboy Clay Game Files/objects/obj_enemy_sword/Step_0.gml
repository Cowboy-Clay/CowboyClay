if currentState == SwordState.FLYING
{
	Gravity(global.enemy_sword_grav, global.enemy_sword_grav_max);
	sc = CheckEnemySwordCollisions();
	if sc == 1 EnemySwordStickInWall(SwordState.STUCK_WALL_LEFT);
	else if sc == 2 EnemySwordStickInWall(SwordState.STUCK_WALL_RIGHT);
	else if sc == 3 EnemySwordStickInGround();
}

if falling Gravity(global.enemy_sword_grav, global.enemy_sword_grav_max);

SetEnemySwordRotation();

EnemySwordAnimate();