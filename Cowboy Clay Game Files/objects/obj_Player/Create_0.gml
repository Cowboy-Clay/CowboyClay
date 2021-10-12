// Controls left and right movement
function Run()
{
	// Left movement and animation
	if keyboard_check(vk_left) && !keyboard_check(vk_right)
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
	else if keyboard_check(vk_right) && !keyboard_check(vk_left)
	{
		// Adjusts velocity
		hspeed += h_accel;
		// Maxes out velocity
		if hspeed > max_velocity { hspeed = max_velocity; }
		
		// Assigns different running animations based on armed status
		if armed { sprite_index = spr_Run; }
		else { sprite_index = spr_RunDisarmed; }
	}
	
	frict();
	zero_velocity();
}

// Controls jumping
function Jump(){
	// If you will reach the ground this frame and you press X you jump
	if (place_meeting(x, y + vspeed, obj_Ground)) && keyboard_check_pressed(ord("X"))
	{
		vspeed -= jump_accel;
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
	if keyboard_check_pressed(ord("Z")) && armed
	{
		instance_activate_object(obj_Sword); // Activates the sword object
		obj_Sword.Reset(); // Gets the sword to swing
		sprite_index = spr_FrontSlash; // Plays swords swing animation
	}
}

// Causes the player to get knockedback
function Knockback(enemy_x){
//Collision Between Player and Enemy Sword, if invincibility is inactive
		// Knockback velocity
		hspeed += 30 * sign(obj_Player.x - enemy_x);
		vspeed -= 50;
}

// Called to hurt the player
function Hurt(enemy_x)
{
	// Knocks the player back and causes you to be disarmed
	Knockback(enemy_x);
	armed = false;
	// Activates the sword object and makes it go flying
	instance_activate_object(obj_Sword);
	obj_Sword.Flung(enemy_x);
	// Sets you to be invinsible
	invin = true;
	invin_timer = 30;
}

// Called when colliding with the sword to pick it up
function Retrieve_Sword()
{
	
	armed = true;
}

// Used to turn the player sprite left or right
function turn_sprite()
{
	if image_xscale < 0 && hspeed > 0
	{
		image_xscale *= -1;
	}
	else if image_xscale > 0 && hspeed < 0
	{
		image_xscale *= -1;
	}
}

// Slows the players horizontal movement
function frict()
{
	if hspeed >= frict_value
	{
		hspeed -= frict_value;
	}
	if hspeed <= -frict_value
	{
		 hspeed += frict_value;
	}
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