check_mounted();

if mounted && obj_player.facing == Direction.LEFT && obj_player.currentState == PlayerState.BASIC_ATTACK_SWING && cooldown_timer <= 0
{
	get_hit();
}
if cooldown_timer >= 0 cooldown_timer --;

switch(state)
{
	case elevator_state.falling:
		fall();
		break;
	case elevator_state.rising:
		rise();
		CheckEnvironCollisions(spr_mech_elevator_coll, collision_mask);
		break;
	case elevator_state.holding:
		hold();
		break;
}

while place_meeting(x,y+1,obj_player) && mounted
{
	obj_player.y --;
}