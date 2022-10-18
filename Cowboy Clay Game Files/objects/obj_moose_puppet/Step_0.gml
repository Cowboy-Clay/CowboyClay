if global.paused return;

if activated {
	if instance_exists(obj_enemy_healthbar) == false instance_create_layer(0,0,layer, obj_enemy_healthbar);

	if obj_player_fighting.basic_attack_charge_timer > 0 || obj_player_fighting.sling_attack_charge_timer > 0 || obj_player_fighting.current_state == PlayerState.KICK_ANTI {
		var m = instance_create_layer(x,y,layer,obj_Moose);
		m.facing = Direction.RIGHT;
		instance_destroy(id);
	}
	
	switch(state) {
		case 0:
			sprite_index = spr_moose_slideAnti;
			timer ++;
			y += timer*2 - 25;
			x += 10;
			if y >= anchor_y {
				state = 4;
				timer = 0;
			}
			break;
		case 4:
			sprite_index = spr_moose_idle;
			timer ++;
			if timer > 30 {
				state = 1;
				timer = 0;
			}
			break;
		case 1:
			if sprite_index != spr_moose_burp_puppet sprite_index = spr_moose_burp_puppet;
			timer ++;
			if timer > 60 {
				state = 2;
				timer = 0;
			}
			break;
		case 2:
			if sprite_index != spr_moose_slideAnti sprite_index = spr_moose_slideAnti;
			timer ++;
			if timer > 45 {
				state = 3;
				timer = 0;
			}
			break;
		case 3:
			sprite_index = spr_moose_idle;
			timer ++;
			if timer > 60 {
				var m = instance_create_layer(x,y,layer,obj_Moose);
				m.facing = Direction.RIGHT;
				instance_destroy(id);
			}
			break;
	}
} else if x < obj_player_fighting.x && distance_to_object(obj_player_fighting) > 600 && distance_to_object(obj_player_fighting) < 6000 && abs(y - obj_player_fighting.y) < 200 {
	activated = true;
	if instance_exists(obj_music_controller) obj_music_controller.switch_track(Ferrymans_Fumble);
}
