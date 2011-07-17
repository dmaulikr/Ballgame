//
//  DataDefinitions.h
//  ballgame
//
//  Created by Ryan Hart on 7/10/11.
//

#define PTM_RATIO 32

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
    GameObjectIDPickup
} GameObjectID;
