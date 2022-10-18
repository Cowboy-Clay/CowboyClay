global.player_block_spark_lo_offset = [80,14];

target = noone;
if instance_exists(obj_player_neutral) target = obj_player_neutral;
else if instance_exists(obj_player_sitting) target = obj_player_sitting;
else if instance_exists(obj_player_fighting) target = obj_player_fighting;
else return;

if target.facing == Direction.RIGHT {
	x = target.x+global.player_block_spark_lo_offset[0];
	y = target.y+global.player_block_spark_lo_offset[1];
}else {
	x = target.x-global.player_block_spark_lo_offset[0];
	y = target.y+global.player_block_spark_lo_offset[1];
}
