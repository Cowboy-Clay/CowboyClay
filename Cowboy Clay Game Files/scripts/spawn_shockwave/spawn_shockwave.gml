global.shockwave_object = obj_shockwave;

function spawn_shockwave(instance_depth, instance_x, instance_y, instance_direction, instance_lifetime, instance_distance, instance_curve){
	var s = noone;
	for (var c = 0; c < instance_number(global.shockwave_object); c++) {
		var d = instance_find(global.shockwave_object, c);
		if d == noone continue;
		if d.in_use == false {
			s = d;
			break;
		}
	}
	
	if s == noone {
		var i = instance_create_depth(instance_x, instance_y, instance_depth, global.shockwave_object);
		i.initiate(i.x, i.y, instance_direction, instance_lifetime, instance_distance, instance_curve);
	} else {
		show_debug_message("Attempting to reuse shockwave");
		s.initiate(instance_x, instance_y, instance_direction, instance_lifetime, instance_distance, instance_curve);
	}
}