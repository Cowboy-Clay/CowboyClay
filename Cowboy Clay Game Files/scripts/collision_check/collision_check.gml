function collision_check(sprite, mask, x_bouncy, y_bouncy){
	var xx = x;
	var yy = y;
	
	show_debug_message("hspeed = " + string(hspeed));
	show_debug_message("vspeed = " + string(vspeed));
	
	if hspeed == 0 {}
	else if (place_meeting_mask(xx+hspeed, yy, mask)) &&
		((collision_check_edge(xx+hspeed,yy,sprite,Direction.LEFT,mask)&&hspeed<0) ||
		(collision_check_edge(xx+hspeed,yy,sprite,Direction.RIGHT,mask)&&hspeed>0)) {
		xx = round(xx);
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
	
	if vspeed == 0 {}
	else if (place_meeting_mask(xx, yy+vspeed, mask)) &&
		((collision_check_edge(xx, yy+vspeed,sprite,Direction.UP,mask)&&vspeed<0) ||
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
	
	grounded = collision_check_edge(x+hspeed, y+vspeed, sprite, Direction.DOWN, mask);
	
	show_debug_message(grounded ? "Grounded" : "Ungrounded");

}