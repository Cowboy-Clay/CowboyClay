// This function is used to check if an object will collide with a set of object this frame and move it to be directly on them.
// This function assumes it is being called by an instance with a position.
// sprite, The sprite to use for calculating collision
// mask, The collision mask of objects as an array to check for collision with
// x_bouncy, Boolean of whether the object should bounce in the x direction
// y_bouncy, Boolean of whether the object should bounce in the y direction
function collision_check_elevator(sprite, mask, x_bouncy, y_bouncy){
	var xx = x;
	var yy = y;
	
	// Same as above but for y
	if vspeed == 0 {}
	else if ((collision_check_edge(xx, yy+vspeed,sprite,Direction.UP,mask)&&vspeed<0) ||
		(collision_check_edge(xx,yy+vspeed,sprite,Direction.DOWN,mask)&&vspeed>0)) {
		yy = round(yy);
		if vspeed > 0 {
			while (!collision_check_edge(xx,yy,sprite, Direction.DOWN, mask))
			{
				yy++;
				if mounted obj_player_fighting.y++;
			}
		}
		else{
			while (!collision_check_edge(xx,yy,sprite, Direction.UP, mask)) {
				if mounted obj_player_fighting.y--;
				yy --;
			}
		}
		y = yy;
		vspeed = y_bouncy == true? -1*vspeed : 0;
		if mounted obj_player_fighting.vspeed= 0;
	}
	
	/* 
	/ We check each corner to ensure there is no corner clipping.
	/ This was an issue.
	*/
	var edges = edge_get_location(x,y,sprite);
	var l = edges[3]+1;
	var u = edges[0]+1;
	var r = edges[1]-1;
	var d = edges[2]-1;
	
	if collision_point_mask(r,d,mask,true,true) {
		x--;
		y--;
	}
	if collision_point_mask(l,d,mask,true,true){
		x++;
		y--;
	}
	if collision_point_mask(l,u,mask,true,true){
		x++;
		y++;
	}
	if collision_point_mask(r,u,mask,true,true){
		x--;
		y++;
	}
	
	// We decide whether we are grounded or not at the end
	grounded = collision_check_edge(x+hspeed, y+vspeed, sprite, Direction.DOWN, mask);

}