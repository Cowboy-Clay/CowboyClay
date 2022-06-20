// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function take_hit_minor(){
	hp--;
	
	if variable_instance_exists(id, "hp_regen_timer") {
		hp_regen_timer = 0;
	}
	
	if hp <= 0 {
		take_hit_major();
		return;
	}
	
	take_hit_minor_personal();
}