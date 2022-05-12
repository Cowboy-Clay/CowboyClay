// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function OneWalkKeyHeld(){
	if input_check(input_action.left) && !input_check(input_action.right)
		return true;
	else if !input_check(input_action.left) && input_check(input_action.right)
		return true;
	else
		return false;
}