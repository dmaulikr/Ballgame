//
//  GameState.h
//  ballgame
//
//  Created by Ryan Hart on 8/20/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSString* GameStateRestrictionPlayerMovement;


@interface GameState : NSObject

@property (readonly) NSDictionary *gameStateModifications;
@property (readonly) NSDictionary *advancementConditions;
@property (readonly) BOOL isFinalState;

-(BOOL)canAdvanceGameState;

@end