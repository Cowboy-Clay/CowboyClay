function CheckEnvironCollisions(colSpr, collMask){

	// Wall collision
	for (i = 0; i < array_length(collMask); i++)
	{
		if collision_point(x+hspeed+(sprite_get_width(colSpr)/2*sign(hspeed)),y-(sprite_get_height(colSpr)/2)+1,collMask[i],true,true) ||
			collision_point(x+hspeed+(sprite_get_width(colSpr)/2*sign(hspeed)),y+(sprite_get_height(colSpr)/2)-1,collMask[i],true,true)
		{
			d = sign(hspeed);
			hspeed = 0;
			while collision_point(x+(sprite_get_width(colSpr)/2*d),y-(sprite_get_height(colSpr)/2)+1,collMask[i],true,true) == false &&
				collision_point(x+(sprite_get_width(colSpr)/2*d),y+(sprite_get_height(colSpr)/2)-1,collMask[i],true,true) == false
			{
				x+=d;
			}
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
	for(i = 0; i < array_length(collMask); i++)
	{
		if collision_point(x- (sprite_get_width(colSpr)/2-2),y+(sprite_get_height(colSpr)/2)+vspeed,collMask[i],true,true) ||
		   collision_point(x,y+(sprite_get_height(colSpr)/2)+vspeed,collMask[i],true,true) ||
		   collision_point(x+ (sprite_get_width(colSpr)/2-2),y+(sprite_get_height(colSpr)/2)+vspeed,collMask[i],true,true)
		{
			vspeed = 0;
			while !collision_point(x- (sprite_get_width(colSpr)/2-2),y+(sprite_get_height(colSpr)/2),collMask[i],true,true) &&
			      !collision_point(x,y+(sprite_get_height(colSpr)/2),collMask[i],true,true) &&
				  !collision_point(x+ (sprite_get_width(colSpr)/2-2),y+(sprite_get_height(colSpr)/2),collMask[i],true,true)
			{
				y++;
			}
		}
	}
	
	// Ceiling collision
	// Don't have to check if we aren't moving up
	if vspeed >= 0 return;
	// If we will be touching a valid point at the end of movement
	if place_meeting_mask(x+hspeed,y+vspeed,collMask)
	{
		total_distance = point_distance(x,y,x+hspeed,y+vspeed);
		trans_scale = 0.5 / total_distance;
		// While we aren't colliding keep moving a little bit till we are
		while (!place_meeting_mask(x,y,collMask))
		{
			x += hspeed + trans_scale;
			y += vspeed + trans_scale;
		}
		// Once there stop moving vertically
		vspeed = 0;
	}
}