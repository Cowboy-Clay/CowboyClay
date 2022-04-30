// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function OneWalkKeyHeld(){
	if button_check(buttons.left) && !button_check(buttons.right)
		return true;
	else if !button_check(buttons.left) && button_check(buttons.right)
		return true;
	else
		return false;
}