//
//  GameStateManager.m
//  ballgame
//
//  Created by Ryan Hart on 8/21/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "GameStateManager.h"

@implementation GameStateManager

@synthesize currentGameStateIndex = _currentGameStateIndex, orderedGameStates=_orderedGameStates;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(GameState*)currentGameState{
    return [_orderedGameStates objectAtIndex:_currentGameStateIndex];
}


-(void)processEvent:(GameStateEvent)event withInfo:(id)info{
    
}

@end
