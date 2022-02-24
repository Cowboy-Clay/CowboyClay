function Gravity(accel, max, colSpr){
	collision_mask = [obj_Ground, obj_Wall, obj_plate, obj_door,obj_box];
	// If you are touching the ground
	for(i = 0; i < array_length(collision_mask); i++)
	{
		if collision_point(x- (sprite_get_width(colSpr)/2-2),y+(sprite_get_height(colSpr)/2),collision_mask[i],true,true) || collision_point(x+ (sprite_get_width(colSpr)/2-2),y+(sprite_get_height(colSpr)/2),collision_mask[i],true,true)
		{
			grounded = true;
			return;
		}
	}
		grounded = false;
		vspeed += accel;
}