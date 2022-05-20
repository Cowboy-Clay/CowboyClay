current = 0;

function next() {
	current ++;
	if current > 2 current = 0;
}
function previous() {
	current --;
	if current < 0 current = 2;
}

function select() {
	switch(current) {
		case 0:
			pause();
			break;
		case 1:
			room_restart();
			break;
		case 2:
			room_goto(Menu);
			break;
	}
}
