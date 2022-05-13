if instance_exists(obj_Moose)
{
	var _phase = obj_Moose.get_phase();

	if _phase == 1 {
		var first_healthbar_percent = obj_Moose.hp / obj_Moose.max_hp;
		var second_healthbar_percent = 1;
		var third_healthbar_percent = 1;
	} else if _phase == 2 {
		var first_healthbar_percent = 0;
		var second_healthbar_percent = obj_Moose.hp / obj_Moose.max_hp;
		var third_healthbar_percent = 1;
	} else if _phase == 3 {
		var first_healthbar_percent = 0;
		var second_healthbar_percent = 0;
		var third_healthbar_percent = obj_Moose.hp / obj_Moose.max_hp;
	}
	
	if obj_Moose.current_state == MooseState.DEAD {
		var first_healthbar_percent = 0;
		var second_healthbar_percent = 0;
		var third_healthbar_percent = 0;
	}
}else {
	var first_healthbar_percent = 1;
		var second_healthbar_percent = 1;
		var third_healthbar_percent = 1;
}

if third_healthbar_visual_percentage < third_healthbar_percent {
	third_healthbar_visual_percentage = third_healthbar_visual_percentage + max_change_per_frame > third_healthbar_percent ? third_healthbar_percent : third_healthbar_visual_percentage + max_change_per_frame;
} else if second_healthbar_visual_percentage < second_healthbar_percent {
	second_healthbar_visual_percentage = second_healthbar_visual_percentage + max_change_per_frame > second_healthbar_percent ? second_healthbar_percent : second_healthbar_visual_percentage + max_change_per_frame;
} else if first_healthbar_visual_percentage < first_healthbar_percent {
	first_healthbar_visual_percentage = first_healthbar_visual_percentage + max_change_per_frame > first_healthbar_percent ? first_healthbar_percent : first_healthbar_visual_percentage + max_change_per_frame;
} else if first_healthbar_visual_percentage > first_healthbar_percent {
	first_healthbar_visual_percentage = first_healthbar_visual_percentage - max_change_per_frame < first_healthbar_percent ? first_healthbar_percent : first_healthbar_visual_percentage - max_change_per_frame;
} else if second_healthbar_visual_percentage > second_healthbar_percent {
	second_healthbar_visual_percentage = second_healthbar_visual_percentage - max_change_per_frame < second_healthbar_percent ? second_healthbar_percent : second_healthbar_visual_percentage - max_change_per_frame;
} else if third_healthbar_visual_percentage > third_healthbar_percent {
	third_healthbar_visual_percentage = third_healthbar_visual_percentage - max_change_per_frame < third_healthbar_percent ? third_healthbar_percent : third_healthbar_visual_percentage - max_change_per_frame;
}
