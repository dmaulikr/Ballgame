//
//  DataDefinitions.h
//  ballgame
//
//  Created by Ryan Hart on 7/10/11.
//


#define DEBUG_DRAW 0


//UI Definitions
#define PTM_RATIO 32

#define SCROLL_BORDER 75
#define SCROLL_OUTER_BOUNDS 50

#define PLAYER_Z_ORDER 10
#define BACKGROUND_Z_ORDER -1
#define OBJECT_Z_ORDER 5

typedef enum{
    LevelStatusStarted,
    LevelStatusCompleted
} LevelStatus;

typedef enum {
    GameObjectIDNone,
    GameObjectIDPlayer,
    GameObjectIDWall,
    GameObjectIDObstacle,
    GameObjectIDGoal,
    GameObjectIDPickup,
    GameObjectIDSwitch,
    GameObjectIDGate,
    GameObjectIDChargedWall
} GameObjectID;
