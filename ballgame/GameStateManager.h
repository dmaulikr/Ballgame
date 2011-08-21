//
//  GameStateManager.h
//  ballgame
//
//  Created by Ryan Hart on 8/21/11.
//  Copyright 2011 NoName. All rights reserved.
//

/* The GameStateManager is responsible for supplying the game loop with information
   the current game state.  Most game objects will not need to carry a pointer to the game state, but the Player object will because it is most likely to need to make a change to the game state. 
    
 Most games should have only a few game states, however, more complex design may require may different states.   
 
 Each state will have a dictionary of modifications that it may impose upon the game world such as:
 
    *Enabling/Disabling Player Movement
    *Adjusting Player Grow Speed
    *Adding and remove objects from the game world
    *Pausing the game for a duration
    *Displaying text at a location
    *Playing Sounds
    *Animating the camera for a duration
 
 Each state will also have a set of conditions that much be satisfied before the game state can be advanced such as:
 
    *The Player Taps the screen
    *The Player reaches a certain location
    *The Player reaches a certain size
    *A Duration has passed.
   
 */


#import <Foundation/Foundation.h>
#import "GameState.h"

@interface GameStateManager : NSObject

@property (readonly) NSInteger currentGameStateIndex;
@property (nonatomic, retain) NSArray *orderedGameStates;

-(GameState*)currentGameState;
-(void)advanceGameState;

@end

@protocol GameStateManagerDelegate <NSObject>

-(void)gameStateWillAdvance;
-(void)gameStateDidAdvance;

@end
