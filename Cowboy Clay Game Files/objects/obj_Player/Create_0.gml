frict_value = 0.5;
h_accel = 1.3;
jump_accel = 17.5;
grav = 0.95;
max_velocity = 20;
max_gravity = 30;
max_vertical_velocity = 30;
attacking = false;
invin = false;
invin_timer = 0;
attack_disallowed = false;

// Controls left and right movement
function Run()
{
	// Left movement and animation
	if keyboard_check(vk_left) && !keyboard_check(vk_right) && sprite_index != spr_FrontSlash
	{
		// Adjusts velocity
		hspeed -= h_accel;
		// Maxes out velocity
		if hspeed < -max_velocity { hspeed = -max_velocity; }
 
		// Assigns different running animations based on armed status
		if armed { sprite_index = spr_Run; }
		else { sprite_index = spr_RunDisarmed; }
	}
	// Right movement and animation
	else if keyboard_check(vk_right) && !keyboard_check(vk_left) && sprite_index != spr_FrontSlash
	{
		// Adjusts velocity
		hspeed += h_accel;
		// Maxes out velocity
		if hspeed > max_velocity { hspeed = max_velocity; }
		
		// Assigns different running animations based on armed status
		if armed { sprite_index = spr_Run; }
		else { sprite_index = spr_RunDisarmed; }
	}
	
	if place_meeting(x + hspeed, y, obj_Wall) 
	{
		//hspeed = 0;
	}
	
	if (!(keyboard_check(vk_left) || keyboard_check(vk_right))) || sprite_index == spr_FrontSlash
		frict();
	zero_velocity();
}

// Controls jumping
function Jump(){
	// If you will reach the ground this frame and you press X you jump
	if (Grounded() || PredictiveGrounded())  && keyboard_check_pressed(ord("X"))
	{
		vspeed = -jump_accel;
	}
	
	// If you are not holding the X button and are moving up your speed is cut
	if !keyboard_check(ord("X")) && vspeed < 0 
	{
		vspeed /= 1.7;
	}
}

// Controls attacks
function AttackControls(){	
	// If you press Z and are armed you attack
	if keyboard_check_pressed(ord("Z")) && armed && !attack_disallowed && !instance_exists(obj_Sword)
	{
		instance_activate_object(obj_Sword); // Activates the sword object
		obj_Sword.Reset(); // Gets the sword to swing
		sprite_index = spr_FrontSlash; // Plays swords swing animation
	}
	
	// If the player has been prevented from attacking for any reason
	if attack_disallowed attack_disallowed = false;
}

// Causes the player to get knockedback
function Knockback(enemy_x){
//Collision Between Player and Enemy Sword, if invincibility is inactive
		// Knockback velocity
		hspeed += 30 * sign(obj_Player.x - enemy_x);
		vspeed -= max_vertical_velocity;
		
		if hspeed > max_velocity hspeed = max_velocity;
		if hspeed < -max_velocity hspeed = -max_velocity;
		if vspeed > max_vertical_velocity vspeed = max_vertical_velocity;
		if vspeed < -max_vertical_velocity vspeed = -max_vertical_velocity;
		
		if x + hspeed > maxX
		{
			x = maxX;
			hspeed = 0;
		}
		if x + hspeed < minX
		{
			x = minX;
			hspeed = 0;
		}
}

// Called to hurt the player
function Hurt(enemy_x)
{
	// Knocks the player back and causes you to be disarmed
	Knockback(enemy_x);
	// Disarms the player
	armed = false;
	// Activates the sword object and makes it go flying
	instance_activate_object(obj_Sword);
	// Fling sword
	obj_Sword.Flung(enemy_x);
	// Sets you to be invinsible
	invin = true;
	invin_timer = 30;
}

// Called when colliding with the sword to pick it up
function Retrieve_Sword()
{
	// Rearm player
	armed = true;
	// Prevent the player from attacking the same frame they pick up their sword
	attack_disallowed = true;
}

// Used to turn the player sprite left or right
function turn_sprite()
{
	// If the player is facing left and they are moving right
	// or if the player is facing right and moving left
	if (image_xscale < 0 && hspeed > 0) || (image_xscale  > 0 && hspeed < 0)
	{
		// Flip the sprite
		image_xscale *= -1;
	}
}

// Slows the players horizontal movement
function frict()
{
	hspeed *= frict_value;
}

// Allows the players horizontal velocity to reach 0
function zero_velocity()
{
	if (!keyboard_check(vk_left) && !keyboard_check(vk_right)) && (hspeed < 0 && hspeed > -frict_value || hspeed > 0 && hspeed < frict_value)
	{
		hspeed = 0;
	}
}

// Progresses the timer for invinsibility
function invin_update()
{
	if invin_timer > 0
	{
		invin_timer--;
	}
	if invin_timer <= 0 
	{
		invin = false;
	}
}

function EnemyCollision()
{
	// If the enemy exists and they will collide with the player this frame
	if instance_exists(obj_Moose) && place_meeting(x, y, obj_Moose)
	{
		// Knockback the player
		Knockback(obj_Moose.x - 150);
		
		// If the test scene is going and the player is higher than the enemy
		if instance_exists(obj_TestSceneController) && obj_TestSceneController.state == 0 && y < obj_Moose.y
		{
			// Move to next step
			obj_TestSceneController.ToState1();
		}
	}
}

function ReturnToIdleAnimation()
{
	if keyboard_check(vk_left) || keyboard_check(vk_right) return;
	
	if sprite_index == spr_Run
	{
		sprite_index = spr_SwordIdle;
	}
	if sprite_index == spr_RunDisarmed
	{
		sprite_index = spr_Idle;
	}
	
	if sprite_index == spr_JumpUp && Grounded()
		sprite_index = spr_SwordIdle;
	if sprite_index == spr_DisarmedJumpUp && Grounded()
		sprite_index = spr_Idle;
}

function SwitchSwordAnimations()
{
	if(armed)
	{
		if sprite_index == spr_Idle sprite_index = spr_SwordIdle;
		if sprite_index == spr_RunDisarmed sprite_index = spr_Run;
		if sprite_index == spr_DisarmedJumpUp sprite_index = spr_JumpUp;
	}
	else
	{
		if sprite_index == spr_SwordIdle sprite_index = spr_Idle;
		if sprite_index == spr_Run sprite_index = spr_RunDisarmed;
		if sprite_index == spr_JumpUp sprite_index = spr_DisarmedJumpUp;
	}
}

function Grounded()
{
	return collision_point(x-62, y+64, obj_Ground, false, false) || collision_point(x+62, y+64, obj_Ground, false, false);
}

function PredictiveGrounded()
{
	return collision_point(x-62, y+64+vspeed, obj_Ground, false, false) || collision_point(x+62, y+64+vspeed, obj_Ground, false, false);
}

function MoveInbounds()
{
	if x + hspeed > maxX
	{
		x = maxX;
		hspeed = 0;
	}
	if x + hspeed < minX
	{
		x = minX;
		hspeed = 0;
	}
	if y + vspeed > maxY
	{
		y = maxY;
		vspeed = 0;
	}
	if y + vspeed < minY
	{
		y = minY;
		vspeed = 0;
	}
}