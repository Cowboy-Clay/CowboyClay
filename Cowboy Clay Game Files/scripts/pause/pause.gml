global.paused = false;
global.object_to_pause = [obj_player_fighting, obj_player_sword, obj_player_attackEffect, obj_elevator, obj_Moose, obj_wall_broken, obj_shockwave, obj_enemy_attackEffect, obj_enemy_sword, obj_moose_helmet, obj_moose_puppet, obj_player_projectile, obj_moose_projectile];

function pause(){
	global.paused = !global.paused;
	
	if global.paused {
		if instance_exists(obj_pause_menu) == false instance_create_depth(0,0,-500,obj_pause_menu);
	} else {
		if instance_exists(obj_pause_menu) instance_destroy(obj_pause_menu);
	}
	
	for (var i = 0; i < array_length(global.object_to_pause); i++){
		var _current_object = global.object_to_pause[i];
		var _object_count = instance_number(_current_object);
		for (var j = 0; j < _object_count; j++) {
			var _inst = instance_find(_current_object,j);
			with _inst{
				event_user(0);
			}
		}
	}
}