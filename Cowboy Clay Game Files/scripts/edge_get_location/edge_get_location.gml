function edge_get_location(xpos,ypos,sprite,edge){
	switch(edge){
		case Direction.LEFT:
			return xpos-sprite_get_xoffset(sprite);
			break;
		case Direction.RIGHT:
			return xpos-sprite_get_xoffset(sprite)+sprite_get_width(sprite);
			break;
		case Direction.UP:
			return ypos-sprite_get_yoffset(sprite);
			break;
		case Direction.DOWN:
			return ypos-sprite_get_yoffset(sprite)+sprite_get_height(sprite);
			break;
	}
	return 0;
}