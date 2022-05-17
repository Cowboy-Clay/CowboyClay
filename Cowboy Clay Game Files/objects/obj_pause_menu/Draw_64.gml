/// @description Draw the pause menu

if global.paused {
	var _width = camera_get_view_width(view_camera[0]);
	var _height = camera_get_view_height(view_camera[0]);
	
	// Transparent black background
	draw_set_color(c_black);
	draw_set_alpha(0.8);
	draw_rectangle(0,0,_width,_height,false);
	
	// Paused text
	draw_set_color(c_white);
	draw_set_alpha(1);
	draw_sprite(spr_paused,1,_width/2,_height/6);
	
	// Draw options
	draw_sprite(current == 0 ? spr_continue_b : spr_continue, 1, _width/2, _height/2);
	draw_sprite(current == 1 ? spr_restart_b : spr_restart, 1, _width/2, _height/2+50);
	draw_sprite(current == 2 ? spr_quit_b : spr_quit, 1, _width/2, _height/2+100);
	
	draw_set_alpha(1);
}
