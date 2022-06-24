// This has been deprecated and should not be used
instance_destroy(id);

frame_spr = spr_HPFrame;

first_healthbar_spr = spr_MooseHP2;
second_healthbar_spr = spr_MooseHP1;
third_healthbar_spr = spr_MooseHP2;

first_healthbar_visual_percentage = 0;
second_healthbar_visual_percentage = 0;
third_healthbar_visual_percentage = 0;

max_change_per_frame = 1/60;

bar_min_width = 0;
bar_max_width = (sprite_get_width(frame_spr)-8)/sprite_get_width(spr_MooseHP2);
