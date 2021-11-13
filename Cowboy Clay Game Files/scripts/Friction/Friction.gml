// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Friction(val){
	if hspeed > 0
	{
		hspeed -= val;
		if hspeed < 0 hspeed = 0;
		return;
	}
	else if hspeed < 0
	{
		hspeed += val;
		if hspeed > 0 hspeed = 0;
		return;
	}
	else hspeed = 0;
}