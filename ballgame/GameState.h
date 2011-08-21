//
//  GameState.h
//  ballgame
//
//  Created by Ryan Hart on 8/20/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import <Foundation/Foundation.h>

//GameState Modifications
extern const NSString* GameStateModificationPlayerMovementEnabled;
extern const NSString* GameStateModificationPlayerMovementDisabled;

typedef enum{
    GSELevelBegan,
    GSELevelEnded,
    GSEPlayerDied,
    GSEPlayerSizeChanged,
    GSEPlayerCollided,
    GSEPlayerCollisionEnded,
    GSEPlayerTapped
} GameStateEvent;

@interface GameState : NSObject

@property (readonly) NSDictionary *gameStateModifications;
@property (readonly) NSDictionary *advancementConditions;
@property (readonly) NSInteger satisfiedConditions;
@property (readwrite) BOOL isFinalState;

-(BOOL)canAdvanceGameState;
-(BOOL)gameShouldEnd;

//States
+(GameState*)defaultInitialState;

@end