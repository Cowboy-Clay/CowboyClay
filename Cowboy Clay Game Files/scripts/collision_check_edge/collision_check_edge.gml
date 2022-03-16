function collision_check_edge(xpos, ypos, sprite, edge, mask){
	switch(edge) {
		case Direction.LEFT:
			var l = edge_get_location(xpos, ypos, sprite, Direction.LEFT);
			var u = edge_get_location(xpos, ypos, sprite, Direction.UP);
			var d = edge_get_location(xpos, ypos, sprite, Direction.DOWN);
			u += 2;
			d -= 2;
			for (var i = u; i <= d; i += 20) {
				if collision_point_mask(l, i, mask, true, true){
					show_debug_message("Colliding on left side.");
					return true;
				}
			}
			if collision_point_mask(l, d, mask, true, true){
				show_debug_message("Colliding on left side.");
				return true;
			}
			break;
		case Direction.RIGHT:
			var r = edge_get_location(xpos, ypos, sprite, Direction.RIGHT);
			var u = edge_get_location(xpos, ypos, sprite, Direction.UP);
			var d = edge_get_location(xpos, ypos, sprite, Direction.DOWN);
			u += 2;
			d -= 2;
			for (var i = u; i <= d; i += 20) {
				if collision_point_mask(r, i, mask, true, true){
					show_debug_message("Colliding on right side.");
					return true;
				}
			}
			if collision_point_mask(r, d, mask, true, true){
				show_debug_message("Colliding on right side.");
				return true;
			}
			break;
		case Direction.UP:
			var u = edge_get_location(xpos, ypos, sprite, Direction.UP);
			var l = edge_get_location(xpos, ypos, sprite, Direction.LEFT);
			var r = edge_get_location(xpos, ypos, sprite, Direction.RIGHT);
			l += 2;
			r -= 2;
			for (var i = l; i <= r; i += 20) {
				if collision_point_mask(i, u, mask, true, true){
					show_debug_message("Colliding on up side.");
					return true;
				}
			}
			if collision_point_mask(r, u, mask, true, true){
				show_debug_message("Colliding on up side.");
				return true;
			}
			break;
		case Direction.DOWN:
			var d = edge_get_location(xpos, ypos, sprite, Direction.DOWN);
			var l = edge_get_location(xpos, ypos, sprite, Direction.LEFT);
			var r = edge_get_location(xpos, ypos, sprite, Direction.RIGHT);
			l += 2;
			r -= 2;
			for (var i = l; i <= r; i += 20) {
				if collision_point_mask(i, d, mask, true, true){
					show_debug_message("Colliding on down side.");
					return true;
				}
			}
			if collision_point_mask(r, d, mask, true, true){
				show_debug_message("Colliding on down side.");
				return true;
			}
			break;
	}
	return false;
}