// Returns a given edge based on a given sprite at a given position
function edge_get_location(xpos,ypos,sprite){
	var l, r, u ,d;
	
	l = image_xscale == -1 ? xpos+sprite_get_xoffset(sprite)-sprite_get_width(sprite) : xpos-sprite_get_xoffset(sprite);
	
	r = image_xscale == -1 ? xpos+sprite_get_xoffset(sprite) : xpos-sprite_get_xoffset(sprite)+sprite_get_width(sprite);
	
	u = image_yscale == -1 ? ypos+sprite_get_yoffset(sprite)-sprite_get_height(sprite) : ypos-sprite_get_yoffset(sprite);
	
	d = image_yscale == -1 ? ypos+sprite_get_yoffset(sprite) : ypos-sprite_get_yoffset(sprite)+sprite_get_height(sprite);
	
	return [u,r,d,l];
}