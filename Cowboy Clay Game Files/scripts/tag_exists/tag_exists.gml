// Finds if an instance exists with the given tag
function tag_exists(tag){
	var ids = tag_get_asset_ids(tag, asset_object);
	if array_length(ids) == 0 return false;
	for (var i = 0; i < array_length(ids); i++) {
		if instance_exists(ids[i]) return true;
	}
	return false;
}