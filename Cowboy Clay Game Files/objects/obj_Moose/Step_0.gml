/// @description Insert description here
// You can write your code in this editor
if !global.paused
{
	if current_state != MooseState.LOCK && current_state != MooseState.DEAD
	{
		UpdateMooseState();
		MooseStateBasedActions();
		MoosePickupSword();
	}
	else if current_state == MooseState.LOCK
	{
		MooseWanderToIdle();
	}
	else if current_state == MooseState.DEAD obj_player.current_state = PlayerState.LOCK;
	
	Friction(GetMooseFriction());
	Gravity(get_gravity(),50,spr_enemy_collision, collision_mask);
	//LimitMooseSpeed();
	
	update_animation();
	PlayMooseAnimation();
	
	SetMooseDirection();
	
	MooseInvuln();
}

collision_check(spr_enemy_collision,collision_mask, false, false);

var pl, pr;
with(obj_player) {
	pl = collision_check_edge(x,y,spr_player_collision,Direction.LEFT,collision_mask);
	pr = collision_check_edge(x,y,spr_player_collision,Direction.RIGHT,collision_mask);
}
if pl {
	while collision_check_edge(x,y,spr_enemy_collision,Direction.LEFT,[obj_player]) {
		x ++;
	}
}
if pr {
	while collision_check_edge(x,y,spr_enemy_collision,Direction.RIGHT,[obj_player]) {
		x --;
	}
}

//message_state();