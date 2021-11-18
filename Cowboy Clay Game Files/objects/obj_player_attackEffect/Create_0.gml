/// @description Insert description here
// You can write your code in this editor
currentFPI = 1;
frameCounter = 0;

function ShowPlayerAttack(Anim, FPI)
{
	if visible return;
	sprite_index = Anim;
	currentFPI = FPI;
	frameCounter = 0;
	visible = true;
}
function HidePlayerAttack()
{
	visible = false;
}