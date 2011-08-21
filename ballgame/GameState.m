//
//  GameState.m
//  ballgame
//
//  Created by Ryan Hart on 8/20/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "GameState.h"

const NSString* GameStateModificationPlayerMovementEnabled = @"PlayerMovementEnabled";
const NSString* GameStateModificationPlayerMovementDisabled = @"PlayerMovementDisabled";

@implementation GameState
@synthesize gameStateModifications = _gameStateModifications, advancementConditions=_advancementConditions;
@synthesize isFinalState=_isFinalState;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(BOOL)canAdvanceGameState{
    return NO;
}
@end
