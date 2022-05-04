global.player_block_spark_hi_offset = [29,-41];

if obj_player.facing == Direction.RIGHT {
	x = obj_player.x+global.player_block_spark_hi_offset[0];
	y = obj_player.y+global.player_block_spark_hi_offset[1];
}else {
	x = obj_player.x-global.player_block_spark_hi_offset[0];
	y = obj_player.y+global.player_block_spark_hi_offset[1];
}
