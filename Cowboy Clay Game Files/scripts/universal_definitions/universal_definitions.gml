global.player_object = obj_player;
global.moose_object = obj_Moose;

enum Direction { LEFT, RIGHT, UP, DOWN };
enum AnimationType { LOOP, HOLD, FIRST_FRAME, REVERSE_LOOP};
enum SwordState { INACTIVE, FLYING, STUCK_FLOOR, STUCK_WALL_LEFT, STUCK_WALL_RIGHT };
enum Curve { LINEAR, PARABOLA, EXPONENTIAL, ROOT };
