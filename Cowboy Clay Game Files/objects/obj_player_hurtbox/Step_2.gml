x = obj_player.x;
y = obj_player.y;
image_xscale = obj_player.image_xscale;
image_yscale = obj_player.image_yscale;
sprite_index = GetPlayerHurtBox();
image_index = obj_player_hitbox.image_index;

if place_meeting(x,y,obj_enemy_hitbox) && obj_player_hitbox.sprite_index != spr_empty obj_player.PlayerGetHit();