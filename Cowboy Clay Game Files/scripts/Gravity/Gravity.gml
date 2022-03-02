function Gravity(accel, max, colSpr, collMask){
	// If you are touching the ground
	for(i = 0; i < array_length(collMask); i++)
	{
		if collision_point(x- (sprite_get_width(colSpr)/2-2),y+(sprite_get_height(colSpr)/2),collMask[i],true,true) || collision_point(x+ (sprite_get_width(colSpr)/2-2),y+(sprite_get_height(colSpr)/2),collision_mask[i],true,true)
		{
			grounded = true;
			return;
		}
	}
		grounded = false;
		vspeed += accel;
}