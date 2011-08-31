//
//  DataDefinitions.h
//  ballgame
//
//  Created by Ryan Hart on 7/10/11.
//


#define DEBUG_DRAW 0
#define COLLISION_DEBUG 0
#define GAME_STATE_DEBUG 1


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

//GameDefaults Key Definitions
//These should go away when we get rid of the GameDefaults.plist
#define MAX_SPEED_KEY @"max_speed"
#define WORLD_GRAVITY_KEY @"world_gravity"

//Level Dictionary Key Definitions
//Normally I'd want these as const NSStrings but since Level isn't a class we'll just define them for now. 
#define LEVEL_NAME_KEY @"name"
#define LEVEL_HEIGHT_KEY @"level_height"
#define LEVEL_WIDTH_KEY @"level_width"
#define LEVEL_DESCRIPTION_KEY @"description"
#define GROW_RATE_KEY @"size_grow_rate"
#define START_X_KEY @"start_x"
#define START_Y_KEY @"start_y"
#define STARTING_SIZE_KEY @"starting_size"
#define WORLD_KEY @"world"
#define GAME_STATES_KEY @"game_states"
#define GAME_OBJECTS_KEY @"game_objects"
#define LEVEL_STATUS_KEY @"LevelStatus"

//Game Object Dictionary Key Definitions
#define GO_NAME_KEY @"name"
#define GO_TYPE_KEY @"type"
#define GO_FRAME_NAME @"frame_name"
#define GO_ROTATION_KEY @"rotation"
#define GO_WIDTH_KEY @"width"
#define GO_HEIGHT_KEY @"height"
#define GO_POSITIONS_KEY @"positions"
#define GO_X_KEY @"x"
#define GO_Y_KEY @"y"
#define GO_DURATION_KEY @"duration"
#define GO_MAX_CHARGE_KEY @"max_charge"
#define GO_CHARGE_PER_SEC_KEY @"charge_per_second"
#define GO_SPEED_KEY @"speed"
#define GO_CHARGE_INCR_KEY @"charge_increment"
#define GO_DEP_OBJECT_KEY @"dependant_object_name"
#define GO_POWER_KEY @"power"
#define GO_ION_SIZE_KEY @"ion_size"

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

