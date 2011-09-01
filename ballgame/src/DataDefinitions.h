//
//  DataDefinitions.h
//  ballgame
//
//  Created by Ryan Hart on 7/10/11.
//


//Debug Toggles
#define DEBUG_DRAW 0
#define COLLISION_DEBUG 0
#define GAME_STATE_DEBUG 0
#define INPUT_DEBUG 1

//Sound Definitions
#define BACKGROUND_MUSIC @"Game1"

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
#define PLAYER_RADIUS @"player_radius"

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

typedef enum{
    LevelStatusStarted,
    LevelStatusCompleted
} LevelStatus;



