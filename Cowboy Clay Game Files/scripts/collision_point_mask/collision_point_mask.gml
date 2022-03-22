function collision_point_mask(xpos, ypos, mask, prec, notme){
	for (var i = 0; i < array_length(mask); i++){
		if collision_point(xpos, ypos, mask[i], prec, notme) return true;
	}
	return false;
}