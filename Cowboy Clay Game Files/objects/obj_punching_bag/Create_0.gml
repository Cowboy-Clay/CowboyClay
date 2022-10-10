/// @description Insert description here
// You can write your code in this editor
collision_mask = [obj_wall_breakable, obj_Ground, obj_Wall, obj_plate, obj_door,obj_box, obj_elevator, obj_tile_coll, obj_house, obj_tallHouse, obj_longHouse, obj_midHouse];

top_trigger = false;
mid_trigger = false;
bot_trigger = false;

top_percent = .45;
bot_percent = .45;

if top_percent + bot_percent > 1 {
	var tot = top_percent + bot_percent;
	top_percent = top_percent / tot;
	bot_percent = bot_percent / tot;
}