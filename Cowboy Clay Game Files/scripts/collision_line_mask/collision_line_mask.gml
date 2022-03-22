// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function collision_line_mask(x1, y1, x2, y2, mask, prec, notme) {
	for (var i = 0; i < array_length(mask); i++)
	{
		if collision_line(x1, y1, x2, y2, mask[i], prec, notme) return true;
	}
	return false;
}