function get_hi_attack_player(inst, distance_threshold){
	with inst {
		var b = edge_get_location(x,y,spr_clay_n_collision)[2];
		var m = [obj_tile_coll,obj_elevator];
		return !(collision_line_mask(x,b, x, b+distance_threshold, m,true,true));
	}
}