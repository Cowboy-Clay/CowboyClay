/// @description Insert description here
// You can write your code in this editor

MoveInbounds();

if place_meeting(x,y,obj_NewPlayer) && currentState == MooseState.PULLING && obj_NewPlayer.y < y
{
	show_debug_message("To state 1");
	obj_TestSceneController.ToState1();
}