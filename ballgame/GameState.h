//
//  GameState.h
//  ballgame
//
//  Created by Ryan Hart on 8/20/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import <Foundation/Foundation.h>

//GameState Modifications
extern NSString* const GameStateModificationPlayerMovementEnabled;
extern NSString* const GameStateModificationPlayerMovementDisabled;
extern NSString* const GameStateModificationGrowthSpeedAdjustment;
extern NSString* const GameStateModificationAddObjectNamed;
extern NSString* const GameStateModificationRemoveObjectNamed;
extern NSString* const GameStateModificationPauseGameForDuration;
extern NSString* const GameStateModificationDisplayTextForDuration;
extern NSString* const GameStateModificationPlaySoundNamed;
extern NSString* const GameStateModificationAnimateCamera;
extern NSString* const GameStateModificationPreventPlayerDeathOnFullCharge;

//GameState Conditions
extern NSString* const GameStateConditionPlayerSizeThreshold;
extern NSString* const GameStateConditionObjectCollisionBegan;
extern NSString* const GameStateConditionObjectCollisionEnded;
extern NSString* const GameStateConditionPlayerTap;
extern NSString* const GameStateConditionWaitForDuration;
extern NSString* const GameStateConditionPauseForDuration;

@interface GameState : NSObject

@property (readonly) NSDictionary *gameStateModifications;
@property (readonly) NSDictionary *advancementConditions;
@property (readwrite) BOOL isFinalState;

-(id)initWithGameStateMods:(NSDictionary*)mods andConditions:(NSDictionary*)conditions;

-(BOOL)canAdvanceGameState;
-(BOOL)gameShouldEnd;
-(BOOL)playerWon;

//Event Handlers - Overriding these shouldn't be necessary in MOST cases.
-(void)levelBegan;
-(void)playerReachedMaximumSize:(id)player;
-(void)playerIsStuck:(id)player;
-(void)playerSizeChanged:(id)player;
-(void)playerCollided:(id)player andObject:(id)object;
-(void)playerCollisionEnded:(id)player andObject:(id)object;
-(void)playerTappedScreen:(id)touch;

//States
+(GameState*)defaultInitialState;

@end