//
//  GameStateManager.m
//  ballgame
//
//  Created by Ryan Hart on 8/21/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "GameStateManager.h"
#import "GameObject.h"

NSString* const GameStateModificationsKey = @"modifications";
NSString* const GameStateConditionsKey = @"conditions";
NSString* const GameStateTypeKey = @"game_state_type";

@interface GameStateManager  ()

@end

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

-(void)generateGameStatesFromDictionaries:(NSArray *)statesInPlist{
    NSMutableArray *statesMutableDict = [NSMutableArray arrayWithCapacity:[statesInPlist count]];
    for (NSDictionary *dict in statesInPlist){
        NSDictionary *modifications = [dict valueForKey:GameStateModificationsKey];
        NSDictionary *conditions = [dict valueForKey:GameStateConditionsKey];
        Class gameStateClass = NSClassFromString([dict valueForKey:GameStateTypeKey]);
        
        GameState *gameStateObj = [[gameStateClass alloc] initWithGameStateMods:modifications andConditions:conditions];
        [statesMutableDict addObject:gameStateObj];
    }
    [[statesMutableDict lastObject] setIsFinalState:YES];
    _orderedGameStates = [statesMutableDict retain];
    
    //Call Game State Did Advance because we started the first game state
    [[self currentGameState] beginCurrentGameState];
    [_delegate gameStateDidAdvance];
}

-(void)checkForGameStateChanges{
    if ([[self currentGameState] gameShouldEnd]){
        [_delegate gameShouldEndDidSucceed:[[self currentGameState] playerWon]];
    }
    
    if ([[self currentGameState] isFinalState]){
        //This is a final state.  We won't be worrying about moving forward
        return;
    }
    if ([[self currentGameState] canAdvanceGameState]){
        [[self currentGameState] endCurrentGameState];
        [_delegate gameStateWillAdvance];
        _currentGameStateIndex++;
        [[self currentGameState] beginCurrentGameState];
        [_delegate gameStateDidAdvance];
    }
}

-(GameState*)currentGameState{
    return [_orderedGameStates objectAtIndex:_currentGameStateIndex];
}

-(void)dealloc{
    [_orderedGameStates release];
    [super dealloc];
}
@end
