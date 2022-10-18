/// @description Insert description here
// You can write your code in this editor
if place_meeting(x,y,obj_player_fighting) && on{
	door.close_door();
	instance_destroy(id);
}