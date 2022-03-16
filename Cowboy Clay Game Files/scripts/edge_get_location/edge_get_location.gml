function edge_get_location(xpos,ypos,sprite,edge){
	switch(edge){
		case Direction.LEFT:
			if image_xscale == -1 return xpos+sprite_get_xoffset(sprite)-sprite_get_width(sprite);
			return xpos-sprite_get_xoffset(sprite);
			break;
		case Direction.RIGHT:
			if image_xscale == -1 return xpos+sprite_get_xoffset(sprite);
			return xpos-sprite_get_xoffset(sprite)+sprite_get_width(sprite);
			break;
		case Direction.UP:
			if image_yscale == -1 return ypos+sprite_get_yoffset(sprite)-sprite_get_height(sprite);
			return ypos-sprite_get_yoffset(sprite);
			break;
		case Direction.DOWN:
			if image_yscale == -1 return ypos+sprite_get_yoffset(sprite);
			return ypos-sprite_get_yoffset(sprite)+sprite_get_height(sprite);
			break;
	}
	return 0;
}