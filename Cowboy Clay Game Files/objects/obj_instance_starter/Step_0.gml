if place_meeting(x,y,obj_player_fighting) && !triggered
{
	triggered = true;
	layer_destroy(moose_silo_layer);
	
	moose_layer = layer_create(0, "Moose");
	instance_create_layer(7106,1389,moose_layer,obj_Moose);
	
	obj_elevator.state = elevator_state.broken;
	obj_elevator.y = 1545;
	
	obj_door_closer.on = true;
			obj_Moose.MooseWanderToIdle();
}