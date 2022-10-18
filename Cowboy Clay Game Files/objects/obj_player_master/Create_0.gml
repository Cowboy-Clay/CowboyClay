/// @description Insert description here
// You can write your code in this editor

fighting_stance = instance_create_layer(x, y, layer, obj_player_fighting);
neutral_stance = instance_create_layer(x, y, layer, obj_player_neutral);
sitting_stance = instance_create_layer(x, y, layer, obj_player_sitting);

current_stance = stance.neutral;
if starting_stance == "fighting" current_stance = stance.fighting;
else if starting_stance == "sitting" current_stance = stance.sitting;
if current_stance != stance.neutral instance_deactivate_object(neutral_stance);
if current_stance != stance.fighting instance_deactivate_object(fighting_stance);
if current_stance != stance.sitting instance_deactivate_object(sitting_stance);

function stance_change(s) {
	current_stance = s;
}