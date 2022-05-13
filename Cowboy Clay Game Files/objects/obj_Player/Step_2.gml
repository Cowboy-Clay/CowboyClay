if collision_check_edge(x,y,spr_player_collision,Direction.LEFT,[obj_Moose]) && collision_check_edge(x,y,spr_player_collision,Direction.RIGHT,[obj_Moose]){
	var _s = 1;
	while collision_check_edge(x,y,spr_player_collision,Direction.LEFT,[obj_Moose]) && collision_check_edge(x,y,spr_player_collision,Direction.RIGHT,[obj_Moose]) {
		x += _s;
		_s = (_s+sign(_s))*-1;
	}
}
