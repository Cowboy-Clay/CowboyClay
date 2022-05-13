if current_state == SwordState.FLYING
{
	Gravity(global.enemy_sword_grav, global.enemy_sword_grav_max, sprite_index, collision_mask);
	
	
	if collision_check_edge(x,y,sprite_index,Direction.LEFT,collision_mask){
		audio_play_sound(sfx_moose_knife_plant,-5,false);
		EnemySwordStickInWall(SwordState.STUCK_WALL_LEFT);
	}else if collision_check_edge(x,y,sprite_index,Direction.RIGHT,collision_mask){
		audio_play_sound(sfx_moose_knife_plant,-5,false);
		EnemySwordStickInWall(SwordState.STUCK_WALL_RIGHT);
	}else if collision_check_edge(x,y,sprite_index,Direction.DOWN,collision_mask){
		audio_play_sound(sfx_moose_knife_plant,-5,false);
		EnemySwordStickInGround();
	}

	collision_check(sprite_index, collision_mask, false, false);
}

if current_state==SwordState.KICKED {
	Gravity(global.sword_grav, global.sword_grav_max,sprite_index,collision_mask);
	if collision_check_edge(x,y,sprite_index,Direction.DOWN,collision_mask){
		EnemySwordStickInGround();
		return;
	}
}

SetEnemySwordRotation();

EnemySwordAnimate();