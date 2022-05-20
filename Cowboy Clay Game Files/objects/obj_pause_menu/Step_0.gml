/// @description Insert description here
// You can write your code in this editor

if input_check_pressed(input_action.down) {
	next();
}
if input_check_pressed(input_action.up) {
	previous();
}
if input_check_pressed(input_action.jump) || input_check_pressed(input_action.attack) ||
input_check_pressed(input_action.block) || input_check_pressed(input_action.face) ||
input_check_pressed(input_action.kick) || input_check_pressed(input_action.sling){
	select();
}
