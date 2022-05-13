offset = 100;

lifetime = 30;

if instance_exists(obj_player) {
	x = obj_player.x;
	y = obj_player.y;
	if obj_player.facing == Direction.LEFT x -= offset;
}
