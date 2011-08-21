//
//  GameStateManager.m
//  ballgame
//
//  Created by Ryan Hart on 8/21/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "GameStateManager.h"
#import "GameObject.h"

@implementation GameStateManager

@synthesize currentGameStateIndex = _currentGameStateIndex, orderedGameStates=_orderedGameStates, delegate=_delegate;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        _currentGameStateIndex = 0;
    }
    
    return self;
}

-(GameState*)currentGameState{
    return [_orderedGameStates objectAtIndex:_currentGameStateIndex];
}


-(void)processEvent:(GameStateEvent)event withInfo:(id)info{
    //This method just forwards events to the current game state and then decides what to do from them.
}

@end
