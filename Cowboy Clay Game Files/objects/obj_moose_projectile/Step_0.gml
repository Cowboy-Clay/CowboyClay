image_angle += rotation_speed;

timer++;
var t = 0;
if timer <= time_to_apex {
	t = timer / time_to_apex / 2;
} else {
	t = (timer-time_to_apex) / time_to_land / 2 + 0.5;
}

var xx = lerp(0, arc_width, t);
var yy = ((-xx*arc_height)*(xx-arc_width))/sqr(arc_width/2);

x = start_x + xx;
y = start_y + yy;

if timer > destroy_time instance_destroy(id);