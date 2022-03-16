// This function is used to check if an object will collide with a set of object this frame and move it to be directly on them.
// This function assumes it is being called by an instance with a position.
// sprite, The sprite to use for calculating collision
// mask, The collision mask of objects as an array to check for collision with
// x_bouncy, Boolean of whether the object should bounce in the x direction
// y_bouncy, Boolean of whether the object should bounce in the y direction
function collision_check(sprite, mask, x_bouncy, y_bouncy){
	var xx = x;
	var yy = y;
	
	if hspeed == 0 {}	// If the object is not moving horizontally we don't need to check for collision
	/* Horizontal collision is accounted for when either
	/  heading left with leftward collision
	/  or when heading right with rightward collision. 
	*/
	else if ((collision_check_edge(xx+hspeed,yy,sprite,Direction.LEFT,mask)&&hspeed<0) ||
		(collision_check_edge(xx+hspeed,yy,sprite,Direction.RIGHT,mask)&&hspeed>0)) {
		xx = round(xx);	// Round x so we are pixel perfect
		/* Uses an if statement because we need to check
		/  collision in a specific direction
		*/
		if hspeed > 0 {
			while (!collision_check_edge(xx,yy,sprite,Direction.RIGHT, mask)) {
				xx++;
			}
		}else{
			while (!collision_check_edge(xx,yy,sprite,Direction.LEFT, mask)) {
				xx--;
			}
		}
		x = xx;
		hspeed = x_bouncy == true ? -1*hspeed : 0;
	}
	
	// Same as above but for y
	if vspeed == 0 {}
	else if ((collision_check_edge(xx, yy+vspeed,sprite,Direction.UP,mask)&&vspeed<0) ||
		(collision_check_edge(xx,yy+vspeed,sprite,Direction.DOWN,mask)&&vspeed>0)) {
		yy = round(yy);
		if vspeed > 0 {
			while (!collision_check_edge(xx,yy,sprite, Direction.DOWN, mask))
			{
				yy++;
			}
		}
		else{
			while (!collision_check_edge(xx,yy,sprite, Direction.UP, mask)) {
				yy --;
			}
		}
		y = yy;
		vspeed = y_bouncy == true? -1*vspeed : 0;
	}
	
	/* 
	/ We check each corner to ensure there is no corner clipping.
	/ This was an issue.
	*/
	var l = edge_get_location(x,y,sprite,Direction.LEFT)+1;
	var u = edge_get_location(x,y,sprite,Direction.UP)+1;
	var r = edge_get_location(x,y,sprite,Direction.RIGHT)-1;
	var d = edge_get_location(x,y,sprite,Direction.DOWN)-1;
	
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
	
	//show_debug_message(grounded ? "Grounded" : "Ungrounded");

}