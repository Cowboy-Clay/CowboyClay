global.smart_control_detection = true;

global.player_object = obj_player_fighting;
global.moose_object = obj_Moose;

global.dont_stop_music_on_load = false;

enum Direction { LEFT, RIGHT, UP, DOWN };
enum AnimationType { LOOP, HOLD, FIRST_FRAME, REVERSE_LOOP};
enum animation_type { loop, hold, first_frame, loop_reverse};
enum Curve { LINEAR, PARABOLA, EXPONENTIAL, ROOT };

enum stance { neutral, fighting, sitting };