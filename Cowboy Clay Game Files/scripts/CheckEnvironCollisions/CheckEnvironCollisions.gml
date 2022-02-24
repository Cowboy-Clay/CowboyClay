function CheckEnvironCollisions(colSpr){
	collision_mask = [obj_Ground, obj_Wall, obj_plate, obj_door];

	// Wall collision
	for (i = 0; i < array_length(collision_mask); i++)
	{
		if collision_point(x+hspeed+(sprite_get_width(colSpr)/2*sign(hspeed)),y,collision_mask[i],true,true)
		{
			d = sign(hspeed);
			hspeed = 0;
			while collision_point(x+(sprite_get_width(colSpr)/2*d),y,collision_mask[i],true,true) == false
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
	
	
	collision_mask = [obj_Ground, obj_Wall, obj_plate, obj_door,obj_box];
	// Ground collision
	for(i = 0; i < array_length(collision_mask); i++)
	{
		if collision_point(x- (sprite_get_width(colSpr)/2-2),y+(sprite_get_height(colSpr)/2)+vspeed,collision_mask[i],true,true) ||
		   collision_point(x,y+(sprite_get_height(colSpr)/2)+vspeed,collision_mask[i],true,true) ||
		   collision_point(x+ (sprite_get_width(colSpr)/2-2),y+(sprite_get_height(colSpr)/2)+vspeed,collision_mask[i],true,true)
		{
			vspeed = 0;
			while !collision_point(x- (sprite_get_width(colSpr)/2-2),y+(sprite_get_height(colSpr)/2),collision_mask[i],true,true) &&
			      !collision_point(x,y+(sprite_get_height(colSpr)/2),collision_mask[i],true,true) &&
				  !collision_point(x+ (sprite_get_width(colSpr)/2-2),y+(sprite_get_height(colSpr)/2),collision_mask[i],true,true)
			{
				y++;
			}
		}
	}
}