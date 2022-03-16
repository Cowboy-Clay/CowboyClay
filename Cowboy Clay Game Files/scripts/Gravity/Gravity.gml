function Gravity(accel, max, colSpr, collMask){
	// If you are touching the ground
		if collision_check_edge(x,y,colSpr, Direction.DOWN, collMask)
		{
			//grounded = true;
			//return;
		}
		//grounded = false;
		vspeed += accel;
}