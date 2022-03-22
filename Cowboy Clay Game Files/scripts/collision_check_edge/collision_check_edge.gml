/*
/ This function checks whether a given edge of an object
/ is colliding with object in the mask based on a given
/ position and collision sprite.
*/
function collision_check_edge(xpos, ypos, sprite, edge, mask){
	var edges = edge_get_location(xpos, ypos, sprite);
	var u = edges[0];
	var r = edges[1];
	var d = edges[2];
	var l = edges[3];
	
	// This switch determines which edge we check
	switch(edge) {
		case Direction.LEFT:
			// We use the left edge and the top and bottom positions
			u += 2;
			d -= 2;
			if collision_line_mask(l,u,l,d,mask,true,true){
				show_debug_message("Colliding on left side.");
				return true;
			}
			break;
		case Direction.RIGHT:
			u += 2;
			d -= 2;
			if collision_line_mask(r,u,r,d,mask,true,true){
				show_debug_message("Colliding on right side.");
				return true;
			}
			break;
		case Direction.UP:
			l += 2;
			r -= 2;
			if collision_line_mask(l,u,r,u,mask,true,true){
				show_debug_message("Colliding on up side.");
				return true;
			}
			break;
		case Direction.DOWN:
			l += 2;
			r -= 2;
			if collision_line_mask(l,d,r,d,mask,true,true){
				show_debug_message("Colliding on down side.");
				return true;
			}
			break;
	}
	return false;
}