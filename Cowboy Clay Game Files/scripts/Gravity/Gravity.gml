function Gravity(accel, max){
	// If you are touching the ground
	if place_meeting(x,y,obj_Ground)
	{
		grounded = true; // Mark self as grounded
		if vspeed > 0 vspeed = 0; // Prevent any further downward movement
	}
	else
	{
		grounded = false;
		vspeed += accel;
	}
}