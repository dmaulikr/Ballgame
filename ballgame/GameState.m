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
const NSString* GameStateModificationPlayerGrowthEnabled = @"PlayerGrowthEnabled";
const NSString* GameStateModificationPlayerGrowthDisabled = @"PlayerGrowthDisabled";


@implementation GameState
@synthesize gameStateModifications = _gameStateModifications, advancementConditions=_advancementConditions;
@synthesize isFinalState=_isFinalState, satisfiedConditions=_satisfiedConditions;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        _isFinalState = NO;
        _satisfiedConditions = 0;
        
    }
    
    return self;
}

-(BOOL)canAdvanceGameState{
    return _satisfiedConditions == [_advancementConditions count];
}

-(BOOL)gameShouldEnd{
    return NO;
}

#pragma mark - State Factory

+(GameState*)defaultInitialState{
    return [[[GameState alloc] init] autorelease];
}
                        
@end
