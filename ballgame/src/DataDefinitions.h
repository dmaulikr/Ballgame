//
//  DataDefinitions.h
//  ballgame
//
//  Created by Ryan Hart on 7/10/11.
//


#define DEBUG_DRAW 0


//UI Definitions
#define PTM_RATIO 32
#define USER_MESSAGE_FONT_SIZE 22.0
#define USER_MESSAGE_DEFAULT_LOCATION ccp([[CCDirector sharedDirector] winSize].width / 2,[[CCDirector sharedDirector] winSize].height * .9)
#define USER_MESSAGE_DEFAULT_CONTENT_SIZE CGSizeMake([[CCDirector sharedDirector] winSize].width, [[CCDirector sharedDirector] winSize].height * .2)

#define PLAYER_Z_ORDER 10
#define BACKGROUND_Z_ORDER -1
#define OBJECT_Z_ORDER 5
#define HUD_Z_ORDER 45
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
    GameObjectIDGravityWell,
    GameObjectIDChaser
} GameObjectID;

#define BACKGROUND_MUSIC @"Game1"

