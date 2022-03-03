if place_meeting(x,y,obj_player) && !triggered
{
	triggered = true;
	layer_destroy(moose_silo_layer);
	
	obj_player_sword.currentState = SwordState.INACTIVE;
	moose_layer = layer_create(0, "Moose");
	
	instance_create_layer(6784,1389,moose_layer,obj_Moose);
	instance_create_layer(0,0,moose_layer, obj_enemy_attackEffect);
	instance_create_layer(0,0,moose_layer, obj_enemy_blockbox);
	instance_create_layer(0,0,moose_layer, obj_enemy_hitbox);
	instance_create_layer(0,0,moose_layer, obj_enemy_hurtbox);
	instance_create_layer(0,0,moose_layer,obj_enemy_sword);
	
	obj_elevator.state = elevator_state.broken;
	obj_elevator.y = 1523;
}

with(obj_player)
{
	if instance_exists(obj_Moose)
	{
		if place_meeting(x,y,obj_Moose)
		{
			obj_Moose.MooseWanderToIdle();
			obj_player_sword.PlayerSwordFling(5,4,5);
			with(obj_player_sword)
			{
				y-=20
			}
		}
	}
}