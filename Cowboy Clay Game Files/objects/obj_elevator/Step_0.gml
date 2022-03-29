if distance_to_object(obj_player) > sqrt(1248*1248+1088*1088) return;

check_mounted();

if mounted && ((obj_player.facing == Direction.LEFT && image_xscale == 1)||(obj_player.facing == Direction.RIGHT && image_xscale == -1)) && obj_player.current_state == PlayerState.BASIC_ATTACK_SWING && cooldown_timer <= 0
{
	get_hit();
}
if cooldown_timer >= 0 cooldown_timer --;

switch(state)
{
	case elevator_state.falling:
		animation_counter --;
		if animation_counter <= 0{
			animation_counter = frames_per_image_down;
			image_index --;
			if image_index < 0{
				image_index = image_number-1;
			}
		}
		fall();
		break;
	case elevator_state.rising:
		rise();
		animation_counter++;
		if animation_counter >= frames_per_image_up{
			animation_counter = 0;
			image_index ++;
			if image_index >= image_number{
				image_index = 0;
			}
		}
		break;
	case elevator_state.holding:
		hold();
		break;
	case elevator_state.sitting:
		sit();
		break;
}

while place_meeting(x,y+1,obj_player) && mounted
{
	obj_player.y --;
}