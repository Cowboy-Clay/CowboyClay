x = obj_Moose.x;
y = obj_Moose.y;
image_xscale = obj_Moose.image_xscale;
image_yscale = obj_Moose.image_yscale;
sprite_index = GetMooseHurtBox();
image_index = obj_Moose.image_index;

if place_meeting(x,y,obj_player_hitbox) && obj_player_hitbox.sprite_index != spr_empty
{
	if !obj_enemy_blockbox.EnemyBlocking() 
		obj_Moose.MooseGetHit();
}