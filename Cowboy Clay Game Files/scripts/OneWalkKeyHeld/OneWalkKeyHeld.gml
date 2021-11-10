// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function OneWalkKeyHeld(){
	if keyboard_check(vk_left) && !keyboard_check(vk_right)
		return true;
	else if keyboard_check(vk_right) && !keyboard_check(vk_left)
		return true;
	else
		return false;
}