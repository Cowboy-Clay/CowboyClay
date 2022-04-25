sprite_1 = spr_mech_breakableWallPiece1;
sprite_2 = spr_mech_breakableWallPiece2;

half = 1;

grav = 0.75;

lifetime = 300;

rot_speed = random_range(-15,15);
if abs(rot_speed) < 5 {
	rot_speed = random_range(-15,15);
}
