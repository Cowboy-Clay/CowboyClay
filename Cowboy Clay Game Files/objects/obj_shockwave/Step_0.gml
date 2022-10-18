if !global.paused {

image_xscale = direct == Direction.LEFT ? 1 : -1;

if timer >= lifetime {
	in_use = false;
	}

visible = in_use;

if in_use {
	var d = evaluate_distance();
	x = direct == Direction.LEFT ? x_start - d : x_start + d;
	y = y_start;
	
	if timer < 5 image_index = 0;
	else if timer < 10 image_index = 1;
	else image_index = 2;
	
	if place_meeting(x,y,obj_player_fighting) {
		var dir = direct;
		with (obj_player_fighting) {
			var stucko = dir == Direction.RIGHT ? collision_check_edge(x,y,spr_clay_n_collision, Direction.RIGHT, collision_mask) : collision_check_edge(x,y,spr_clay_n_collision, Direction.LEFT, collision_mask);
			while !stucko && place_meeting(x,y,obj_shockwave) {
				x += dir == Direction.RIGHT ? 1 : -1;
				stucko = dir == Direction.RIGHT ? collision_check_edge(x,y,spr_clay_n_collision, Direction.RIGHT, collision_mask) : collision_check_edge(x,y,spr_clay_n_collision, Direction.LEFT, collision_mask);
			}
		}
	}
	
	timer ++;
}
}
