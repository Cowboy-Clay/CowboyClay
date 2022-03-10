// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function instance_nearest_mask(xPos, yPos, mask){
	r = noone;
	dr = noone;
	for(i = 0; i < array_length(mask); i++)
	{
		if !instance_exists(mask[i]) continue;
		t = instance_nearest(xPos, yPos, mask[i]);
		dt = point_distance(xPos, yPos, t.x, t.y);
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