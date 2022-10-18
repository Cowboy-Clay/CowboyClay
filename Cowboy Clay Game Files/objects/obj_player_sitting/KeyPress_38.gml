/// @description Insert description here
// You can write your code in this editor
if global.player_stance_switch_flag return;

global.player_stance_switch_flag = true;
instance_activate_object(obj_player_neutral);
obj_player_neutral.x = x;
obj_player_neutral.y = y;
obj_player_neutral.facing = facing;
obj_player_master.stance_change(stance.neutral);
instance_deactivate_object(id);