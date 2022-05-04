global.moose_block_spark_hi_offset = [42,-75];

if obj_Moose.facing == Direction.RIGHT {
	x = obj_Moose.x+global.moose_block_spark_hi_offset[0];
	y = obj_Moose.y+global.moose_block_spark_hi_offset[1];
}else {
	x = obj_Moose.x-global.moose_block_spark_hi_offset[0];
	y = obj_Moose.x+global.moose_block_spark_hi_offset[1];
}
