// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function vector_away_normal(x1,y1,x2,y2){
	var dx = x1-x2;
	var dy = y1-y2;
	var dh = sqrt(dx*dx+dy*dy);
	var t = 1/dh;
	var dxn = dx*t;
	var dyn = dy*t;
	return [dxn,dyn];
}