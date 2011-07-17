//
//  MainMenuScene.h
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


// MainMenu Layer
@interface MainMenu : Layer
{
	GameState *gs;
}

@property(nonatomic) GameState *gs;

// returns a Scene that contains the MainMenu as the only child
+(id) scene;

-(void) onQuit:(id) sender;
-(void) onPlay:(id) sender;
-(void) playGame:(id) sender;
-(void) onViewHighScores:(id) sender;
-(void) onSettings:(id) sender;

@end
