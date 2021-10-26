/// @description Code that is executed every frame for the player.

// Physics
Gravity();

// Basic controls
Run();
Jump();
AttackControls();

ReturnToIdleAnimation();
SwitchSwordAnimations();

if !instance_exists(obj_Sword) && sprite_index == spr_FrontSlash
{
	sprite_index = spr_SwordIdle;
}

// Plays jump sprite if not on ground
if(!place_meeting(x,y+1, obj_Ground)){
	if armed
		sprite_index = spr_JumpUp;
	else
		sprite_index = spr_DisarmedJumpUp;
}

turn_sprite();

invin_update();

//Collision with ground
if (place_meeting(x, y + vspeed, obj_Ground)){
		while place_meeting(x, y + vspeed, obj_Ground) {
			y -= 0.01;
		}
		y += vspeed;
		vspeed = 0;
		grounded = true;		
}
else
{
	grounded = false;
}

// Debugging code to respawn enemy
if(keyboard_check_pressed(ord("E")))
{
	instance_activate_object(obj_Enemy);
	obj_Enemy.armed = true;
}

EnemyCollision();