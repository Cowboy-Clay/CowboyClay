var _center_x = camera_get_view_width(view_camera[0]) / 2;
var _y = 25;

if obj_player_fighting.current_state == PlayerState.DEAD return;

// Draw frame
//draw_sprite(frame_spr,0,_center_x,_y);
// Draw third healthbar
var _xscale = lerp(bar_min_width, bar_max_width, third_healthbar_visual_percentage);
var _yscale = (sprite_get_height(frame_spr) - 4 +3) / sprite_get_height(third_healthbar_spr);
draw_sprite_ext(third_healthbar_spr,0,_center_x,_y,_xscale,_yscale,0,-1,1);
// Draw second healthbar
_xscale = lerp(bar_min_width, bar_max_width, second_healthbar_visual_percentage);
draw_sprite_ext(second_healthbar_spr,0,_center_x,_y,_xscale,_yscale,0,-1,1);
// Draw first healthbar
var _xscale = lerp(bar_min_width, bar_max_width, first_healthbar_visual_percentage);
draw_sprite_ext(first_healthbar_spr,0,_center_x,_y,_xscale,_yscale,0,-1,1);
