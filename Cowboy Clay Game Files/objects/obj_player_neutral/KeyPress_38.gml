/// @description Insert description here
// You can write your code in this editor

if global.player_stance_switch_flag return;

global.player_stance_switch_flag = true;
instance_activate_object(obj_player_fighting);
obj_player_fighting.x = x;
obj_player_fighting.y = y;
obj_player_fighting.facing = facing;
obj_player_master.stance_change(stance.fighting);
instance_deactivate_object(id);