// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function knock_away_from(obj, x1,y1,force) {
	var v = vector_away_normal(obj.x,obj.y,x1,y1);
	obj.hspeed = v[0]*force;
	obj.vspeed = v[1]*force;
}