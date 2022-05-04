global.player_block_spark_lo_offset = [80,14];

if obj_player.facing == Direction.RIGHT {
	x = obj_player.x+global.player_block_spark_lo_offset[0];
	y = obj_player.y+global.player_block_spark_lo_offset[1];
}else {
	x = obj_player.x-global.player_block_spark_lo_offset[0];
	y = obj_player.y+global.player_block_spark_lo_offset[1];
}
