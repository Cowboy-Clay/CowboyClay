/// @description Insert description here
// You can write your code in this editor

if global.player_stance_switch_flag return;

global.player_stance_switch_flag = true;
instance_activate_object(obj_player);
obj_player.x = x;
obj_player.y = y;
obj_player.facing = facing;
instance_deactivate_object(id);