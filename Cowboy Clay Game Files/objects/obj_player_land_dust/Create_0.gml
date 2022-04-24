collision_mask = [obj_tile_coll, obj_elevator];

if !place_meeting_mask(x,y,collision_mask) {
	instance_destroy(id);
}
