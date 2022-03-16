if currentState == SwordState.FLYING
{
	Gravity(global.sword_grav, global.sword_grav_max,sprite_index,collision_mask);
	//sc = CheckSwordCollisions();
	//if sc == 1 PlayerSwordStickInWall(SwordState.STUCK_WALL_LEFT);
	//else if sc == 2 PlayerSwordStickInWall(SwordState.STUCK_WALL_RIGHT);
	//else if sc == 3 PlayerSwordStickInGround();
	
	collision_check(sprite_index,collision_mask, false, false);
	if collision_check_edge(x+hspeed, y+vspeed, sprite_index, Direction.LEFT, collision_mask)
		PlayerSwordStickInWall(SwordState.STUCK_WALL_LEFT);
	else if collision_check_edge(x+hspeed, y+vspeed, sprite_index, Direction.RIGHT, collision_mask)
		PlayerSwordStickInWall(SwordState.STUCK_WALL_RIGHT);
	else if collision_check_edge(x+hspeed, y+vspeed, sprite_index, Direction.DOWN, collision_mask)
		PlayerSwordStickInGround();
}

SetPlayerSwordRotation();

SwordAnimate();

if plungeFlag && place_meeting(x,y,obj_player) == false plungeFlag = false;