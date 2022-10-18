offset = 100;

lifetime = 30;

if instance_exists(obj_player_fighting) {
	x = obj_player_fighting.x;
	y = obj_player_fighting.y;
	if obj_player_fighting.facing == Direction.LEFT x -= offset;
}
