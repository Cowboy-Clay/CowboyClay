function collision_check(sprite, mask, x_bouncy, y_bouncy){
	var xx = x;
	var yy = y;
	
	show_debug_message("hspeed = " + string(hspeed));
	show_debug_message("vspeed = " + string(vspeed));
	
	if hspeed == 0 {}
	else if ((collision_check_edge(xx+hspeed,yy,sprite,Direction.LEFT,mask)&&hspeed<0) ||
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
	
	grounded = collision_check_edge(x+hspeed, y+vspeed, sprite, Direction.DOWN, mask);
	
	show_debug_message(grounded ? "Grounded" : "Ungrounded");

}