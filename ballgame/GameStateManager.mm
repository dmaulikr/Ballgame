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
        [_delegate gameStateWillAdvance];
        _currentGameStateIndex++;
        [_delegate gameStateDidAdvance];
    }
}

//#pragma mark - Event Forwarding
//-(void)levelBegan{
//    [[self currentGameState] levelBegan];
//    [self checkForGameStateChanges];
//}
//-(void)playerReachedMaximumSize:(id)player{
//    [[self currentGameState] playerReachedMaximumSize:player];
//    [self checkForGameStateChanges];
//}
//-(void)playerIsStuck:(id)player{
//    [[self currentGameState] playerIsStuck:player];
//    [self checkForGameStateChanges];
//}
//-(void)playerSizeChanged:(id)player{
//    [[self currentGameState] playerSizeChanged:player];
//    [self checkForGameStateChanges];
//}
//-(void)playerCollided:(id)player andObject:(id)object{
//    [[self currentGameState] playerCollided:player andObject:object];
//    [self checkForGameStateChanges];
//}
//-(void)playerCollisionEnded:(id)player andObject:(id)object{
//    [[self currentGameState] playerCollisionEnded:player andObject:object];
//    [self checkForGameStateChanges];
//}
//-(void)playerTappedScreen:(id)touch{
//    [[self currentGameState] playerTappedScreen:touch];
//    [self checkForGameStateChanges];
//}

-(GameState*)currentGameState{
    return [_orderedGameStates objectAtIndex:_currentGameStateIndex];
}

-(void)dealloc{
    [_orderedGameStates release];
    [super dealloc];
}
@end
