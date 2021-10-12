/// @description Insert description here
// You can write your code in this editor
x = sword_target.x;
y = sword_target.y;
if my_sword_state == sword_state.stuck{
	sprite_index = protoswordstuck;
}
if !(place_meeting(x, y + vspeed, obj_Ground)) && my_sword_state == sword_state.flung{
	sprite_index = protospin;
}
