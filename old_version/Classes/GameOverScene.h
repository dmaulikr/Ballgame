//
//  GameOverScene.h
//  BallGame
//
//  Created by Alexei Gousev on 12/2/09.
//  Copyright 2009 UC Davis. All rights reserved.
//


// When you import this file, you import all the cocos2d classes

#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#include "GameState.h"


// GameOver Layer
@interface GameOver : Layer
{
	GameState *gs;
}

@property(nonatomic) GameState *gs;

// returns a Scene that contains the GameOver as the only child
+(id) scene;
+(id) sceneIntentional;

-(void) onQuit:(id) sender;
-(void) onPlay:(id) sender;
-(void) onReturn:(id) sender;
-(void) onViewHighScores:(id) sender;

@end
