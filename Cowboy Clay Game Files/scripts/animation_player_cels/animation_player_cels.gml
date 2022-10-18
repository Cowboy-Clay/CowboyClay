// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function animation_player_cels(sprite_name){
	if typeof(sprite_name) != "string" return noone;
	
	if sprite_name == "spr_clay_f_idle" {
		var a = [spr_clay_f_idle_body, ["draw_shirt", spr_clay_f_idle_shirt], ["draw_shoes", spr_clay_f_idle_shoes], ["!draw_hat", spr_clay_f_idle_head], ["draw_hat", spr_clay_f_idle_hat]];
		return a;
	}
}