//
//  DataDefinitions.h
//  ballgame
//
//  Created by Ryan Hart on 7/10/11.
//


#define DEBUG_DRAW 1


//UI Definitions
#define PTM_RATIO 32

#define SCROLL_BORDER 1000

#define PLAYER_Z_ORDER 10
#define BACKGROUND_Z_ORDER -1
#define OBJECT_Z_ORDER 5
#define PAUSE_MENU_Z_ORDER 50

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
    GameObjectIDChargedWall,
    GameObjectIDTeleporter,
    GameObjectIDIon,
    GameObjectIDCollectible,
    GameObjectIDBumper,
} GameObjectID;

#define BACKGROUND_MUSIC @"Game1"

