if current_state == SwordState.FLYING
{
	Gravity(global.enemy_sword_grav, global.enemy_sword_grav_max, sprite_index, collision_mask);
	
	collision_check(sprite_index, collision_mask, false, false);
	
	if collision_check_edge(x,y,sprite_index,Direction.LEFT,collision_mask) EnemySwordStickInWall(SwordState.STUCK_WALL_LEFT);
	else if collision_check_edge(x,y,sprite_index,Direction.RIGHT,collision_mask) EnemySwordStickInWall(SwordState.STUCK_WALL_RIGHT);
	else if collision_check_edge(x,y,sprite_index,Direction.DOWN,collision_mask) EnemySwordStickInGround();
}

if falling Gravity(global.enemy_sword_grav, global.enemy_sword_grav_max, sprite_index, collision_mask);

SetEnemySwordRotation();

EnemySwordAnimate();