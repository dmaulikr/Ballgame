//
//  GameState.m
//  ballgame
//
//  Created by Ryan Hart on 8/20/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "GameState.h"
#import "Player.h"
#import "GameObject.h"

//Modification Definitions
NSString* const GameStateModificationPlayerMovementEnabled = @"PlayerMovementEnabled";
NSString* const GameStateModificationPlayerMovementDisabled = @"PlayerMovementDisabled";
NSString* const GameStateModificationGrowthSpeedAdjustment = @"PlayerGrowthAdjustment";
NSString* const GameStateModificationAddObjectNamed = @"AddObjectNamed";
NSString* const GameStateModificationRemoveObjectNamed = @"RemoveObjectNamed";
NSString* const GameStateModificationPauseGameForDuration = @"PauseGameForDuration";
NSString* const GameStateModificationDisplayTextForDuration = @"DisplayTextForDuration";
NSString* const GameStateModificationPlaySoundNamed = @"PlaySoundNamed";
NSString* const GameStateModificationAnimateCamera = @"AnimateCamera";
NSString* const GameStateModificationPreventPlayerDeathOnFullCharge = @"FullChargeDoesntKill";

//Condition Definitions

//GameState Conditions
NSString* const GameStateConditionPlayerSizeThreshold = @"SizeThreshold";
NSString* const GameStateConditionObjectCollisionBegan = @"CollisionBegan";
NSString* const GameStateConditionObjectCollisionEnded = @"CollisionEnded";
NSString* const GameStateConditionPlayerTap = @"PlayerTapped";
NSString* const GameStateConditionWaitForDuration = @"WaitForDuration";

@interface GameState ()

@property (readonly) BOOL playerReachedMaximumSize;
@property (readonly) BOOL playerBecameStuck;
@property (readonly) BOOL playerTouchedGoal;
@property (readonly) NSMutableDictionary *satisfiedConditions;

@end 

@implementation GameState
@synthesize gameStateModifications = _gameStateModifications, advancementConditions=_advancementConditions;
@synthesize isFinalState=_isFinalState, satisfiedConditions=_satisfiedConditions;
@synthesize playerBecameStuck=_playerBecameStuck, playerReachedMaximumSize=_playerReachedMaximumSize, playerTouchedGoal=_playerTouchedGoal;

-(id)init{
    return [self initWithGameStateMods:nil andConditions:nil];
}

-(id)initWithGameStateMods:(NSDictionary*)mods andConditions:(NSDictionary*)conditions
{
    self = [super init];
    if (self) {
        
        _gameStateModifications = [mods retain];
        _advancementConditions = [conditions retain];
        
        // Initialization code here.
        _isFinalState = NO;
        _satisfiedConditions = 0;
        
        _playerReachedMaximumSize = NO;
        _playerTouchedGoal = NO;
        _playerBecameStuck = NO;
        
        _satisfiedConditions = [[NSMutableDictionary dictionaryWithCapacity:[_advancementConditions count]] retain];
        
        for (NSString *key in [_advancementConditions allKeys]){
            [_satisfiedConditions setValue:[NSNumber numberWithBool:NO] forKey:key];
        }
    }
    
    return self;
}

-(BOOL)playerWon{
    return (_playerTouchedGoal && !_playerReachedMaximumSize);
}

-(BOOL)canAdvanceGameState{
    BOOL allConditionsSatisfied = YES;
    for (NSNumber *conditionResult in [_satisfiedConditions allValues]){
        if (![conditionResult boolValue]){
            allConditionsSatisfied = NO;
            break;
        }
    }
    return allConditionsSatisfied;
}

-(BOOL)gameShouldEnd{
    return _playerBecameStuck || _playerReachedMaximumSize || [self playerWon];
}
#pragma mark - Event Handlers

-(void)beginCurrentGameState{
    //Check for any timers that need to get kicked off to satisfy duration conditions
    NSLog(@"The current game state %@ has begun", self);
}

                              
-(void)endCurrentGameState{
    NSLog(@"The current game state %@ has ended", self);
}

-(void)waitForDurationFinished{
    if ([_advancementConditions objectForKey:GameStateConditionWaitForDuration] != nil){
        NSLog(@"Wait for Duration satisfied");
        [_satisfiedConditions setValue:[NSNumber numberWithBool:YES] forKey:GameStateConditionWaitForDuration];
    }
}

-(void)levelBegan{
    
}

-(void)playerReachedMaximumSize:(id)player{
    _playerReachedMaximumSize = YES;
    if ([[[self gameStateModifications] objectForKey:GameStateModificationPreventPlayerDeathOnFullCharge] boolValue] == YES){
        _playerReachedMaximumSize = NO;
        [(Player*)player setChargeLevel:[player chargeLevel] * .5];
    }
}
-(void)playerIsStuck:(id)player{
    _playerBecameStuck = YES;
}
-(void)playerSizeChanged:(id)player{
    Player *thePlayer = (Player*)player;
    
    if ([_advancementConditions objectForKey:GameStateConditionPlayerSizeThreshold] != nil){
        //If PlayerSizeThreshold is a condition we should monitor that state
        NSDictionary *condition = [_advancementConditions objectForKey:GameStateConditionPlayerSizeThreshold];
        if (thePlayer.chargeLevel >= [[condition valueForKey:@"threshold"] floatValue]){
            [_satisfiedConditions setValue:[NSNumber numberWithBool:YES] forKey:GameStateConditionPlayerSizeThreshold];
        }
    }
}
-(void)playerCollided:(id)player andObject:(id)object{
    GameObject *gObject = (GameObject*)object;
    
    if (gObject.identifier == GameObjectIDGoal){
        _playerTouchedGoal = YES;
    }
    else if ([_advancementConditions objectForKey:GameStateConditionObjectCollisionBegan] != nil){
        NSDictionary *condition = [_advancementConditions objectForKey:GameStateConditionObjectCollisionBegan];
        if (gObject.name == [condition objectForKey:@"name"]){
            [_satisfiedConditions setValue:[NSNumber numberWithBool:YES] forKey:GameStateConditionObjectCollisionBegan];
        }
    }
}
-(void)playerCollisionEnded:(id)player andObject:(id)object{
    
}
-(void)playerTappedScreen:(id)touch{
    if ([_satisfiedConditions objectForKey:GameStateConditionPlayerTap] != nil){
        [_satisfiedConditions setObject:[NSNumber numberWithBool:YES] forKey:GameStateConditionPlayerTap];
    }
}


#pragma mark - State Factory

+(GameState*)defaultInitialState{
    return [[[GameState alloc] init] autorelease];
}

#pragma mark - Memory Management
-(void)dealloc{
    [_gameStateModifications release];
    [_advancementConditions release];
    [_satisfiedConditions release];
    [super dealloc];
}
@end
