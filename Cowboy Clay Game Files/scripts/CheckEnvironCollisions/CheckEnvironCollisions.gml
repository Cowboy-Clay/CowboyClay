function CheckEnvironCollisions(){
	if place_meeting(x+hspeed, y, obj_Wall)
	{
		while place_meeting(x, y, obj_Wall) == false
		{
			x += sign(hspeed);
		}
		hspeed = 0;
	}
	
	if place_meeting(x, y+vspeed, obj_Ground)
	{
		while place_meeting(x, y, obj_Ground) == false
		{
			y += sign(vspeed);
		}
		vspeed = 0;
	}
}