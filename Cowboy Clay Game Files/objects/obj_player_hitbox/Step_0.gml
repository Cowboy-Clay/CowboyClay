target = noone;
if instance_exists(obj_player_neutral) target = obj_player_neutral;
else if instance_exists(obj_player_sitting) target = obj_player_sitting;
else if instance_exists(obj_player_fighting) target = obj_player_fighting;
else return;

if target.current_stance != stance.fighting return;

if target.current_state == PlayerState.KICK_SWING && (place_meeting(x,y,obj_tile_coll) || place_meeting(x,y,obj_Moose)) && !wallkick_cooldown {
	wallkick_cooldown = true;
	if target.facing == Direction.LEFT {
		target.hspeed = 5;
		target.vspeed = -8;
	} else {
		target.hspeed = -5;
		target.vspeed = -8;
	}
	
	if instance_exists(obj_cam_position) {
		obj_cam_position.camera_shake(5,2,3);
	}
	
	if instance_exists(obj_player_sword) {
		if obj_player_sword.current_state == SwordState.STUCK_WALL_LEFT || obj_player_sword.current_state == SwordState.STUCK_WALL_RIGHT {
			if abs(obj_player_sword.x - target.x) < 300 {
				obj_player_sword.to_kicked();
			}
		}
	}
}

if target.current_state != PlayerState.KICK_SWING && wallkick_cooldown wallkick_cooldown = false;
