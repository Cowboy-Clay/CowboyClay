if !global.paused{
if distance_to_object(obj_player_fighting) > sqrt(1248*1248+1088*1088) return;

check_mounted();

if mounted && ((obj_player_fighting.facing == Direction.LEFT && image_xscale == 1)||(obj_player_fighting.facing == Direction.RIGHT && image_xscale == -1)) && obj_player_fighting.current_state == PlayerState.BASIC_ATTACK_SWING && cooldown_timer <= 0
{
	get_hit();
}
if cooldown_timer >= 0 cooldown_timer --;

switch(current_state)
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
		
		if audio_is_playing(sfx_elevator_falling) == false audio_play_sound(sfx_elevator_falling,25,true);
		if audio_is_playing(sfx_elevator_rising) audio_stop_sound(sfx_elevator_rising);
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
		if audio_is_playing(sfx_elevator_rising) == false audio_play_sound(sfx_elevator_rising,25,true);
		if audio_is_playing(sfx_elevator_falling) audio_stop_sound(sfx_elevator_falling);
		break;
	case elevator_state.holding:
		hold();
		if audio_is_playing(sfx_elevator_rising) audio_stop_sound(sfx_elevator_rising);
		if audio_is_playing(sfx_elevator_falling) audio_stop_sound(sfx_elevator_falling);
		break;
	case elevator_state.sitting:
		sit();
		if audio_is_playing(sfx_elevator_rising) audio_stop_sound(sfx_elevator_rising);
		if audio_is_playing(sfx_elevator_falling) audio_stop_sound(sfx_elevator_falling);
		break;
}

while place_meeting(x,y+1,obj_player_fighting) && mounted
{
	obj_player_fighting.y --;
}
}
