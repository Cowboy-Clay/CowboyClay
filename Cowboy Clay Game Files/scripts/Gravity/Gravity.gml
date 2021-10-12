// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Gravity(){
	//gravity
	if !place_meeting(x,y, obj_Ground) && vspeed < max_gravity
	{
		vspeed += grav;
	}
	//Falling
	if vspeed < 0 
	{
		vspeed /= 1.7;
	}
}