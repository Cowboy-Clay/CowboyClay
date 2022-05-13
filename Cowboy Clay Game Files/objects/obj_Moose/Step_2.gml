if collision_check_edge(x,y,spr_enemy_collision,Direction.LEFT,[obj_player]) && collision_check_edge(x,y,spr_enemy_collision,Direction.RIGHT,[obj_player]){
	var _s = 1;
	while collision_check_edge(x,y,spr_enemy_collision,Direction.LEFT,[obj_player]) && collision_check_edge(x,y,spr_enemy_collision,Direction.RIGHT,[obj_player]) {
		x += _s;
		_s = (_s+sign(_s))*-1;
	}
}
