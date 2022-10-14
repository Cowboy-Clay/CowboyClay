if collision_check_edge(x,y,spr_clay_n_collision,Direction.LEFT,[obj_Moose]) && collision_check_edge(x,y,spr_clay_n_collision,Direction.RIGHT,[obj_Moose]){
	var _s = 1;
	while collision_check_edge(x,y,spr_clay_n_collision,Direction.LEFT,[obj_Moose]) && collision_check_edge(x,y,spr_clay_n_collision,Direction.RIGHT,[obj_Moose]) {
		x += _s;
		_s = (_s+sign(_s))*-1;
	}
}

if pause_flag {
	pause_flag = false;
	jump_buffer = -5;
	pause();
}
