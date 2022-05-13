if obj_player.current_state == PlayerState.KICK_SWING && place_meeting(x,y,obj_tile_coll) && !wallkick_cooldown {
	wallkick_cooldown = true;
	if obj_player.facing == Direction.LEFT {
		obj_player.hspeed = 5;
		obj_player.vspeed = -8;
	} else {
		obj_player.hspeed = -5;
		obj_player.vspeed = -8;
	}
	
	if instance_exists(obj_cam_position) {
		obj_cam_position.camera_shake(5,2,3);
	}
	
	if instance_exists(obj_player_sword) {
		if obj_player_sword.current_state == SwordState.STUCK_WALL_LEFT || obj_player_sword.current_state == SwordState.STUCK_WALL_RIGHT {
			if abs(obj_player_sword.x - obj_player.x) < 300 {
				obj_player_sword.to_kicked();
			}
		}
	}
}

if obj_player.current_state != PlayerState.KICK_SWING && wallkick_cooldown wallkick_cooldown = false;
