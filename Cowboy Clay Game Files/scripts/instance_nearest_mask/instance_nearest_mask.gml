// Find the nearest instance of any of the given object
function instance_nearest_mask(xPos, yPos, mask){
	r = noone;	// r is the nearest object
	dr = noone;	// dr is the distance to that object
	for(i = 0; i < array_length(mask); i++)
	{
		if !instance_exists(mask[i]) continue;	// We don't need to check if none of this object exist
		t = instance_nearest(xPos, yPos, mask[i]);	// The nearest object of a given type
		dt = point_distance(xPos, yPos, t.x, t.y);	// The distance to that object
		// Record the object if it is either the first or the closest
		if r == noone
		{
			r = t;
			dr = dt;
		}
		else if dr > dt
		{
			r = t;
			dr = dt;
		}
	}

	return r;
}