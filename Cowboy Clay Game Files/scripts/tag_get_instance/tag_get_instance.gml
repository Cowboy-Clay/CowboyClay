// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function tag_get_instance(tag, n){
	var counter = n;
	var ids = tag_get_asset_ids(tag, asset_object);
	if array_length(ids) == 0 return noone;
	for (var i = 0; i < array_length(ids); i++) {
		if instance_exists(ids[i]) {
			for (var j = 0; j < instance_number(ids[i]); j++){
				if counter == 0 return instance_find(ids[i], j);
				else {
					counter --;
				}
			}
		}
	}
	return noone;
}