layerID = layer_get_id(tilemap_name);
tiles = layer_tilemap_get_id(layerID);

starting_x = tilemap_get_x(tiles) - 150;
starting_y = tilemap_get_y(tiles) + 24;
increment = tilemap_get_tile_width(tiles);
width = tilemap_get_width(tiles);
height = tilemap_get_height(tiles);



for (i = 0; i < width; i ++)
{
	for (j = 0; j < height; j++)
	{
		if tilemap_get_at_pixel(tiles, starting_x + i*increment, starting_y + j*increment)
		{
			instance_create_depth(starting_x + i*increment, starting_y + j*increment, 0, obj_tile_coll);
		}
	}
}