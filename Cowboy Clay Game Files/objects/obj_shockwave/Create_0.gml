in_use = false;
direct = Direction.LEFT;
lifetime = 1;
distance = 5;
timer = 0;
movement_curve = Curve.LINEAR;
x_start = 0;
y_start = 0;

function initiate(x_s, y_s, dir, tim, dis, cur) {
	x_start = x_s;
	y_start = y_s;
	x = x_start;
	y = y_start;
	
	direct = dir;
	lifetime = tim;
	distance = dis;
	movement_curve = cur;
	timer = 0;
	
	if direct == Direction.RIGHT image_xscale = -1;
	in_use = true;
}

function evaluate_distance() {
	switch movement_curve {
		case Curve.LINEAR:
			var d = distance * lerp(0,1,timer/lifetime);
			return d;
			break;
		case Curve.PARABOLA:
			var d = distance * power(lerp(0,1,timer/lifetime), 2);
			return d;
			break;
		case Curve.EXPONENTIAL:
			var d = power(d+1, lerp(0,1,timer/lifetime)) - 1;
			return d;
			break;
		case Curve.ROOT:
			var d = distance * sqrt(lerp(0,1,timer/lifetime));
			return d;
			break;
	}
}
