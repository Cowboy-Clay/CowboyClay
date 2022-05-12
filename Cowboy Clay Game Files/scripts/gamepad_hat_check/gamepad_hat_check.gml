function gamepad_hat_check(_direction){
	var _v = noone;
	for (var i = 0; i < gamepad_get_device_count(); i ++) {
		if gamepad_hat_value(i, 0) > 0 {
			_v = gamepad_hat_value(i, 0);
			break;
		}
	}
	
	if _v = noone return false;
	
	if _v >= 8 {
		if _direction == Direction.LEFT return true;
		_v -= 8;
	}
	if _v >= 4 {
		if _direction == Direction.DOWN return true;
		_v -= 4;
	}
	if _v >= 2 {
		if _direction == Direction.RIGHT return true;
		_v -= 2
	}
	if _v >= 1 {
		if _direction == Direction.UP return true;
		_v -= 1;
	}
	
	return false;
}