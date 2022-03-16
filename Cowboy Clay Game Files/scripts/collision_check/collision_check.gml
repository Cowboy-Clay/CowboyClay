function collision_check(sprite, mask){
	var xx = x;
	var yy = y;
	
	if (place_meeting_mask(xx+hspeed, yy, mask)) &&
		((collision_check_edge(xx+hspeed,yy,sprite,Direction.LEFT,mask)&&hspeed<0) ||
		(collision_check_edge(xx+hspeed,yy,sprite,Direction.RIGHT,mask)&&hspeed>0)) {
		xx = round(xx);
		while (!place_meeting_mask(xx,yy,mask)) {
			xx += sign(hspeed);
		}
		x = xx;
		hspeed = 0;
	}
	
	if (place_meeting_mask(xx, yy+vspeed, mask)) &&
		((collision_check_edge(xx, yy+vspeed,sprite,Direction.UP,mask)&&vspeed<0) ||
		(collision_check_edge(xx,yy+vspeed,sprite,Direction.DOWN,mask)&&vspeed>0)) {
		yy = round(yy);
		while (!place_meeting_mask(xx, yy, mask)) {
			yy += sign(vspeed);
		}
		y = yy;
		vspeed = 0;
	}
}