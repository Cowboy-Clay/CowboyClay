/// @description Insert description here
// You can write your code in this editor
hitting = false;

currentFPI = 1;
frameCounter = 0;

function SpawnPlayerHitbox(Anim, FPI)
{
	if hitting return;
	sprite_index = Anim;
	currentFPI = FPI;
	frameCounter = 0;
	hitting = true;
}
function DespawnPlayerHitbox()
{
	hitting = false;
}