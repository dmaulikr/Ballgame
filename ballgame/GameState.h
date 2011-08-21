//
//  GameState.h
//  ballgame
//
//  Created by Ryan Hart on 8/20/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSString* GameStateModificationPlayerMovementEnabled;
extern const NSString* GameStateModificationPlayerMovementDisabled;

typedef enum{
    GSELevelBegan,
    GSELevelEnded,
    GSEPlayerDied,
    GSEPlayerSizeChanged,
    GSEPlayerMoved,
    GSEPlayerCollidedWith,
    GSEPlayerTapped
} GameStateEvent;

@interface GameState : NSObject

@property (readonly) NSDictionary *gameStateModifications;
@property (readonly) NSDictionary *advancementConditions;
@property (readonly) BOOL isFinalState;

-(BOOL)canAdvanceGameState;

@end