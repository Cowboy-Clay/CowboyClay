var screen_width = camera_get_view_width(view_camera[0]);
var screen_height = camera_get_view_height(view_camera[0]);

// Corners
// Top left
draw_sprite_part_ext(global.ui_frame_sprite, 1, 0, 0, global.ui_frame_corner_width, global.ui_frame_corner_height, 0+frame_left_padding, 0+frame_top_padding, 1, 1, c_white, global.ui_frame_alpha);
// Top right
draw_sprite_part_ext(global.ui_frame_sprite, 1, 0, 0, global.ui_frame_corner_width, global.ui_frame_corner_height, screen_width-frame_right_padding, 0+frame_top_padding, -1, 1, c_white, global.ui_frame_alpha);
// Bottom left
draw_sprite_part_ext(global.ui_frame_sprite, 1, 0, 0, global.ui_frame_corner_width, global.ui_frame_corner_height, 0+frame_left_padding, screen_height-frame_bottom_padding, 1, -1, c_white, global.ui_frame_alpha);
// Bottom right
draw_sprite_part_ext(global.ui_frame_sprite, 1, 0, 0, global.ui_frame_corner_width, global.ui_frame_corner_height, screen_width-frame_right_padding, screen_height-frame_bottom_padding, -1, -1, c_white, global.ui_frame_alpha);

// Edges
draw_set_alpha(global.ui_frame_alpha);
// top
draw_rectangle_color(global.ui_frame_corner_width+frame_left_padding,0+frame_top_padding,screen_width-global.ui_frame_corner_width-frame_right_padding,global.ui_frame_horizontal_thickness+frame_top_padding,c_black,c_black,c_black,c_black,false);
// bottom
draw_rectangle_color(global.ui_frame_corner_width+frame_left_padding,screen_height-frame_bottom_padding,screen_width-global.ui_frame_corner_width-frame_right_padding,screen_height-global.ui_frame_horizontal_thickness-frame_bottom_padding,c_black,c_black,c_black,c_black,false);
// left
draw_rectangle_color(0+frame_left_padding,global.ui_frame_corner_height+frame_top_padding,global.ui_frame_vertical_thickness+frame_left_padding,screen_height-global.ui_frame_corner_height-frame_bottom_padding,c_black,c_black,c_black,c_black,false);
// right
draw_rectangle_color(screen_width-frame_right_padding,global.ui_frame_corner_height+frame_top_padding,screen_width-global.ui_frame_vertical_thickness-frame_right_padding,screen_height-global.ui_frame_corner_height-frame_bottom_padding,c_black,c_black,c_black,c_black,false);

// Extra padding
if frame_top_padding > 0 {
	draw_rectangle_color(0,0,screen_width,frame_top_padding-1,c_black,c_black,c_black,c_black,false);
}
if frame_left_padding > 0 {
	draw_rectangle_color(0,frame_top_padding, frame_left_padding-1,screen_height,c_black,c_black,c_black,c_black,false);
}
if frame_right_padding > 0 {
	draw_rectangle_color(screen_width,frame_top_padding, screen_width-frame_right_padding-1,screen_height,c_black,c_black,c_black,c_black,false);
}
if frame_bottom_padding > 0 {
	draw_rectangle_color(frame_left_padding, screen_height, screen_width-frame_right_padding, screen_height-frame_bottom_padding-1,c_black,c_black,c_black,c_black,false);
}