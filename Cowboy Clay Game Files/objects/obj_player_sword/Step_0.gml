if global.paused return;

if current_state == SwordState.FLYING
{
	if audio_is_playing(sfx_clay_sword_spin) == false {
		audio_play_sound(sfx_clay_sword_spin, 50, true);
	}
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
else if current_state == SwordState.KICKED{
	kicked();
}
else
{
	if audio_is_playing(sfx_clay_sword_spin) {
		audio_stop_sound(sfx_clay_sword_spin);
	}
	vspeed = 0;
	hspeed = 0;
}

switch current_state{
	case SwordState.STUCK_WALL_LEFT:
		break;
	case SwordState.STUCK_WALL_RIGHT:
		break;
	case SwordState.STUCK_FLOOR:
		break;
}

SetPlayerSwordRotation();

SwordAnimate();

if plungeFlag && place_meeting(x,y,obj_player_fighting) == false plungeFlag = false;