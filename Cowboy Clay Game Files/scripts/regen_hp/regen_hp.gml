// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function regen_hp(){
	if variable_instance_exists(id, "hp_regen_timer") == false return;
	if variable_instance_exists(id, "hp_regen_time_short") == false return;
	if variable_instance_exists(id, "hp_regen_time_long") == false return;
	
	if hp_regen_timer == hp_regen_time_long {
		hp = hp + 1> max_hp ? max_hp : hp + 1;
	} else if hp_regen_timer > hp_regen_time_long {
		if (hp_regen_timer - hp_regen_time_long) % hp_regen_time_short == 0 {
			hp = hp + 1> max_hp ? max_hp : hp + 1;
		}
	}
	hp_regen_timer ++;
}