function CheckEnvironCollisions(colSpr){
	// Wall collision
	if place_meeting(x+hspeed, y, obj_Wall)
	{
		while place_meeting(x, y, obj_Wall) == false
		{
			x += sign(hspeed);
		}
		if hspeed > 0
		{
			if collision_point(x+(sprite_get_width(colSpr)/2),y,obj_Wall,false,true)
				hspeed = 0;
		}
		else if hspeed < 0
		{
			if collision_point(x-(sprite_get_width(colSpr)/2),y,obj_Wall,false,true)
				hspeed = 0;
		}
	}
	
	if place_meeting(x+hspeed, y, obj_Moose)
	{
		while place_meeting(x, y, obj_Moose) == false
		{
			x += sign(hspeed);
		}
		if hspeed > 0
		{
			if collision_point(x+(sprite_get_width(colSpr)/2),y,obj_Moose,false,true)
				hspeed = 0;
		}
		else if hspeed < 0
		{
			if collision_point(x-(sprite_get_width(colSpr)/2),y,obj_Moose,false,true)
				hspeed = 0;
		}
	}
	
	// Ground collision
	if place_meeting(x, y+vspeed, obj_Ground)
	{
		while place_meeting(x, y, obj_Ground) == false
		{
			y += sign(vspeed);
		}
		vspeed = 0;
	}
}