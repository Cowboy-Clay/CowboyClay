if current_state == 2 {
	var timer_text = string(floor(timer/60))
	draw_set_font(fnt_simsun_large);
	draw_set_valign(fa_middle);
	draw_set_halign(fa_center);
	draw_set_color(#ffead9);
	draw_set_alpha(1);
	var xx = camera_get_view_width(view_camera[0]) / 2;
	var yy = camera_get_view_height(view_camera[0]) / 2;
	draw_text(xx,yy,timer_text);
	
	draw_set_font(fnt_simsun);
	draw_text(xx,yy+200,"PRESS ANY BUTTON TO CONTINUE");
}
