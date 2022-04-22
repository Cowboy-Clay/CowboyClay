layerID = layer_get_id(tilemap_name);
tiles = layer_tilemap_get_id(layerID);

starting_x = tilemap_get_x(tiles) + tilemap_x_offset;
starting_y = tilemap_get_y(tiles) + tilemap_y_offset;
tile_height = tilemap_get_tile_height(tiles);
tile_width = tilemap_get_tile_width(tiles);
tile_height_multi = tile_height / 40;
tile_width_multi = tile_width / 40;
increment = tilemap_get_tile_width(tiles);
width = tilemap_get_width(tiles);
height = tilemap_get_height(tiles);



for (i = 0; i < width; i ++)
{
	for (j = 0; j < height; j++)
	{
		if tilemap_get_at_pixel(tiles, starting_x + i*increment, starting_y + j*increment)
		{
			var inst = instance_create_depth(starting_x + i*increment, starting_y + j*increment, 0, obj_tile_coll);
			inst.image_xscale = 1 * tile_width_multi;
			inst.image_yscale = 1 * tile_height_multi;
		}
	}
}